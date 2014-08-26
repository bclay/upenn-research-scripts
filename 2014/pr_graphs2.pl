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
my @nw;
my $count =0;
my @homologenes;
my @temp2;
my @hgenes2;
my @temparr;
my @hgenes;
my @tokens;
#read in the node weights
open(NW, "<$ARGV[1]") or die "error reading $ARGV[1]";

while(<NW>){
	if ($count <=$ARGV[0]){
	chomp;
	$lineNW = $_;
	@tokensNW = split(/\t/, $lineNW);
	push(@nw, $tokensNW[0]);
	$count++;
}}
close NW;

open(OUT, ">$ARGV[3]") or die "error reading $ARGV[3]";

push(@hgenes,@nw);
foreach my $hgene1 (@nw){
shift (@hgenes);
@temparr = qx (grep -w "$hgene1" "$ARGV[2]");
if (@temparr){
for my $hgene2 (@hgenes){
for my $line (@temparr){
@tokens = split(/\t/, $line);
if ($tokens[0] eq $hgene2 && $tokens[1] eq $hgene1){
print OUT $line;
}
elsif ($tokens[1] eq $hgene2 && $tokens[0] eq $hgene1){
print OUT $line;
}
}
}
}
}

close OUT;
