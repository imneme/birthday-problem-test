#ifndef INT_HASH_HPP_INCLUDED
#define INT_HASH_HPP_INCLUDED 1


// This hash map doesn't try to be STL compatible (that'd involve too
// many compromise for this very simple data structure).

template <typename Key, typename Value>
class linearprobe_map {
    Key*   keys_    = nullptr;
    Value* values_  = nullptr;
    size_t mask_    = 0;
    bool   hasZero_ = false;

    static constexpr Key ZERO = Key{};

    size_t round_pow2(size_t x) {
	--x;
	for (size_t i = 1; i < sizeof(x) * 8; i *= 2)
	    x |= x >> i;
	return ++x;
    }
    
public:
    linearprobe_map(size_t table_size)
    {
	size_t rounded_size = round_pow2(table_size);
	mask_ = rounded_size-1;
	values_ = new Value[rounded_size+1] {};
	++values_;
	keys_   = new Key[rounded_size] {};
    }

    ~linearprobe_map()
    {
	--values_;
	delete[] values_;
	values_ = nullptr;
	delete[] keys_;
	keys_ = nullptr;
	mask_ = 0;
    }

    void set(Key key)
    {
	if (key == ZERO) {
	    hasZero_ = true;
	    return;
	}
	auto bucket = key & mask_;
	while (keys_[bucket] != ZERO) {
	    if (keys_[bucket] == key)
		return;
	    ++bucket;
	    bucket &= mask_;
	}
	keys_[bucket] = key;
    }

    Value* fetch(Key key)
    {
	auto bucket = key & mask_;
	while (keys_[bucket] != ZERO) {
	    if (keys_[bucket] == key)
		return &values_[bucket];
	    ++bucket;
	    bucket &= mask_;
	}
	return ((key == ZERO) && hasZero_) ? &values_[-1] : nullptr;
    }    
};


#endif // INT_HASH_HPP_INCLUDED
