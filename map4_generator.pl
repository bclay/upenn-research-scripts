#!/usr/bin/perl
#uses hash tables to find three levels of structure

use strict;
use warnings;

open(SMALL, "<$ARGV[0]") or die "error reading $ARGV[0]";

my $GO_hgene; #an hgene from the initial list
my @GO_nums; #array of hgenes from the initial list
my $GO_hgene2; #an hgene from @GO_nums
my %HoA;
my @hgenes;
my @temp;
my @tokens;
my $otherhgene;
my @temp2;
my $otherhgene2;
my @tokens2;
my $hgene1;

# make an array @GO_nums so 2 files aren't being read at the same time
while (<SMALL>){
	chomp;
	$GO_hgene = $_;
	push (@GO_nums, $GO_hgene);
}

close SMALL;
open(HGENES, "+>>$ARGV[3]") or die "error opening $ARGV[3]";
# makes the primary hash table
foreach (@GO_nums){
	$GO_hgene2 = $_;
	@temp = qx (grep -w "$GO_hgene2" "$ARGV[1]");
	if (@temp){
		$HoA{$GO_hgene2} = [@temp];
		foreach my $line (@temp){
			@tokens = split(/\t/, $line);
			if ($tokens[0] eq $GO_hgene2){
				$otherhgene = $tokens[1];
				if (!(qx(grep -w "$otherhgene" "$ARGV[3]")) && !(qx(grep -w "$otherhgene" "$ARGV[0]"))){
					print HGENES $otherhgene . "\n";
				}
			}
			elsif ($tokens[1] eq $GO_hgene2){
				$otherhgene = $tokens[0];
				if (!(qx(grep -w "$otherhgene" "$ARGV[3]")) && !(qx(grep -w "$otherhgene" "$ARGV[0]"))){
					print HGENES $otherhgene . "\n";
				}
			}
		}
	}
}
close HGENES;
open (HGENES1, "<$ARGV[3]") or die "error opening $ARGV[3]";
open(OUT, ">>$ARGV[2]") or die "error reading $ARGV[2]";
# prints that second layer's connections without connections to each other
foreach (<HGENES1>){
	chomp;
	$hgene1 = $_;
	@temp2 = qx (grep -w "$hgene1" "$ARGV[1]");
	foreach my $line2 (@temp2){
		@tokens2 = split(/\t/, $line2);
		if ($tokens2[0] eq $hgene1){
			$otherhgene2 = $tokens2[1];
			if (!(qx(grep -w "$otherhgene2" "$ARGV[3]"))){
				print OUT $line2;
			}
		}
		elsif ($tokens2[1] eq $hgene1){
			$otherhgene2 = $tokens2[1];
			if (!(qx(grep -w "$otherhgene2" "$ARGV[3]"))){
				print OUT $line2;
			}
		}
	}
}
close HGENES1;

foreach my $hgene2 (keys %HoA){
	print OUT @{$HoA{$hgene2}};
}
close OUT;
