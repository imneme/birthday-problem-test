#!/bin/sh

CPLUSPLUS="clang++ -Wall -O3 -march=native -std=c++17 -g"

# Really it should be one of these... (download from llvm.org)
#CPLUSPLUS="$HOME/clang+llvm-6.0.0-x86_64-apple-darwin/bin/clang++ -O3 -march=native -std=c++17 -g"
#CPLUSPLUS="$HOME/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang++ -O3 -march=native -std=c++17 -g"
#CPLUSPLUS="$HOME/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-16.04/bin/clang++ -O3 -march=native -std=c++17 -g"

$CPLUSPLUS -o birthday.mt19937.bloomfilter birthday.cpp -DRNG_TYPE='std::mt19937' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.mt19937.bucketsort birthday.cpp -DRNG_TYPE='std::mt19937' -DUSE_BUCKETSORTING

$CPLUSPLUS -o birthday.mt19937.sort birthday.cpp -DRNG_TYPE='std::mt19937' -DUSE_SORTING

$CPLUSPLUS -o birthday.mt19937.hashtable birthday.cpp -DRNG_TYPE='std::mt19937' -DUSE_HASHTABLE

$CPLUSPLUS -o birthday.mt19937.hashtable.bump birthday.cpp -DRNG_TYPE='std::mt19937' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

$CPLUSPLUS -o birthday.minstd_rand.bloomfilter birthday.cpp -DRNG_TYPE='std::minstd_rand' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.minstd_rand.bucketsort birthday.cpp -DRNG_TYPE='std::minstd_rand' -DUSE_BUCKETSORTING

$CPLUSPLUS -o birthday.minstd_rand.sort birthday.cpp -DRNG_TYPE='std::minstd_rand' -DUSE_SORTING

$CPLUSPLUS -o birthday.minstd_rand.hashtable birthday.cpp -DRNG_TYPE='std::minstd_rand' -DUSE_HASHTABLE

$CPLUSPLUS -o birthday.minstd_rand.hashtable.bump birthday.cpp -DRNG_TYPE='std::minstd_rand' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

$CPLUSPLUS -o birthday.jsf32.bloomfilter birthday.cpp -DRNG_TYPE='jsf32' -DRNG_INCLUDE='"jsf.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.jsf32.bucketsort birthday.cpp -DRNG_TYPE='jsf32' -DRNG_INCLUDE='"jsf.hpp"' -DUSE_BUCKETSORTING -DBUCKET_BITS=8

$CPLUSPLUS -o birthday.jsf32.sort birthday.cpp -DRNG_TYPE='jsf32' -DRNG_INCLUDE='"jsf.hpp"' -DUSE_SORTING

$CPLUSPLUS -o birthday.jsf32.hashtable birthday.cpp -DRNG_TYPE='jsf32' -DRNG_INCLUDE='"jsf.hpp"' -DUSE_HASHTABLE

$CPLUSPLUS -o birthday.jsf32.hashtable.bump birthday.cpp -DRNG_TYPE='jsf32' -DRNG_INCLUDE='"jsf.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR


$CPLUSPLUS -o birthday.gjrand32.bloomfilter birthday.cpp -DRNG_TYPE='gjrand32' -DRNG_INCLUDE='"gjrand.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.gjrand32.bucketsort birthday.cpp -DRNG_TYPE='gjrand32' -DRNG_INCLUDE='"gjrand.hpp"' -DUSE_BUCKETSORTING -DBUCKET_BITS=8

$CPLUSPLUS -o birthday.gjrand32.sort birthday.cpp -DRNG_TYPE='gjrand32' -DRNG_INCLUDE='"gjrand.hpp"' -DUSE_SORTING

$CPLUSPLUS -o birthday.gjrand32.hashtable birthday.cpp -DRNG_TYPE='gjrand32' -DRNG_INCLUDE='"gjrand.hpp"' -DUSE_HASHTABLE

