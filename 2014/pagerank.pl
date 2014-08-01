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

#open(OUT, ">$ARGV[0]") or die "error reading $ARGV[0]";

my $r = Graph::Centrality::Pagerank->new();
my $li = [[1,2],[2,3]];
my $nw = {};
$nw->{1} = 0.9;
$nw->{2} = 0.1;
$nw->{3} = 0.1;
dump $r->getPagerankOfNodes (listOfEdges => $li, nodeWeights => $nw);


#close OUT;
