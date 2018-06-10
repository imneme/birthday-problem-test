#!/usr/bin/perl -w

use strict;

use Getopt::Long;

my ($opt_sort, $opt_hash, $opt_bloom) = (0,0,0);

GetOptions ("sort"  => \$opt_sort,
	    "hash"  => \$opt_hash,
	    "bloom" => \$opt_bloom);

die "$0: pick just one option\n" if ($opt_sort + $opt_hash + $opt_bloom > 1);

$opt_sort = 1 if ($opt_sort + $opt_hash + $opt_bloom == 0);

sub median(@) {
    return (sort { $::a <=> $::b } @_)[@_/2];
}

sub roundify($) {
    my ($value) = (@_);

    return $value unless ($value =~ m/^\d+[e.]/ and $value =~ m/\.\d{5}/);
    my $neater = sprintf("%.5f", $value);
    return $neater unless ($neater =~ m/^0\.0000/);
    $neater = sprintf("%.3g", $value);
    $neater =~ s/(e-?)0/$1/;
    return $neater;
}

my %data;
my %shortnameFor = (
    "Storing PRNG output"     => "Storing",
    "Phase 1, Gathering repeat candidates" => "Candidates",
    "Reallocating memory"     => "Realloc",
    "Phase 2, Storing candidates in hash table" => "Storing to Hash",
    "Phase 3, Testing candidates" => "Rechecking",
    "Allocating memory"       => "Allocation",
    "Checking PRNG output"    => "Checking",
    "Sorting"                 => "Sorting",
    "Scanning for duplicates" => "Scanning",
    "Testing for repeats"     => "Total",
    );

my @ordering;

if ($opt_sort) {
    @ordering = ("Storing", "Sorting", "Scanning", "Total", "Repeats", "p-value");
} elsif ($opt_hash) {
    @ordering = ("Checking", "Total", "Repeats", "p-value");
} elsif ($opt_bloom) {
    @ordering = ("Candidates", "Rechecking", "Total", "Repeats", "p-value");
} else {
    die "Huh?\n";
}

foreach my $file (@ARGV) {
    open my $fh, '<', $file or die "Can't open '$file', $!\n";

    my $case = $file; 
    $case =~ s/^.*?birthday\.//; 
    $case =~ s/\.\w+\.\w+\.\d+\.out\z//; 
    while (<$fh>) {
	chomp;
	if (m/^[\s-]*(.*?) completed \((\S+) seconds\)/) {
	    my $activity;
	    $activity = $shortnameFor{$1};
	    die "Unknown activity $1" unless defined $activity;
	    push @{$data{$case}{$activity}}, $2;
	} elsif (m/(\d+) repeats, p-value = (.*)/) {
	    push @{$data{$case}{"Repeats"}}, $1;
	    push @{$data{$case}{"p-value"}}, eval($2);
	}
    }
}

print join("\t", "Scheme", @ordering), "\n";

foreach my $case (sort keys %data) {
    print join("\t", "`$case`", 
	       map { roundify(median @{$data{$case}{$_}}) } @ordering), "\n";
}