$CPLUSPLUS -o birthday.gjrand32.hashtable.bump birthday.cpp -DRNG_TYPE='gjrand32' -DRNG_INCLUDE='"gjrand.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

$CPLUSPLUS -o birthday.sfc32.bloomfilter birthday.cpp -DRNG_TYPE='sfc32' -DRNG_INCLUDE='"sfc.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.sfc32.bucketsort birthday.cpp -DRNG_TYPE='sfc32' -DRNG_INCLUDE='"sfc.hpp"' -DUSE_BUCKETSORTING -DBUCKET_BITS=8

$CPLUSPLUS -o birthday.sfc32.sort birthday.cpp -DRNG_TYPE='sfc32' -DRNG_INCLUDE='"sfc.hpp"' -DUSE_SORTING

$CPLUSPLUS -o birthday.sfc32.hashtable birthday.cpp -DRNG_TYPE='sfc32' -DRNG_INCLUDE='"sfc.hpp"' -DUSE_HASHTABLE

$CPLUSPLUS -o birthday.sfc32.hashtable.bump birthday.cpp -DRNG_TYPE='sfc32' -DRNG_INCLUDE='"sfc.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR




$CPLUSPLUS -o birthday.mt19937_64.bloomfilter birthday.cpp -DRNG_TYPE='std::mt19937_64' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.mt19937_64.bucketsort birthday.cpp -DRNG_TYPE='std::mt19937_64' -DUSE_BUCKETSORTING

$CPLUSPLUS -o birthday.mt19937_64.sort birthday.cpp -DRNG_TYPE='std::mt19937_64' -DUSE_SORTING 

$CPLUSPLUS -o birthday.mt19937_64.hashtable birthday.cpp -DRNG_TYPE='std::mt19937_64' -DUSE_HASHTABLE 

$CPLUSPLUS -o birthday.mt19937_64.hashtable.bump birthday.cpp -DRNG_TYPE='std::mt19937_64' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

$CPLUSPLUS -o birthday.splitmix64.bloomfilter birthday.cpp -DRNG_TYPE='SplitMix64' -DRNG_INCLUDE='"splitmix.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.splitmix64.bucketsort birthday.cpp -DRNG_TYPE='SplitMix64' -DRNG_INCLUDE='"splitmix.hpp"' -DUSE_BUCKETSORTING 

$CPLUSPLUS -o birthday.splitmix64.sort birthday.cpp -DRNG_TYPE='SplitMix64' -DRNG_INCLUDE='"splitmix.hpp"' -DUSE_SORTING

$CPLUSPLUS -o birthday.splitmix64.hashtable birthday.cpp -DRNG_TYPE='SplitMix64' -DRNG_INCLUDE='"splitmix.hpp"' -DUSE_HASHTABLE

$CPLUSPLUS -o birthday.splitmix64.hashtable.bump birthday.cpp -DRNG_TYPE='SplitMix64' -DRNG_INCLUDE='"splitmix.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

$CPLUSPLUS -o birthday.mcg128_fast.bloomfilter birthday.cpp -DRNG_TYPE='mcg128_fast' -DRNG_INCLUDE='"lehmer.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.mcg128_fast.bucketsort birthday.cpp -DRNG_TYPE='mcg128_fast' -DRNG_INCLUDE='"lehmer.hpp"' -DUSE_BUCKETSORTING

$CPLUSPLUS -o birthday.mcg128_fast.sort birthday.cpp -DRNG_TYPE='mcg128_fast' -DRNG_INCLUDE='"lehmer.hpp"' -DUSE_SORTING 

$CPLUSPLUS -o birthday.mcg128_fast.hashtable birthday.cpp -DRNG_TYPE='mcg128_fast' -DRNG_INCLUDE='"lehmer.hpp"' -DUSE_HASHTABLE 

$CPLUSPLUS -o birthday.mcg128_fast.hashtable.bump birthday.cpp -DRNG_TYPE='mcg128_fast' -DRNG_INCLUDE='"lehmer.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

