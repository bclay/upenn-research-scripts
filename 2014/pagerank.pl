#!/usr/bin/perl
#6/17/14
#objective: output a list of x random genes
#0: # of genes in list
#1: table with ordered SE output: col 1 is gene ID, col 2 is rating, col 3 is normalized rating

use strict;
use warnings;
use Graph::Centrality::Pagerank;
use Data::Dump qw(dump);

open(OUT, ">$ARGV[0]") or die "error reading $ARGV[0]";

my $r = Graph::Centrality::Pagerank->new();
my $li = [[1,2],[3,4]];
$r->getPagerankOfNodes (listOfEdges => $li);


close OUT;
