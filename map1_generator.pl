#!/usr/bin/perl
use strict;
use warnings;

open(SMALL, "<$ARGV[0]") or die "error reading $ARGV[0]";

my @homologenes;
my @temp2;
my @hgenes2;
my @temparr;
my @hgenes;
my @tokens;

while (<SMALL>){
	chomp;
	push (@homologenes, $_);
}

close SMALL;
open(OUT, ">>$ARGV[2]") or die "error reading $ARGV[2]"; 

@hgenes = @homologenes;

foreach my $hgene1 (@homologenes){
	shift (@hgenes);
	@temparr = qx (grep -w "$hgene1" "$ARGV[1]");
	if (@temparr){
		for my $hgene2 (@hgenes){
			for my $line (@temparr){
				@tokens = split(/\t/, $line);
				if ($tokens[0] eq $hgene2){
					print OUT $line;
				}
				if ($tokens[1] eq $hgene2){
					print OUT $line;
				}
			}
		}
	}
}



close OUT;
