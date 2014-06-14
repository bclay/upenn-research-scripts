#!/usr/bin/perl
use strict;
use warnings;

open(SMALL, "<$ARGV[0]") or die "error reading $ARGV[0]";
open(OUT, ">>$ARGV[2]") or die "error reading $ARGV[2]"; 

my @temp;
my $num;

while (<SMALL>){
	chomp;
	$num = $_;
	@temp = qx (grep -w "$num" "$ARGV[1]");
	print OUT @temp;
}

close SMALL;
close OUT;