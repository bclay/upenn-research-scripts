#takes a list of gene node stats from navigator (hgene ID and degree)
#ouputs their degrees
#also the average overall degree
#args
#0:input hgene list
#1:node stat file
#2:output

use strict;
use warnings;

#initialize variables
my $hgene;
my %HoHG;
my $sum;
my $count;
my $line;
my @tokens;

open (HGENES, "<$ARGV[0]") or die "error reading $ARGV[0]";

while(<HGENES>){
	chomp;
	$hgene = $_;
	$HoHG{$hgene} = 1;
}	
close HGENES;

open (NODESTAT, "<$ARGV[1]") or die "error reading $ARGV[1]";
open (OUT, ">$ARGV[2]") or die "error reading $ARGV[2]";
$sum = 0;
$count = 0;
while(<NODESTAT>){
	chomp;
	$line = $_;
	@tokens = split(/\t/, $line);	


	#look for input list
	if(exists $HoHG{$tokens[0]}){
		print OUT "$line\n";
	}
	if($tokens[1] ne "Degree"){
	#get the average degree
	$sum = $sum + $tokens[1];
	$count++;
}
}
close NODESTAT;
close OUT;

print $sum/$count;
