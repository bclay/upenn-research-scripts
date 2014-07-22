#!/usr/bin/perl
#0:full file

use strict;
use warnings;
use Statistics::Basic qw(:all nofill);

my $hgene;
my @hgenes;

open(INPUT, "<$ARGV[1]") or die "error reading $ARGV[0]";
while(<INPUT>){
	chomp;
	$hgene = $_;
	push(@hgenes; $hgene);
}



open(FULL, "<$ARGV[0]") or die "error reading $ARGV[0]";

my $line;
my @tokens;
my $count = 0;
my $deg_sum = 0;
my $apsp_sum = 0;
my $cc_sum = 0;
my @deg_arr;
my @apsp_arr;
my @cc_arr;

while (<FULL>){
	chomp;
	$line = $_;
	@tokens = split(/\t/, $line);
	$count++;

	if (@hgenes contains $tokens[0]) {
		print "REMOVING $tokens[0]\n"
	} else {
		if ($count>1){
	$deg_sum = $deg_sum + $tokens[1];
	$apsp_sum = $apsp_sum + $tokens[2];
	$cc_sum = $cc_sum + $tokens[3];
	push(@deg_arr, $tokens[1]);
	push(@apsp_arr, $tokens[2]);
	push(@cc_arr, $tokens[3]);
	}

	
}
}

my $deg_avg = $deg_sum/$count;
my $apsp_avg = $apsp_sum/$count;
my $cc_avg = $cc_sum/$count;
my $deg_std = stddev(@deg_arr);
my $apsp_std = stddev(@apsp_arr);
my $cc_std = stddev(@cc_arr);


print "$count\t$deg_avg\t$apsp_avg\t$cc_avg\n";
print "$count\t$deg_std\t$apsp_std\t$cc_std\n";

close FULL;
