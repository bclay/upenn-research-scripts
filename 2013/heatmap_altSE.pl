#!/usr/bin/perl
#determines comparison IDs of importance with an altered Shannon Entropy
#input:
#0: homologene list
#1: homologenecomparisonvalues.txt
#2: ComparisonTable-data1_2_4.txt
#3: out

use strict;
use warnings;

open(HGENES, "<$ARGV[0]") or die "error reading $ARGV[0]";

#initialize variables
my $hgene;
my @temp;
my $line;
my @tokens;
my %HoA;
my $SE;
my $key;
my @value;
my $first;
my $total;
my $zeros;
my %HoSE;
my @comptable;
my $line2;
my @tokens2;
my @altArr;


#parse the gene list and build the data structure
while(<HGENES>){
	chomp;

	#initialize a new variable for this hgene
	$hgene= $_;

	#find all lines with that hgene 
	@temp = qx(grep -w "$hgene" "$ARGV[1]");
	
	
	#iterate through each line with that hgene to extract relevent info
	foreach (@temp){
		chomp;
		$line = $_;
		#split each line, where [hgene,compID,value]
		@tokens = split(/\t/,$line);
		
		#if the current compID is already in the HoA
		if (exists $HoA{$tokens[1]}){
			push (@{$HoA{$tokens[1]}},$tokens[2]);
		}
		else{
			#add a k-v to a hash, where comparisonID->[values]
			$HoA{$tokens[1]} = [$tokens[2]];
		} 
	}
}
close HGENES;

#finds the maximum profile length
my $maxProf = 0;
foreach my $k (keys %HoA){
	if ($maxProf < scalar @{$HoA{$k}}){
		$maxProf = scalar @{$HoA{$k}};
	}
}



sub entropy{
	my %count;
	$count{$_}++ for @_;
	my @p = map $_/@_, values %count;
	my $entropy = 0;
	$entropy += - $_ * log $_ for @p;
	$entropy / log 2
}

sub alteredArr{
	my @altArr = @_;
	while ($maxProf > scalar @altArr){
		if ($altArr[0] eq 'Y' || $altArr[0] eq 'N'){
			push (@altArr, 'N');
		}
		else{
			push (@altArr, '0');
		}
	}
	print join (",", @altArr);
	print "\n";
	@altArr;
}

#parse the data structure for relevant info
while(($key,@value) = each %HoA){ 
	@altArr = @{$HoA{$key}};
	while ($maxProf > scalar @altArr){
		if ($altArr[0] eq 'Y' || $altArr[0] eq 'N'){
			push (@altArr, 'N');
		}
		else{
			push (@altArr, '0');
		}
	}
	#print join (",", @altArr);
	#print "\n";
	$SE = entropy @altArr;
	$first = $altArr[0];
	@{$HoA{$key}} = @altArr;
	if ($SE == 0 && $first ne "1" && $first ne "-1" && $first ne "Y"){
		#do nothing
	}
	else{
		$total = 0;
		$zeros = 0;
		foreach (@altArr){
			$total = $total + 1; 
			if ($_ eq "0" || $_ eq "N"){
				$zeros = $zeros + 1;
			} 
		}
		if ($zeros / $total <= 0.5){
			$HoSE{$key} = $SE;
		}
		
	}
}


open(OUT1, ">$ARGV[3]") or die "error opening $ARGV[3]";

foreach my $key2 (sort {($HoSE{$a} cmp $HoSE{$b})} keys %HoSE){
	@comptable = qx(grep -w "$key2" "$ARGV[2]");
	foreach (@comptable){
		chomp;
		$line2 = $_;
		@tokens2 = split (/\t/,$line2);
		if ($tokens2[0] eq $key2){
			print OUT1 "$tokens2[0]\t$HoSE{$key2}\t$tokens2[2]\t";
			print OUT1 "@{$HoA{$key2}}\n";
			
		}
	}
}
close OUT1;

