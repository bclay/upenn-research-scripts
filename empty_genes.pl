#!/usr/bin/perl
#adds genes to the empty list
#
#ARGS:
#0:IN:F*_altSE_best_hgenesV6.txt
#1:IN:F*_added_genes.txt
#2:BOTH:F*_empty_list.txt


use strict;
use warnings;

#variables
my %OnMap;
my %OffMap;
my $finalGene;

open(ONMAP, "<$ARGV[1]") or die "error reading $ARGV[1]";

while(<ONMAP>){
	chomp;
	$finalGene = $_;
	%OnMap{$finalGene} = 1;
}

close ONMAP;

open(OFFMAP, "<$ARGV[2]") or die "error reading $ARGV[2]";

while(<OFFMAP>){
	chomp;
	%OffMap{$_} = 1;
}

close OFFMAP;

open(LONGLIST, "<$ARGV[0]") or die "error reading $ARGV[0]";
open(OFFMAP2, ">$ARGV[2]") or die "error reading $ARGV[2]";

do{
	$hgene = <LONGLIST>;
	chomp($hgene);
	if(!(exists $OnMap{$hgene}) && !(exists $OffMap{$hgene})){
		print OFFMAP2 "$hgene";
	}
}
until ($hgene eq $finalGene);

close LONGLIST;
close OFFMAP2;
