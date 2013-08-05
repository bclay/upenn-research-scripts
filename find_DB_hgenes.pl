#!/usr/bin/perl
#
# inputs
# 0: F*_altSE_best_hgenesV*.txt, output with hgenes in order
# 1: seed list
# 2: db10
# 3: output


#if it's not present in db10 or seed list, print
my %seeds;
my $hgene;
my $count;


open(SEEDS, "<$ARGV[1]") or die "error reading $ARGV[1]";

while(<SEEDS>){
	chomp;
	$seeds{$_}=1;
}

close SEEDS;
open(HGENES, "<$ARGV[0]") or die "error reading $ARGV[0]";
open(OUT, ">$ARGV[3]") or die "error reading $ARGV[3]";


while (<HGENES>){
	chomp;
	$hgene = $_;
	if (!(exists $seeds{$hgene})){
		$count = qx(grep -wc "$hgene" "$ARGV[2]");
		if ($count != 0){
			print OUT "$hgene\n";
		}
	}
}
