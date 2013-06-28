#!/usr/bin/perl
#finds the most similar studies in a group of genes
#import the gene list
#construct a profile for each of those genes
#
#inputs:
#0: hgene list
#1: homologenecomparisonvalues.txt
#2: ComparisonTable-data1_2_4.txt
#3: studyannotations
#4: out
#5: out


use strict;
use warnings;

open(HGENES, "<$ARGV[0]") or die "error reading $ARGV[0]";

#variable declarations
my $hgene;
my @temp;
my $line;
my %HoA; #a hash of compID->array of values
my @tokens;
my $key;
my @value;
my @array;
my $metric;
my %HoSE;
my @comptable;
my $line2;
my @tokens2;
my %HoT;
my $studyID;
my $key3;
my @value3;
my @studyannot;
my @tokens3;
my $line3;
my $tag;
my $SE;
my $first;
my $total;
my $zeros;

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
			#print "$tokens[1]; @{$HoA{$tokens[1]}}\n";
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


#parse the data structure for relevant info
while(($key,@value) = each %HoA){ 
	#print "$key;";
	#print entropy @{$HoA{$key}};
	#print "\n";
	$SE = entropy @{$HoA{$key}};
	$first = @{$HoA{$key}}[0];
	if ($SE == 0 && $first ne "1" && $first ne "-1" && $first ne "Y"){
		#do nothing
	}
	else{
		$total = 0;
		$zeros = 0;
		foreach (@{$HoA{$key}}){
			$total = $total + 1; 
			if ($_ eq "0"){
				$zeros = $zeros + 1;
			} 
		}
		if ($zeros / $total <= 0.5){
			$HoSE{$key} = $SE;
		}
		
	}
}

#clean out values with SE=0 and all zeros



open(OUT1, ">$ARGV[4]") or die "error opening $ARGV[4]";

foreach my $key2 (sort {($HoSE{$a} cmp $HoSE{$b})} keys %HoSE){
	@comptable = qx(grep -w "$key2" "$ARGV[2]");
	foreach (@comptable){
		chomp;
		$line2 = $_;
		@tokens2 = split (/\t/,$line2);
		if ($tokens2[0] eq $key2){
			print OUT1 "$tokens2[0]\t$HoSE{$key2}\t$tokens2[2]\t";
			print OUT1 "@{$HoA{$key2}}\n";
			
			$studyID = $tokens2[1];

			#get the tags from studyannotations
			@studyannot = qx(grep -w "$studyID" "$ARGV[3]");
			foreach (@studyannot){
				chomp;
				$line3 = $_;
				@tokens3 = split (/\t/,$line3);
				$tag = $tokens3[2];
			

			#if the current studyID is already in the HoT
			if (exists $HoT{$tag}){
				${$HoT{$tag}}[0] = ${$HoT{$tag}}[0] + 1;
				${$HoT{$tag}}[1] = ${$HoT{$tag}}[1] + $HoSE{$key2};
			}
			else{
				#add a k-v to a hash, where studyID->[# times tag shows up, sum of entropies]
				$HoT{$tag} = [1,1+$HoSE{$key2}];
			}
			} 
		}
	}
}
close OUT1;

while(($key3,@value3) = each %HoT){ 
	${$HoT{$key3}}[2] = ${$HoT{$key3}}[1]/${$HoT{$key3}}[0];

}


open(OUT2, ">$ARGV[5]") or die "error opening $ARGV[5]";

foreach my $key4 (sort {${$HoT{$a}}[2] cmp ${$HoT{$b}}[2]} keys %HoT){
	print OUT2 "$key4\t";
	print OUT2 join("\t", @{$HoT{$key4}});
	print OUT2 "\n\n";
}
close OUT2;
