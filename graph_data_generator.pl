#!/usr/bin/perl
#adds genes one-by-one to a list for an Arda figure, then generates map1 and runs an R script on that
#the final result is a tab-delimited table with datapoints
#
#
#ARGS:
#0:IN:intital gene list
#1:IN:results list (genes to add)
#2:IN:list of hgenes with no values in graph
#3:IN:DB
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
my %IgnoreList;
my $hgene2;
my $hgene1;
my $hgene3;
my $str;
my @lines;

#import a list of genes (on Arda figure and genes that have already been added)
open (INITLIST, "<$ARGV[0]") or die "error reading $ARGV[0]";
while (<INITLIST>){
	chomp;
	$hgene1 = $_;
	$InitList{$hgene1} = 1;
	#print $hgene1 . "\t$InitList{$hgene1}\n";
}
close INITLIST;

#import a list of genes (genes to be ignored)
open (IGNORELIST, "<$ARGV[2]") or die "error reading $ARGV[2]";
while (<IGNORELIST>){
	chomp;
	$hgene3 = $_;
	$IgnoreList{$hgene3} = 1;
	#print $hgene1 . "\t$InitList{$hgene1}\n";
}
close IGNORELIST;

#import the list of genes to add
open (TOADD, "<$ARGV[1]") or die "error reading $ARGV[1]";
open (ADDTO, ">>$ARGV[0]") or die "error reading $ARGV[0]";

do{
	$hgene2 = <TOADD>;
  	chomp($hgene2);
	#print "\t\t" . $hgene2 . "\n";
	if (!(exists $InitList{$hgene2}) && !(exists $AddList{$hgene2}) && !(exists $IgnoreList{$hgene2})){
		@lines = qx (grep -w "$hgene2" "$ARGV[3]");
		if (@lines){
		
		$AddList{$hgene2} = 1;
	
		$str = "F2_" . $hgene2 . "_M1.txt";
		print $str . "\n";

		#add current hgene to file
		print ADDTO "$hgene2\n";

		#run the map1 perl script
		local @ARGV = ("map1_generator.pl", "F2_added_hgenes.txt", "Database1v10.txt", "$str");
		system("perl", @ARGV);

		$str = "./" . $str;
		#read an R script
		my $R = Statistics::R->new();
		$R->startR;
		$R-> send(qq'd <-read.delim("$str",header=F)');
		#my $command = q'd <-read.delim("./$str",header=F)';
		#print "Running [$command]\n";
		#$R->send($command);
		$R-> send(q'source("./Arda_stat_generator.r")');
		my $output = $R->get('rstr');
		print "$output";
		$R->stop();
=comment
=cut
		$count++;
		}	
		else{
			#add to empty list
		}
	}
}
until eof || $count == 2;
close TOADD;
close ADDTO;

=comment
#update the initlist
open (INITLIST2, ">$ARGV[0]") or die "error reading $ARGV[0]";

foreach my $key (keys %{$AddList}){
	print INITLIST2 "$key\n";
}

close INITLIST2;
=cut

