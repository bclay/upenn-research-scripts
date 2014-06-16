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
my $maxLen = 0;
my @temp;
my $line;
my @tokens;
my %HoProf;
my $key;
my @value;
my $cat;


my @comptable;
my $line2;
my @tokens2;

#parse the initial gene list and save in a data strcture
while(<HGENES>){
	chomp;

	#initialize hgene variable
	$hgene = $_;

	#increment count
	++$maxLen;

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

#module that sorts profiles into categories
#0: completely the same
#>0 && <1: some gaps, but otherwise the same
#1-maxLen: 1 diff, # depending on location
#>maxLen: too many diffs to matter
sub sorter{
	
}

#parses data strcuture to sort by profile similarity
while(($key,@value) = each %HoProf){
	$cat = sorter @value;
}




open(OUT1, ">$ARGV[3]") or die "error opening $ARGV[3]";

#prepare output
foreach my $key2 (keys %HoProf){
	@comptable = qx(grep -w "$key2" "ARGV[2]");
	foreach(@comptable){
		chomp;
		$line2 = $_;
		@tokens2 = split (/\t/, $line2);
		if ($tokens2[0] eq $key2){
			print OUT1 "$tokens2[0]\ttokens2[2]\t";
			print OUT1 "@{$HoProf{$key2}}\n";
		}
	}
}

close OUT1;