#!/usr/bin/perl
#6/17/14
#objective: 
#0: # of genes in list
#1: table with ordered SE output: col 1 is gene ID, col 2 is rating, 
#   col 3 is normalized rating

use strict;
use warnings;
use Graph::Centrality::Pagerank;
use Data::Dump qw(dump);


#declare variables
my $li = [];
my $nw = {};
my $lineNW;
my @tokensNW;
my @temp;
my @tokensDB;
my $count =0;
#read in the node weights
open(NW, "<$ARGV[0]") or die "error reading $ARGV[0]";


while(<NW>){
	if ($count <=100){
	chomp;
	$lineNW = $_;
	@tokensNW = split(/\t/, $lineNW);
	#assign the normalized node weight to the homologene ID
	$nw->{$tokensNW[0]} = $tokensNW[2];

	#search the database for any entries containing this node
	@temp = qx (grep -w "$tokensNW[0]" "$ARGV[1]");
	foreach my $lineDB (@temp){
		@tokensDB = split(/\t/, $lineDB);
		push(@$li,[$tokensDB[0],$tokensDB[1]]);
	}
	$count++;
	print "$tokensNW[0]\n";
}}

close NW;


open(OUT, ">$ARGV[2]") or die "error reading $ARGV[2]";


my $r = Graph::Centrality::Pagerank->new();


$r->getPagerankOfNodes (listOfEdges => $li, nodeWeights => $nw);
my $hgene;
for (keys %$r){
	$hgene = $_;
	print OUT "$hgene\t";
	print OUT $r->{$hgene};
	print OUT "\n";
}

close OUT;
