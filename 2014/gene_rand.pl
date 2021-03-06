#!/usr/bin/perl
#6/17/14
#objective: output a list of x random genes
#0: # of genes in list
#1: organism gene info downloaded from BCBC
#2: output file

use strict;
use warnings;

open(DATAFILE, "<$ARGV[1]") or die "error reading $ARGV[1]";

#variable declaration
my $line;
my @tokens;
my @genes;
my %HoI;
my $randInt;

#read the input file and store all gene names in an array
while (<DATAFILE>){
	chomp;
	$line = $_;
	@tokens = split (/\t/, $line);
	push (@genes, $tokens[2]);
}
close DATAFILE;

open(OUT, ">$ARGV[2]") or die "error reading $ARGV[2]";
=begin
sub eqCheck {
	if (exists $HoI{$randInt}){
		0;
	}
	else{
		1;
	}
	while(eqCheck $randInt){
		$randInt = int(rand($ARGV[0]));
	}
}
=cut
for (my $i = 0; $i < $ARGV[0]; $i++){
	$randInt = int(rand(scalar @genes));
	
	if (index($genes[$randInt],":") || index($genes[$randInt], ";")){
		$randInt = int(rand(scalar @genes));
	}

	print OUT "$genes[$randInt]\n"
}
close OUT;