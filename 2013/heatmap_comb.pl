
#!/usr/bin/perl
#determines comparison IDs of importance with Shannon Entropy and another metric
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
my $maxLen;
my $line;
my @tokens;
my %HoA;
my $SE;
my $NSE;
my $key;
my @value;
my $first;
my $total;
my $zeros;
my %HoSE;
my @comptable;
my $line2;
my @tokens2;


#parse the gene list and build the data structure
while(<HGENES>){
	chomp;

	#initialize a new variable for this hgene
	$hgene= $_;

	#find all lines with that hgene 
	@temp = qx(grep -w "$hgene" "$ARGV[1]");
	
	$maxLen = 1;
	
	#iterate through each line with that hgene to extract relevent info
	foreach (@temp){
		chomp;
		$line = $_;
		#split each line, where [hgene,compID,value]
		@tokens = split(/\t/,$line);
		
		#if the current compID is already in the HoA
		if (exists $HoA{$tokens[1]}){
			push (@{$HoA{$tokens[1]}},$tokens[2]);
			if (scalar @{$HoA{$tokens[1]}} > $maxLen){
				$maxLen = scalar @{$HoA{$tokens[1]}};
			}
		}
		else{
			#add a k-v to a hash, where comparisonID->[values]
			$HoA{$tokens[1]} = [$tokens[2]];
		} 
	}
}
close HGENES;

sub entropy{
	my %count;
	$count{$_}++ for @_;
	my @p = map $_/@_, values %count;
	my $entropy = 0;
	$entropy += - $_ * log $_ for @p;
	$entropy / log 2
}

sub notSE{
	my %counts;
	$counts{$_}++ for @_;
	my $entropy = 0;
	foreach my $cell_val (keys %counts){
		if ($counts{$cell_val} > $entropy){
			$entropy = $counts{$cell_val};
		}
	}
	return $entropy;
}

#parse the data structure for relevant info
while(($key,@value) = each %HoA){ 
	$SE = entropy @{$HoA{$key}};
	$NSE = notSE @{$HoA{$key}};
	$first = @{$HoA{$key}}[0];
	if ($SE == 0 && $first ne "1" && $first ne "-1" && $first ne "Y"){
		#do nothing
	}
	else{
		$total = 0;
		$zeros = 0;
		foreach (@{$HoA{$key}}){
			$total = $total + 1; 
			if ($_ eq "0" || $_ eq "N"){
				$zeros = $zeros + 1;
			} 
		}
		if ($zeros / $total <= 0.5){
			$HoSE{$key} = $NSE - $SE;
		}
		
	}
}


open(OUT1, ">$ARGV[3]") or die "error opening $ARGV[3]";

foreach my $key2 (sort {($HoSE{$b} cmp $HoSE{$a})} keys %HoSE){
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

