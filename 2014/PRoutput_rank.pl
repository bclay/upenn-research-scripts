#!/usr/bin/perl
#arguments
#0:F250.txt
#1:F2100.txt
#2:F21000.txt
#3:F3100.txt
#4:F31000.txt
#5:F4100.txt
#6:F41000.txt
#7:F5100.txt
#8:F51000.txt
#9:out.txt

use strict;
use warnings;

#declarations
#keeps rank count
my $rank;

#a line in an input file, with a homologene and it's PR score
my $line;

#line tokens - homologene id is 0, value is 1
my @tokens;

#a hash of arrays - keys are homologenes, values are arrays
#where the index is the arg/file #
my %HoA;

#iterate through each input file
for(my $i = 0; $i < 9; $i++){
	open(FILE, "<$ARGV[$i]") or die "error reading $ARGV[$i]";
	$rank = 0;
	my @lines = (<FILE>);
	while($rank < 200){
		$line = $lines[$rank];
		chomp $line;
		@tokens = split(/\t/,$line);
		$rank++;
		if(!exists $HoA{$tokens[0]}){
			${$HoA{$tokens[0]}}[0] = 0;
			${$HoA{$tokens[0]}}[1] = 0;
			${$HoA{$tokens[0]}}[2] = 0;
			${$HoA{$tokens[0]}}[3] = 0;
			${$HoA{$tokens[0]}}[4] = 0;
			${$HoA{$tokens[0]}}[5] = 0;
			${$HoA{$tokens[0]}}[6] = 0;
			${$HoA{$tokens[0]}}[7] = 0;
			${$HoA{$tokens[0]}}[8] = 0;

		}
		print "$i\t";
		print "$tokens[0]\t";
		print "$rank\t";
		print "${$HoA{$tokens[0]}}[$i]\n";
		
		${$HoA{$tokens[0]}}[$i] = $rank;
	}
	close FILE;
}

#open the output file
open(OUT, ">$ARGV[9]") or die "error reading $ARGV[9]";

foreach my $key (keys %HoA){
	print OUT "$key\t${$HoA{$key}}[0]\t";
	print OUT "${$HoA{$key}}[1]\t";
	print OUT "${$HoA{$key}}[2]\t";
	print OUT "${$HoA{$key}}[3]\t";
	print OUT "${$HoA{$key}}[4]\t";
	print OUT "${$HoA{$key}}[5]\t";
	print OUT "${$HoA{$key}}[6]\t";
	print OUT "${$HoA{$key}}[7]\t";
	print OUT "${$HoA{$key}}[8]\n";
}

close OUT;
