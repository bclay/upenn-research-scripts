use strict;
use warnings;

open(SMALL, "<$ARGV[0]") or die "error reading $ARGV[0]";
open(OUT, ">$ARGV[2]") or die "error writing to $ARGV[2]";


my $hgene;
my @lines;
my @cols;
my $wrongLine;

while (<SMALL>) {
	chomp;
	$hgene = $_;
	$wrongLine = 0;
	@lines = qx (grep -w "$hgene" "$ARGV[1]");
	foreach my $thisLine (@lines){
		@cols = split(/\t/, $thisLine);
		if (@cols && $hgene eq $cols[0] && $wrongLine == 0){
			print OUT $cols[2];
			$wrongLine = 1;
		}
	}
}

close SMALL;

#awk '$1=="4177" || $2=="10090"' filename
#awk '$1="$hgene"' "$ARGV[1]" | awk '$2="10090"'
