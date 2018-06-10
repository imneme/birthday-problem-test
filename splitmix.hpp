#ifndef SPLITMIX_HPP_INCLUDED
#define SPLITMIX_HPP_INCLUDED 1

struct SplitMix64 {
    using result_type = uint64_t;

    template <typename T>
    static inline T xor_shift(uint32_t bits, T value) {
	return value ^ (value >> bits);
    }

// Population count (Hamming weight) taken from
// https://en.wikipedia.org/wiki/Hamming_weight
    static inline int pop_count(uint64_t x) {
	const uint64_t m1  = 0x5555555555555555; //binary: 0101...
	const uint64_t m2  = 0x3333333333333333; //binary: 00110011..
	const uint64_t m4  = 0x0f0f0f0f0f0f0f0f; //binary:  4 zeros,  4 ones ...
	const uint64_t h01 = 0x0101010101010101; //the sum of 256 to the power of 0,1,2,3...
	
	x -= (x >> 1) & m1;             //put count of each 2 bits into those 2 bits
	x = (x & m2) + ((x >> 2) & m2); //put count of each 4 bits into those 4 bits
	x = (x + (x >> 4)) & m4;        //put count of each 8 bits into those 8 bits
	return (x * h01) >> 56;         //returns left 8 bits of x + (x<<8) + (x<<16) + (x<<24) + ...
    }
    

    static constexpr uint64_t min() { return 0; };
    static constexpr uint64_t max() { return ~uint64_t(0); };


    uint64_t seed_;
    uint64_t gamma_;

    SplitMix64(uint64_t seed, uint64_t gamma = 5700357409661599242)
	: seed_(seed), gamma_(gamma | 1)
    {
	// Nothing (else) to do.
    }

    static uint64_t mix64(uint64_t v0) {
	uint64_t v1 = xor_shift(33, v0) * 0xff51afd7ed558ccd;
	uint64_t v2 = xor_shift(33, v1) * 0xc4ceb9fe1a85ec53;
	return xor_shift(33,v2);
    }

    static uint32_t mix32(uint64_t v0) {
	uint64_t v1 = xor_shift(33, v0) * 0xff51afd7ed558ccd;
	uint64_t v2 = xor_shift(33, v1) * 0xc4ceb9fe1a85ec53;
	return v2 >> 32;
    }

    static inline uint64_t mix64variant13(uint64_t v0) {
	uint64_t v1 = xor_shift(30, v0) * 0xbf58476d1ce4e5b9;
	uint64_t v2 = xor_shift(27, v1) * 0x94d049bb133111eb;
	return xor_shift(31, v2);
    }

    static uint64_t mix_gamma(uint64_t value) {
	uint64_t mixed_gamma = mix64variant13(value) | 1;
	int bit_count = pop_count(xor_shift(1, mixed_gamma));
	if (bit_count >= 24) {
	    return mixed_gamma ^ 0xaaaaaaaaaaaaaaaa;
	}
	return mixed_gamma;
    }

    void advance() {
	seed_ += gamma_;
    }

    uint64_t next_seed() {
	uint64_t result = seed_;
	advance();
	return result;
    }

    uint32_t next_int32() {
	return mix32(next_seed());
    }

    uint64_t next_int64() {
	return mix64(next_seed());
    }

    uint64_t operator()() {
	return next_int64();
    }

    SplitMix64 split() {
	uint64_t new_seed = next_int64();
	uint64_t new_gamma = mix_gamma(next_seed());
	return { new_seed, new_gamma };
    }

    bool operator==(const SplitMix64& rhs) {
	return (seed_ == rhs.seed_) && (gamma_ == rhs.gamma_);
    }
};

#endif // SPLITMIX_HPP_INCLUDED
