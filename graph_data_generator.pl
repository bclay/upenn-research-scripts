#!/usr/bin/perl
#adds genes one-by-one to a list for an Arda figure, then generates map1 and runs an R script on that
#the final result is a tab-delimited table with datapoints
#
#
#ARGS:
#0:IN:intital gene list
#1:IN:results list (genes to add)
#2:IN:DB
#
#OUT:combined list of genes
#OUT:table with graph stats


use strict;
use warnings;
use Statistics::R;


#variables
my $count = 0;

#import a list of genes (on Arda figure and genes that have already been added)
open (INITLIST, "ARGV[0]") or die "error reading $ARGV[0]";
while (<INITLIST>){
	my $hgene1 = $_;
	


}

#import the list of genes to add
open (TOADD, "ARGV[1]") or die "error reading $ARGV[1]";
while (<TOADD> && $count < 10){
  
	$count++;
}



#read an R script
my $R = Statistics::R->new();
#$R->[command]
$R->stop();
