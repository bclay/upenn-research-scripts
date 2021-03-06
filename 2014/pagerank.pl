#!/usr/bin/perl
#6/17/14
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
my $nw = {};
my $lineNW;
my @tokensNW;
my @temp;
my @tokensDB;
my $count =0;
#read in the node weights
open(NW, "<$ARGV[1]") or die "error reading $ARGV[1]";



while(<NW>){
	if ($count <=$ARGV[0]){
	chomp;
	$lineNW = $_;
	@tokensNW = split(/\t/, $lineNW);
	#assign the normalized node weight to the homologene ID
	$nw->{$tokensNW[0]} = $tokensNW[2];

	#search the database for any entries containing this node
	@temp = qx (grep -w "$tokensNW[0]" "$ARGV[2]");
	foreach my $lineDB (@temp){
		@tokensDB = split(/\t/, $lineDB);
		push(@$li,[$tokensDB[0],$tokensDB[1]]);
	}
	$count++;
	#print "$tokensNW[0]\n";
}}

close NW;


#open(OUT, ">$ARGV[2]") or die "error reading $ARGV[2]";


my $r = Graph::Centrality::Pagerank->new();


dd $r->getPagerankOfNodes (listOfEdges => $li, nodeWeights => $nw);

=pod
#print ref($r);
#print "\n\n\n\n";
#print reftype($r);

my $hgene;
print ref($r->{"defaultParameters"});
#print $r->{819};
for (keys %$r){
	$hgene = $_;
	print "$hgene\t";
	print $r->{$hgene};
	print "\n";
}

print "the keys...", sort keys %{$r->{"defaultParameters"}}, "...\n";

#close OUT; 
=cut
