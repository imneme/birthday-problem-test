#!/bin/sh

ECHO=echo
RM="rm -f"

if [ ! -e .have_gists ]
then
   $ECHO "PRNGs and adapters aren't downloaded."
   exit 1
fi

$ECHO 'Removing PRNGs and adapters...'

$RM rng_adapters.hpp
$RM lehmer.hpp jsf.hpp gjrand.hpp  sfc.hpp xoroshiro.hpp xorshift.hpp
$RM -r pcg-cpp-master

$RM .have_gists