$CPLUSPLUS -o birthday.mcg128.bloomfilter birthday.cpp -DRNG_TYPE='mcg128' -DRNG_INCLUDE='"lehmer.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.mcg128.bucketsort birthday.cpp -DRNG_TYPE='mcg128' -DRNG_INCLUDE='"lehmer.hpp"' -DUSE_BUCKETSORTING

$CPLUSPLUS -o birthday.mcg128.sort birthday.cpp -DRNG_TYPE='mcg128' -DRNG_INCLUDE='"lehmer.hpp"' -DUSE_SORTING 

$CPLUSPLUS -o birthday.mcg128.hashtable birthday.cpp -DRNG_TYPE='mcg128' -DRNG_INCLUDE='"lehmer.hpp"' -DUSE_HASHTABLE 

$CPLUSPLUS -o birthday.mcg128.hashtable.bump birthday.cpp -DRNG_TYPE='mcg128' -DRNG_INCLUDE='"lehmer.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

$CPLUSPLUS -o birthday.jsf64.bloomfilter birthday.cpp -DRNG_TYPE='jsf64' -DRNG_INCLUDE='"jsf.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.jsf64.bucketsort birthday.cpp -DRNG_TYPE='jsf64' -DRNG_INCLUDE='"jsf.hpp"' -DUSE_BUCKETSORTING

$CPLUSPLUS -o birthday.jsf64.sort birthday.cpp -DRNG_TYPE='jsf64' -DRNG_INCLUDE='"jsf.hpp"' -DUSE_SORTING

$CPLUSPLUS -o birthday.jsf64.hashtable birthday.cpp -DRNG_TYPE='jsf64' -DRNG_INCLUDE='"jsf.hpp"' -DUSE_HASHTABLE

$CPLUSPLUS -o birthday.jsf64.hashtable.bump birthday.cpp -DRNG_TYPE='jsf64' -DRNG_INCLUDE='"jsf.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

$CPLUSPLUS -o birthday.gjrand64.bloomfilter birthday.cpp -DRNG_TYPE='gjrand64' -DRNG_INCLUDE='"gjrand.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.gjrand64.bucketsort birthday.cpp -DRNG_TYPE='gjrand64' -DRNG_INCLUDE='"gjrand.hpp"' -DUSE_BUCKETSORTING

$CPLUSPLUS -o birthday.gjrand64.sort birthday.cpp -DRNG_TYPE='gjrand64' -DRNG_INCLUDE='"gjrand.hpp"' -DUSE_SORTING

$CPLUSPLUS -o birthday.gjrand64.hashtable birthday.cpp -DRNG_TYPE='gjrand64' -DRNG_INCLUDE='"gjrand.hpp"' -DUSE_HASHTABLE

$CPLUSPLUS -o birthday.gjrand64.hashtable.bump birthday.cpp -DRNG_TYPE='gjrand64' -DRNG_INCLUDE='"gjrand.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

$CPLUSPLUS -o birthday.sfc64.bloomfilter birthday.cpp -DRNG_TYPE='sfc64' -DRNG_INCLUDE='"sfc.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.sfc64.bucketsort birthday.cpp -DRNG_TYPE='sfc64' -DRNG_INCLUDE='"sfc.hpp"' -DUSE_BUCKETSORTING

$CPLUSPLUS -o birthday.sfc64.sort birthday.cpp -DRNG_TYPE='sfc64' -DRNG_INCLUDE='"sfc.hpp"' -DUSE_SORTING

$CPLUSPLUS -o birthday.sfc64.hashtable birthday.cpp -DRNG_TYPE='sfc64' -DRNG_INCLUDE='"sfc.hpp"' -DUSE_HASHTABLE

$CPLUSPLUS -o birthday.sfc64.hashtable.bump birthday.cpp -DRNG_TYPE='sfc64' -DRNG_INCLUDE='"sfc.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

