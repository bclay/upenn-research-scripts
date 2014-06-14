#!/usr/bin/perl
#uses ENTREZ ids to find homologenes

use strict;
use warnings;

open(SMALL, "<$ARGV[0]") or die "error reading $ARGV[0]";


my $entrezid;
my @lines;
my @cols;

while (<SMALL>) {
	chomp;
	$entrezid = $_;
	@lines = qx (grep -w "$entrezid" "$ARGV[1]");
	if (@lines){
	@cols = split(/\t/, $lines[0]);
	if (@cols){
		print $cols[0] . "\n";
	}
	}
}

close SMALL;