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
my %AddList;
my $hgene2;
my $hgene1;
my $str;

#import a list of genes (on Arda figure and genes that have already been added)
open (INITLIST, "<$ARGV[0]") or die "error reading $ARGV[0]";
while (<INITLIST>){
	chomp;
	$hgene1 = $_;
	$InitList{$hgene1} = 1;
	#print $hgene1 . "\t$InitList{$hgene1}\n";
}
close INITLIST;

#import the list of genes to add
open (TOADD, "<$ARGV[1]") or die "error reading $ARGV[1]";
do{
	$hgene2 = <TOADD>;
  	chomp($hgene2);
	#print "\t\t" . $hgene2;
	if (!(exists $InitList{$hgene2}) && !(exists $AddList{$hgene2})){
		$AddList{$hgene2} = 1;
	
		$str = "F2_" . $hgene2 . "_M1.txt";
		print $str . "\n";
=comment
		#run the map1 perl script
		local @ARGV = ("map1_generator.pl", "F2_added_hgenes.txt", "Database1v10.txt", "$str");
		system("perl", @ARGV);


		#read an R script
		my $R = Statistics::R->new();
		$R->startR;
		$R-> send(q'd <-read.delim("$str",header=F)');
		$R-> send(q'source("./../../../../upenn_research_scripts/Arda_stat_generator.r")');
		$R->stop();
=cut
		$count++; 
	}
}
until eof || $count == 10;
close TOADD;

=comment
#update the initlist
open (INITLIST2, ">$ARGV[0]") or die "error reading $ARGV[0]";

foreach my $key (keys %{$AddList}){
	print INITLIST2 "$key\n";
}

close INITLIST2;
=cut

