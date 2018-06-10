#ifndef BUMP_ALLOCATOR_INCLUDED
#define BUMP_ALLOCATOR_INCLUDED 1

// Bump Allocation.  Usable but has some noisy output and should be
// improved in a variaty of ways, but good enough for use here. 
// Based on ideas by Howard Hinnant, specially short_alloc.h.
//
// Copyright (c) 2018 Melissa O'Neill.  MIT License, but should not
// be used in other code without futher refinement.

#include <new>
#include <memory>
#include <typeinfo>
#include <cxxabi.h>
#include <forward_list>
#include <unistd.h>
#include <sys/mman.h>


template <typename T>
static const char* name_for_type()
{
    static char* buffer = (char*) malloc(512);
    static size_t buffer_size = 512;

    return abi::__cxa_demangle(typeid(T).name(), buffer, &buffer_size,
			       nullptr);
}

static void* large_alloc(size_t size)
{
#if USE_BIG_PAGES
    #ifndef MAP_HUGETLB
        #error No Huge/Super page support
    #endif
    void* alloc = mmap(0, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, 0, 0);
    if (alloc == MAP_FAILED)
	throw std::bad_alloc();
    
    return alloc;
#else
    return ::operator new(size);
#endif
}

static void large_free(void* addr, size_t size)
{
#if USE_BIG_PAGES
    int err = munmap(addr, size);
    assert(err == 0);
#else
    return ::operator delete(addr);
#endif
}
    


template <std::size_t N, std::size_t alignment = alignof(std::max_align_t)>
class mempool
{
    static_assert(alignment <= alignof(std::max_align_t),
		  "Alignment can be at most that of std::max_align_t");
    
    char* ptr_;
    char* end_;
    std::forward_list<char*> chunks_;

public:
    ~mempool() {
	ptr_ = nullptr;
	end_ = nullptr;
	while (!chunks_.empty()) {
	    auto chunkptr = chunks_.front();
	    chunks_.pop_front();
	    fprintf(stderr, "- mempool at %p deallocated chunk at %p\n", this, chunkptr);
	    large_free(chunkptr, N);
	}
    }
    
    mempool() noexcept
    {
	alloc_chunk();
    }

    void alloc_chunk()
    {
	ptr_ = static_cast<char*>(large_alloc(N));
	end_ = ptr_ + N;
	chunks_.push_front(ptr_);
	fprintf(stderr, "- mempool at %p allocated new chunk at %p\n", this, ptr_);
    }
	
    mempool(const mempool&) = delete;
    mempool& operator=(const mempool&) = delete;

    template <std::size_t ReqAlign> void* allocate(std::size_t n);

    void deallocate(void* p, std::size_t n) noexcept;

    static constexpr std::size_t size() noexcept
    {
	return N;
    }

    std::size_t remaining() const noexcept
    {
	return static_cast<std::size_t>(end_ - ptr_);
    }

private:
    static std::size_t align_up(std::size_t n) noexcept
    {
	return (n + (alignment-1)) & ~(alignment-1);
    }
};

template <std::size_t N, std::size_t alignment>
template <std::size_t ReqAlign>
void* mempool<N, alignment>::allocate(std::size_t n)
{
    static_assert(ReqAlign <= alignment, "alignment is too small for this arena");
    assert(ptr_ != nullptr && "short_alloc has outlived arena");
    if (n > N/2) {
	auto result = large_alloc(n);
	fprintf(stderr, "- mempool at %p: large alloc %zd bytes at %p.\n",
		this, n, result);
	return result;
    }

    auto bumped_ptr = ptr_ + align_up(n);
    if (bumped_ptr > end_) {
	alloc_chunk();
	bumped_ptr = ptr_ + align_up(n);
	assert((bumped_ptr <= end_) && "odd: can't happen");
    }
    void* alloc = static_cast<void*>(ptr_);
    ptr_ = bumped_ptr;
    return alloc;
}

template <std::size_t N, std::size_t alignment>
void mempool<N, alignment>::deallocate(void* p, std::size_t n) noexcept
{
    if (n > N/2) {
	fprintf(stderr, "- mempool at %p: large dealloc %zd bytes at %p.\n",
		this, n, p);
	large_free(p, n);
    }
}

mempool<(size_t(1) << 30),8> global_mempool;


