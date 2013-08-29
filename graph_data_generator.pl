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
use IPC::System::Simple qw(system capture);


#variables
my $count = 0;
my %InitList;

#import a list of genes (on Arda figure and genes that have already been added)
open (INITLIST, "ARGV[0]") or die "error reading $ARGV[0]";
while (<INITLIST>){
	chomp;
	my $hgene1 = $_;
	$InitList{$hgnene1} = 1;
}

#import the list of genes to add
open (TOADD, "ARGV[1]") or die "error reading $ARGV[1]";
while (<TOADD> && $count < 10){
  	chomp;
	$hgene2 = $_;



	#run the map1 perl script
	local @ARGV = ("", "");

	my $str = "F2_" . $hgene2 . "_M1.txt";
	#read an R script
	my $R = Statistics::R->new();
	$R->startR;
	$R-> send(q'd <-read.delim("$str",header=F)');
	$R-> send(q'source("./../../../../upenn_research_scripts/Arda_stat_generator.r")');
	$R->stop();
	$count++;
}
