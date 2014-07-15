#!/usr/bin/perl
#0:full file

use strict;
use warnings;

open(FULL, "<$ARGV[0]") or die "error reading $ARGV[0]";

my $line;
my @tokens;
my $count = 0;
my $deg_sum = 0;
my $apsp_sum = 0;
my $cc_sum = 0;

while (<FULL>){
	chomp;
	$line = $_;
	@tokens = split(/\t/, $line);
	$count++;
	if ($count>1){
	$deg_sum = $deg_sum + $tokens[1];
	$apsp_sum = $apsp_sum + $tokens[2];
	$cc_sum = $cc_sum + $tokens[3];
}
}

my $deg_avg = $deg_sum/$count;
my $apsp_avg = $apsp_sum/$count;
my $cc_avg = $cc_sum/$count;

print "$count\t$deg_avg\t$apsp_avg\t$cc_avg\n";

close FULL;