template <typename T>
struct bump_allocator_static {
    size_t allocator_count_    = 0;

    size_t total_allocations_  = 0;
    size_t active_allocations_ = 0;
    size_t high_allocations_   = 0;

    size_t total_mem_  = 0;
    size_t active_mem_ = 0;
    size_t high_mem_   = 0;
    
    // std::allocator<T> std_alloc_;
    
    T* allocate(size_t n, const void *hint=0)
    {
	++total_allocations_;
	++active_allocations_;
	if (active_allocations_ > high_allocations_)
	    high_allocations_ = active_allocations_;
	size_t bytes = n*sizeof(T);
	total_mem_  += bytes;
	active_mem_ += bytes;
	if (active_mem_ > high_mem_)
	    high_mem_ = active_mem_;
	// return std_alloc_.allocate(n, hint);
	auto result = global_mempool.allocate<alignof(T)>(bytes);
	// fprintf(stderr, "- %p: alloc %zd bytes at %p.\n", this, bytes, result);
	return static_cast<T*>(result);
    }

    void deallocate(T* p, size_t n)
    {
	--active_allocations_;
	size_t bytes = n*sizeof(T);
	active_mem_ -= bytes;
	// fprintf(stderr, "- %p: dealloc %zd bytes at %p.\n", this, bytes, p);
	// std_alloc_.deallocate(p, n);
	global_mempool.deallocate(p, bytes);
    }
        
    bump_allocator_static() noexcept
    {
	fprintf(stderr, "- bump_allocator_static< %s > (item size = %zu) at %p created!\n",
		name_for_type<T>(), sizeof(T), this);
    }
    
    ~bump_allocator_static() noexcept
    {
	fprintf(stderr, "- bump_allocator_static< %s > at %p destroyed!\n",
		name_for_type<T>(), this);
	fprintf(stderr, " - total_allocations_  = %zu\n", total_allocations_);
	fprintf(stderr, " - active_allocations_ = %zu\n", active_allocations_);
	fprintf(stderr, " - high_allocations_   = %zu\n", high_allocations_);
	fprintf(stderr, " - total_mem_  = %zu\n", total_mem_);
	fprintf(stderr, " - active_mem_ = %zu\n", active_mem_);
	fprintf(stderr, " - high_mem_   = %zu\n", high_mem_);
    }

};

template <typename T>
class bump_allocator
{
private:
    static bump_allocator_static<T> real_allocator_;

    template <typename U> friend class bump_allocator;
    
public:
    typedef T value_type;

    typedef std::false_type propagate_on_container_copy_assignment;
    typedef std::true_type  propagate_on_container_move_assignment;
    typedef std::true_type  propagate_on_container_swap;
    typedef std::false_type is_always_equal;

    T* allocate(size_t n, const void *hint=0)
    {
	return real_allocator_.allocate(n, hint);
    }

    void deallocate(T* p, size_t n)
    {
	return real_allocator_.deallocate(p,n);
    }

//#define dbg2_printf(...) fprintf(stderr, __VA_ARGS__)
#define dbg2_printf(...)
    
    bump_allocator() noexcept {
	dbg2_printf("- bump_allocator< %s > (item size = %zu) at %p created!\n",
		name_for_type<T>(), sizeof(T), this);
    }

    bump_allocator(const bump_allocator& orig) noexcept
    {
	dbg2_printf("- bump_allocator< %s > (item size = %zu) at %p copied from %p!\n",
		name_for_type<T>(), sizeof(T), this, &orig);
	// Nothing (else) to do.
    }

    template <class U>
    bump_allocator(const bump_allocator<U>& orig) noexcept
    {
	dbg2_printf("- bump_allocator< %s > (item size = %zu) at %p created based on %p\n",
		name_for_type<T>(), sizeof(T), this, &orig);
	// Nothing (else) to do.
    }
    
    ~bump_allocator() noexcept
    {
	dbg2_printf("- bump_allocator< %s > at %p destroyed!\n",
		name_for_type<T>(), this);
    }
};

template <typename T>
bump_allocator_static<T> bump_allocator<T>::real_allocator_;

template <typename T>
using unordered_bump_set =
    std::unordered_set<T, std::hash<T>, std::equal_to<T>, bump_allocator<T>>;

#endif // BUMP_ALLOCATOR_INCLUDED
