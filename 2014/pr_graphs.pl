#!/usr/bin/perl
#8/24/14
#objective: 
#0: # of genes in list
#1: table with ordered SE output: col 1 is gene ID, col 2 is rating, 
#   col 3 is normalized rating
#2: DB10
#3: out

use strict;
use warnings;
use Graph::Centrality::Pagerank;
#use Data::Dump qw(dump);
use Scalar::Util qw(reftype);
use Data::Dump;

#declare variables
my $li = [];
my $lineNW;
my @tokensNW;
my @temp;
my @tokensDB;
my $count =0;
#read in the node weights
open(NW, "<$ARGV[1]") or die "error reading $ARGV[1]";
open(OUT, ">$ARGV[3]") or die "error reading $ARGV[1]";

while(<NW>){
	if ($count <=$ARGV[0]){
	chomp;
	$lineNW = $_;
	@tokensNW = split(/\t/, $lineNW);
	#search the database for any entries containing this node
	@temp = qx (grep -w "$tokensNW[0]" "$ARGV[2]");
	print OUT @temp;
	foreach my $lineDB (@temp){
		@tokensDB = split(/\t/, $lineDB);
		push(@$li,[$tokensDB[0],$tokensDB[1]]);
	}
	$count++;
	#print "$tokensNW[0]\n";
}}

close NW;
