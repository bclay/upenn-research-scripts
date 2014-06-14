#!/usr/bin/perl
#6/13/14
#objective: input a few genes and output a clear comparison of their expression profiles
#args:
#0: very short list of homologenes (tinyhgene_F*.txt)
#1: homologenecomparisonvalues.txt
#2: ComparisonTable-data
#3: output file

use strict;
use warnings

open(HGENES, "<$ARGV[0]") or die "error reading $ARGV[0]";

#declare variables
my $hgene;
my @temp;
my $line;
my @tokens;
my %HoProf

#parse the initial gene list and save in a data strcture
while(<HGENES>){
	chomp;

	#initialize hgene variable
	$hgene = $_;

	#find all lines in hcv with that hgene
	@temp = qx(grep -w "$hgene" "$ARGV[1]");

	#create a hash with comparison id keys and aggregate profiles
	foreach (@temp){
		chomp;

		#initialize line variable
		$line = $_;

		#split each line into tokens where [hgene,compID,cell value]
		@tokens = split(/\t/,$line);

		#if the comparison id already exists
		if (exists $HoProf{$tokens[1]}){
			push (@{$HoProf{$tokens[1]}}, $tokens[2]);
		}
		#if the comparison id is novel
		else{
			$HoProf{$tokens[1]} = [$tokens[2]];
		}
	}
}
close HGENES;

#if the comparison profile is the same

#prepare output
foreach