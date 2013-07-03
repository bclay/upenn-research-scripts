#!/usr/bin/perl
use strict;
use warnings;

open(SMALL, "<$ARGV[0]") or die "error reading $ARGV[0]";
open(OUT, ">>$ARGV[2]") or die "error reading $ARGV[2]"; 

my $count;
my $num;

while (<SMALL>){
	chomp;
	$num = $_;
	$count = qx (grep -w -c "$num" "$ARGV[1]");
	print OUT "$num\t$count";
}

close SMALL;
close OUT;
