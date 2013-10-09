
#adds genes one-by-one to a list for an Arda figure, then generates map1 and runs an R script on that
#the final result is a tab-delimited table with datapoints
#
#
#ARGS:
#0:IN:intital gene list
#1:IN:results list (genes to add)
#2:IN:list of hgenes with no values in graph
#3:IN:DB
#4:OUT:table with graph stats
#5:OUT:CC
#6:OUT:APL
#7:BOTH:Intermediate (outV-.txt)

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
my @newIgnore;
my @Rstats;
my @OneRstat;

my $addedLen = 0;

#import a list of genes (on Arda figure and genes that have already been added)
open (INITLIST, "<$ARGV[0]") or die "error reading $ARGV[0]";
while (<INITLIST>){
	chomp;
	$addedLen++;
	$hgene1 = $_;
	$InitList{$hgene1} = $addedLen;
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
			#generate the temp file
			open (TEMP, ">$ARGV[7]") or die "error reading $ARGV[7]";
			foreach my $key (keys %InitList){
				print TEMP "$key\n";
			}	
			print TEMP "$hgene2\n";
			close TEMP;

			#make new map file
			$str = "F4_" . $hgene2 . "_M1.txt";
			print $str . "\n";
			$str = "./file_dump/" . $str;


			#run the map1 perl script
			local @ARGV = ("map1_generator.pl", "$ARGV[7]", "Database1v10.txt", "$str");
			system("perl", @ARGV);


			#read an R script
			my $R = Statistics::R->new();
			$R->startR;
			$R-> send(qq'd <-read.delim("$str",header=F)');
			#my $command = q'd <-read.delim("./$str",header=F)';
			#print "Running [$command]\n";
			#$R->send($command);
			$R-> send(q'source("./Arda_stat_generator.r")');
			my $z = $R-> get('z');
			#my $output = $R->get('rstr');
			#$R -> send('cat(z, "\t", y, "\t", x, "\t", w, "\t", v, "\t", t, "\t", s, "\t", r, "\n")');
			#properly locate genes that don't add edges to the network
			if($z > $addedLen){

				#add current hgene to file
				print ADDTO "$hgene2\n";
				$InitList{$hgene2} = 1;
				$R -> send('cat(z,y,x,w,v,t,s,r,"\n")');
				my $output = $R -> read();
				$output = $hgene2 . " " . $output;
				$count++;
				$addedLen++;
				push(@Rstats, $output);
			}
			else
			#add to empty list
			{
				push(@newIgnore, $hgene2);
				
			}
			
			#print the table
			$R->stop();
		}	
		else{
			#add to empty list
			push(@newIgnore, $hgene2);
		}
	}
}
until eof || $count == 888888888888888888888888888888888888888888888888888888888888888888888888888888880;
close TOADD;
close ADDTO;


open (IGNORELIST2, ">>$ARGV[2]") or die "error reading $ARGV[2]";

foreach (@newIgnore){
	print IGNORELIST2 "$_\n";
}

close IGNORELIST2;


open (RStatTable, ">>$ARGV[4]") or die "error reading $ARGV[4]";
open (RStatCC, ">>$ARGV[5]") or die "error reading $ARGV[5]";
open (RStatAPL, ">>$ARGV[6]") or die "error reading $ARGV[6]";


foreach (@Rstats){
	print RStatTable "$_\n";
	@OneRstat = split(/ /, $_);
	#print "$OneRstat[5]";
	print RStatCC "$OneRstat[1]\t$OneRstat[5]\n";
	print RStatAPL "$OneRstat[1]\t$OneRstat[8]\n";
}

close RStatTable;
close RStatCC;
close RStatAPL;

=comment
#update the initlist
open (INITLIST2, ">$ARGV[0]") or die "error reading $ARGV[0]";

foreach my $key (keys %{$AddList}){
	print INITLIST2 "$key\n";
}

close INITLIST2;
=cut

