#/usr/bin/perl
#8/4/14
#objective: style pagerank output - sort list so most important values appear at the top of the list
#args
#0: unsorted data
#1: outfile for sorted data

use strict;
use warnings;

#declare variables
my $line;
my @tokens;
my @value;
my %HoG;

open(IN, "<$ARGV[0]") or die "error reading $ARGV[0]";

while(<IN>){
	chomp;
	$line = $_;
	if ($line ne "{" && $line ne "}"){
		#parse the line and save info in a data structure
		@tokens = split(' ', $line);
		@value = split(',', $tokens[2]);
		$HoG{$tokens[0]} = $value[0];
	}
}

close IN;
open(OUT, ">$ARGV[1]") or die "error opening $ARGV[1]";

foreach my $key (sort {$HoG{$b} <=> $HoG{$a}} keys %HoG){
	print OUT "$key\t$HoG{$key}\n";
}