$CPLUSPLUS -o birthday.xorshift64star32.bloomfilter birthday.cpp -DRNG_TYPE='xorshift64star32a' -DRNG_INCLUDE='"xorshift.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.xorshift64star32.bucketsort birthday.cpp -DRNG_TYPE='xorshift64star32a' -DRNG_INCLUDE='"xorshift.hpp"' -DUSE_BUCKETSORTING -DBUCKET_BITS=8

$CPLUSPLUS -o birthday.xorshift64star32.sort birthday.cpp -DRNG_TYPE='xorshift64star32a' -DRNG_INCLUDE='"xorshift.hpp"' -DUSE_SORTING

$CPLUSPLUS -o birthday.xorshift64star32.hashtable birthday.cpp -DRNG_TYPE='xorshift64star32a' -DRNG_INCLUDE='"xorshift.hpp"' -DUSE_HASHTABLE

$CPLUSPLUS -o birthday.xorshift64star32.hashtable.bump birthday.cpp -DRNG_TYPE='xorshift64star32a' -DRNG_INCLUDE='"xorshift.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

$CPLUSPLUS -o birthday.xorshift128star64.bloomfilter birthday.cpp -DRNG_TYPE='xorshift128star64a' -DRNG_INCLUDE='"xorshift.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.xorshift128star64.bucketsort birthday.cpp -DRNG_TYPE='xorshift128star64a' -DRNG_INCLUDE='"xorshift.hpp"' -DUSE_BUCKETSORTING

$CPLUSPLUS -o birthday.xorshift128star64.sort birthday.cpp -DRNG_TYPE='xorshift128star64a' -DRNG_INCLUDE='"xorshift.hpp"' -DUSE_SORTING

$CPLUSPLUS -o birthday.xorshift128star64.hashtable birthday.cpp -DRNG_TYPE='xorshift128star64a' -DRNG_INCLUDE='"xorshift.hpp"' -DUSE_HASHTABLE

$CPLUSPLUS -o birthday.xorshift128star64.hashtable.bump birthday.cpp -DRNG_TYPE='xorshift128star64a' -DRNG_INCLUDE='"xorshift.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR

for rtype in pcg32 pcg32_fast pcg64 pcg64_fast pcg32_once_insecure pcg64_once_insecure
do
$CPLUSPLUS -o birthday.$rtype.bloomfilter birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"pcg_random.hpp"' -DUSE_BLOOMFILTER -Ipcg-cpp-master/include
$CPLUSPLUS -o birthday.$rtype.bucketsort birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"pcg_random.hpp"' -DUSE_BUCKETSORTING -DBUCKET_BITS=8 -Ipcg-cpp-master/include
$CPLUSPLUS -o birthday.$rtype.sort birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"pcg_random.hpp"' -DUSE_SORTING -Ipcg-cpp-master/include
$CPLUSPLUS -o birthday.$rtype.hashtable birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"pcg_random.hpp"' -DUSE_HASHTABLE -Ipcg-cpp-master/include
$CPLUSPLUS -o birthday.$rtype.hashtable.bump birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"pcg_random.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR -Ipcg-cpp-master/include
done

for rtype in pcg64 pcg64_fast pcg64_once_insecure
do
$CPLUSPLUS -o birthday.$rtype.bucketsort birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"pcg_random.hpp"' -DUSE_BUCKETSORTING -Ipcg-cpp-master/include
done

for rtype in xoroshiro64plus32 xoroshiro64star32 xoroshiro64starstar32 xoroshiro128plus64 xoroshiro128starstar64
do
$CPLUSPLUS -o birthday.$rtype.bloomfilter birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"xoroshiro.hpp"' -DUSE_BLOOMFILTER
$CPLUSPLUS -o birthday.$rtype.bucketsort birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"xoroshiro.hpp"' -DUSE_BUCKETSORTING -DBUCKET_BITS=8
$CPLUSPLUS -o birthday.$rtype.sort birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"xoroshiro.hpp"' -DUSE_SORTING
$CPLUSPLUS -o birthday.$rtype.hashtable birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"xoroshiro.hpp"' -DUSE_HASHTABLE
$CPLUSPLUS -o birthday.$rtype.hashtable.bump birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"xoroshiro.hpp"' -DUSE_HASHTABLE -DHASHTABLE_INCLUDE='<unordered_set>' -DHASHTABLE_TYPE='unordered_bump_set' -DUSE_BUMP_ALLOCATOR
done

