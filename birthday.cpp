/*
 * A C++ implementation of a Birthday-Problem PRNG test
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2018 Melissa E. O'Neill
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#include <cstddef>
#include <cstdint>
#include <cstdlib>
#include <cassert>
#include <cmath>
#include <iostream>
#include <iomanip>
#include <random>
#include <algorithm>
#include <chrono>

#include "rng_adapters.hpp"
#include "timer.hpp"

#ifdef RNG_INCLUDE
    #include RNG_INCLUDE
#endif

#ifndef RNG_TYPE
    #define RNG_TYPE std::mt19937
#endif



#if USE_SORTING
template <typename RNG>
unsigned int count_repeats(RNG& rng, size_t expanse)
{
    using rngval_t = typename RNG::result_type;

    Timer overall("- Testing for repeats");
    // Allocate an array to hold all the output.
    Timer allocation("  - Allocating memory");
    std::cout << "    - allocated array of size " << expanse << ".\n";
    rngval_t* values = new rngval_t[expanse];
    allocation.done();

    
    // Store all the output from the generator.
    Timer storage("  - Storing PRNG output");
    for (size_t i = 0; i < expanse; ++i) {
	values[i] = rng();
    }
    storage.done();

    // Sort the array
    Timer sorting("  - Sorting");
    std::sort(values, values+expanse);
    sorting.done();
    
    // Scan the array for duplicates
    Timer scanning("  - Scanning for duplicates");
    rngval_t prev = values[0];
    size_t duplicates = 0;
    for (size_t i = 1; i < expanse; ++i) {
	rngval_t curr = values[i];
	if (prev == curr) {
	    std::cout << "    - repeat of " << curr << " found\n";
	    ++duplicates;
	}
	prev = curr;
    }
    scanning.done();
    overall.done();
    
    return duplicates;
}
#elif USE_BUCKETSORTING
template <typename RNG>
unsigned int count_repeats(RNG& rng, size_t expanse)
{
    using rngval_t = typename RNG::result_type;
#ifndef BUCKET_BITS
    constexpr unsigned int BUCKET_BITS = sizeof(rngval_t)*2;
#endif
    constexpr size_t BUCKETS = size_t(1) << BUCKET_BITS;
    constexpr size_t BUCKET_MASK = BUCKETS - 1;
    size_t bucket_size = (expanse + expanse/4) / BUCKETS;
    
    Timer overall("- Testing for repeats");
    // Allocate an array to hold all the output.
    Timer allocation("  - Allocating memory");
    rngval_t* values = new rngval_t[bucket_size * BUCKETS];
    std::cout << "    - allocated " << BUCKETS << " buckets of capacity "
	      << bucket_size << "\n";
    rngval_t* counts = new rngval_t[BUCKETS] {};
    std::cout << "    - allocated " << BUCKETS << " bucket counters\n";
    allocation.done();

    // Store all the output from the generator.
    Timer storage("  - Storing PRNG output");
    for (rngval_t i = 0; i < expanse; ++i) {
	rngval_t rngval = rng();
	rngval_t bucket = rngval & BUCKET_MASK;
	rngval_t index  = counts[bucket]++;
	values[bucket * bucket_size + index] = rngval;
    }
    storage.done();

    // Sort the buckets
    Timer sorting("  - Sorting");
    for (rngval_t i = 0; i < BUCKETS; ++i) 
	std::sort(&values[i*bucket_size], &values[i*bucket_size+counts[i]]);
    sorting.done();
    
    // Scane the array for duplicates
    Timer scanning("  - Scanning for duplicates");
    rngval_t duplicates = 0;
    for (rngval_t i = 0; i < BUCKETS; ++i) {
	rngval_t prev = values[i*bucket_size];
	for (uint64_t j = 1; j < counts[i]; ++j) {
	    uint64_t curr = values[i*bucket_size+j];
	    if (prev == curr) {
		std::cout << "    - repeat of " << curr << " found\n";
		++duplicates;
	    }
	    prev = curr;
	}
    }
    scanning.done();
    overall.done();
    
    return duplicates;
}
#elif USE_HASHTABLE

#ifndef HASHTABLE_INCLUDE
    #include <unordered_set>
    #define HASHTABLE_TYPE std::unordered_set
#else
    #include HASHTABLE_INCLUDE
#endif

#if USE_BUMP_ALLOCATOR
    #include "bump_allocator.hpp"
#endif

template <typename RNG>
unsigned int count_repeats(RNG& rng, size_t expanse)
{
    using rngval_t = typename RNG::result_type;

    Timer overall("- Testing for repeats");
    // Allocate an array to hold all the output.
    Timer allocation("  - Allocating memory");
    std::cout << "    - allocated hash table of reserved for " << expanse
	      << " elements\n";
    HASHTABLE_TYPE<rngval_t> sample;
    sample.reserve(expanse);
    allocation.done();

    
    // Store all the output from the generator.
    Timer checking("  - Checking PRNG output");
    uint64_t duplicates = 0;
    for (size_t i = 0; i < expanse; ++i) {
        auto rval = rng();
	auto result = sample.insert(rval);
	if (!result.second) {
	    std::cout << "    - repeat of " << rval << " found, step " << i
		      << "\n";
	    ++duplicates;
	}
    }
    checking.done();
    overall.done();
    
    return duplicates;
}
#elif USE_BLOOMFILTER

#include "linearprobe_map.hpp"

template <typename RNG>
unsigned int count_repeats(RNG& rng, size_t expanse)
{
    using rngval_t      = typename RNG::result_type;
    using possibility_t = uint64_t;
    constexpr unsigned int SUBINDEX_BITS = sizeof(possibility_t) * 8;
    
    Timer overall("- Testing for repeats");
    size_t bloom_shift = ceil(log2(expanse*1.22)) - 4;
    size_t bloom_size  = size_t(1) << bloom_shift;
    size_t bloom_mask  = bloom_size - 1;
    size_t candidates_size = bloom_size >> 1;
    
    // Allocate an array to hold all the output.
    Timer allocation("  - Allocating memory");
    possibility_t* possibles = new possibility_t[bloom_size];
    auto bloom_hash_bits =
	round(log(2) * bloom_size * SUBINDEX_BITS / expanse / 1.3);
    std::cout << "    - allocated bloomish filter with " << bloom_size
	      << " 64-bit elements (" << bloom_hash_bits << " bits/entry)\n";
    rngval_t* candidates = new rngval_t[candidates_size];
    std::cout << "    - allocated possible-match log with " << candidates_size
	      << " " << sizeof(rngval_t)*8 << "-bit elements\n";
    allocation.done();

    auto rng_copy = rng;
    
    // Store all the output from the generator.
    Timer phase1("  - Phase 1, Gathering repeat candidates");
    uint64_t duplicates = 0;
    size_t count = 0;
    for (size_t i = 0; i < expanse; ++i) {
	auto rng_val = rng();
	size_t index = rng_val & bloom_mask;
	possibility_t mask = 0;
	auto top = rng_val >> bloom_shift;
	for (int j = 0; j < bloom_hash_bits; ++j) {
            possibility_t bit;
            for(;;) {
		bit = possibility_t(1) << (top % SUBINDEX_BITS);
		if ((mask & bit) == 0 || top == 0)
		    break;
		top /= SUBINDEX_BITS;
	    }
	    mask |= bit;
	}
	if ((possibles[index] & mask) == mask) {
	    candidates[count++] = rng_val;
	    if (count > candidates_size) {
		printf("- FAIL, too many repeat candidates\n");
		exit(1);
	    }
	}
	possibles[index] |= mask;
    }
    std::cout << "    - " << count << " repeat candidates found\n";
    phase1.done();

    Timer realloc("  - Reallocating memory");
    delete[] possibles;
    std::cout << "    - Deallocated bloomish filter\n";
    linearprobe_map<rngval_t, uint8_t> watched(bloom_size);
    std::cout << "    - Allocated hash table of the same size\n";
    realloc.done();

    Timer phase2("  - Phase 2, Storing candidates in hash table");
    for (size_t i = 0; i < count; ++i) {
	watched.set(candidates[i]);
    }
    delete[] candidates;
    phase2.done();

    Timer phase3("  - Phase 3, Testing candidates");
    for (uint64_t i = 0; i < expanse; ++i) {
	auto rng_val = rng_copy();
	auto valuep = watched.fetch(rng_val);
	if (!valuep)
	    continue;
	if ((*valuep)++) {
	    std::cout << "    - repeat of " << rng_val << " found, step " << i
		      << "\n";
	    ++duplicates;
	}
    }
    phase3.done();
		 
    overall.done();

    return duplicates;
}
#else
    #error No technique specified
#endif

#define STRINGIFY_HELPER(...) #__VA_ARGS__
#define STRINGIFY(...)        STRINGIFY_HELPER(__VA_ARGS__)

int main(int argc, const char* argv[]) {
    long double desired = 0.01l;
    if (argc >= 2) {
	desired = strtold(argv[1], nullptr);
	assert(desired > 0.0l);
    }
    
    double factor = (desired < 1.0)
	              ? sqrt(-2.0l*log(desired))	// p-value
	              : sqrt(2.0l*desired);		// expected repeats
/*	
	3.0348542587702927017;  // 99.000% repeat chance, sqrt(-2*log(0.01))
	2.1459660262893472396;  // 90.000% repeat chance, sqrt(-2*log(0.1))
	1.6651092223153955127;  // 75.000% repeat chance, sqrt(-2*log(0.25))
	1.1774100225154746910;  // 50.000% repeat chance, sqrt(-2*log(0.5))
	0.1417768376957353439;  //  1.000% repeat chance, sqrt(-2*log(0.99)
	3;                      // 98.889% repeat chance
	2.5;                    // 95.606% repeat chance
	2;                      // 86.466% repeat chance
	1.5;                    // 67.535% repeat chance
	1;                      // 39.347% repeat chance
	0.5;                    // 11.750% repeat chance
	0.001;                  //  0.00005% repeat chance
*/	

    long double rng_range = 1.0l + RNG_TYPE::max() - RNG_TYPE::min();
    size_t sample_size = ceil(factor * sqrt(rng_range));
    long double expected = // pow(0.0l+sample_size,2.0l)/(rng_range*2.0l);
      sample_size - rng_range * (- expm1(sample_size*log1p(-1/rng_range)));
    float p_zero   = exp(-expected);

    std::cout << "Testing " << STRINGIFY(RNG_TYPE) << "\n";
    std::cout << "\t" << RNG_TYPE::min() << ".."
	      << RNG_TYPE::max() << " is range of generator\n";
    std::cout << "\t" << sample_size << " outputs to scan for duplicates ["
              << factor << "*sqrt(range)]\n";
    std::cout << "\t" << expected << " duplicates expected on average\n";
    std::cout << "\t" << p_zero << " is probability of zero duplicates\n";
    uint32_t seed = std::random_device{}();
    std::cout << "\t0x" << std::hex << seed << std::dec
	      << " is seed for this run\n";
    
    std::cout << "---\n";

    RNG_TYPE rng(seed);
    size_t repeats = count_repeats(rng, sample_size);

    std::cout << "---\n";

    std::cout << repeats << " repeats, p-value = ";

    long double p_value = 0;
    for (size_t k = 0; k <= repeats; ++k) {
	long double pdf_value =
	    exp(log(expected)*k - expected - lgamma(1.0l+k));
	p_value += pdf_value;
	// std::cout << "# " << tgamma(1.0l+k) << ", " << exp(-expected) << "\n";
	if (p_value > 0.5)
	    p_value = p_value - 1;
    }
    if (p_value < 0)
	std::cout << "1 - " << -p_value << "\n";
    else
	std::cout << p_value << "\n";
    
}
