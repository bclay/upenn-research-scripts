#!/usr/bin/perl
#looks for tf in a given list
#first arg is query

use strict;
use warnings;

open(SMALL, "<$ARGV[0]") or die "error reading $ARGV[0]";
open(OUT, ">$ARGV[2]") or die "error reading to $ARGV[2]";

my $line;
my @hgene;
my @temp;

while (<SMALL>){
	chomp;
	$line = $_;
	@hgene = split(/\t/, $line);
	@temp = qx (grep -w "$hgene[0]" "$ARGV[1]");
	if (@temp){
		print OUT $line . "\n";
	}
}