for rtype in xoroshiro128plus64 xoroshiro128starstar64
do
$CPLUSPLUS -o birthday.$rtype.bucketsort birthday.cpp -DRNG_TYPE=$rtype -DRNG_INCLUDE='"xoroshiro.hpp"' -DUSE_BUCKETSORTING
done

$CPLUSPLUS -o birthday.minstddiv3.sort birthday.cpp -DRNG_TYPE='divided_rng<regularized_rng<std::minstd_rand,uint32_t>,3>'  -DUSE_SORTING

$CPLUSPLUS -o birthday.minstddiv31.sort birthday.cpp -DRNG_TYPE='divided_rng<regularized_rng<std::minstd_rand,uint32_t>,31>'  -DUSE_SORTING

$CPLUSPLUS -o birthday.mt19937div32.sort birthday.cpp -DRNG_TYPE='divided_rng<std::mt19937,32>'  -DUSE_SORTING

$CPLUSPLUS -o birthday.spitmix64skip65536.sort birthday.cpp -DRNG_TYPE='skipping_rng<SplitMix64,65536>'  -DUSE_SORTING -DRNG_INCLUDE='"splitmix.hpp"'


$CPLUSPLUS -o birthday.splitmix64div2.bloomfilter birthday.cpp -DRNG_TYPE='divided_rng<SplitMix64,2>' -DRNG_INCLUDE='"splitmix.hpp"' -DUSE_BLOOMFILTER

$CPLUSPLUS -o birthday.xoroshiro64plus32doubled.bloomfilter birthday.cpp -DRNG_TYPE='doubled_rng<xoroshiro64plus32,uint64_t>'  -DUSE_BLOOMFILTER -DRNG_INCLUDE='"xoroshiro.hpp"'

$CPLUSPLUS -o birthday.xoroshiro64star32doubled.bloomfilter birthday.cpp -DRNG_TYPE='doubled_rng<xoroshiro64star32,uint64_t>'  -DUSE_BLOOMFILTER -DRNG_INCLUDE='"xoroshiro.hpp"'

$CPLUSPLUS -o birthday.xoroshiro32star16doubled.bloomfilter birthday.cpp -DRNG_TYPE='doubled_rng<xoroshiro32star16,uint32_t>'  -DUSE_BLOOMFILTER -DRNG_INCLUDE='"xoroshiro.hpp"'

$CPLUSPLUS -o birthday.xorshift32star16doubled.bloomfilter birthday.cpp -DRNG_TYPE='doubled_rng<xorshift32star16a,uint32_t>'  -DUSE_BLOOMFILTER -DRNG_INCLUDE='"xorshift.hpp"'

$CPLUSPLUS -o birthday.xorshift64star32doubled.bloomfilter birthday.cpp -DRNG_TYPE='doubled_rng<xorshift64star32a,uint64_t>'  -DUSE_BLOOMFILTER -DRNG_INCLUDE='"xorshift.hpp"'

$CPLUSPLUS -o birthday.xorshift32plain16doubled.bloomfilter birthday.cpp -DRNG_TYPE='doubled_rng<xorshift_detail::xorshift<uint32_t, uint16_t, 6, 17, 9>,uint32_t>'  -DUSE_BLOOMFILTER -DRNG_INCLUDE='"xorshift.hpp"'

$CPLUSPLUS -o birthday.xorshift64plain32doubled.sort birthday.cpp -DRNG_TYPE='doubled_rng<xorshift_detail::xorshift<uint64_t, uint32_t, 11, 31, 18>,uint32_t>'  -DUSE_SORTING -DRNG_INCLUDE='"xorshift.hpp"'
