#!/usr/bin/perl
#6/13/14
#objective: input a few genes and output a clear comparison of their expression profiles
#args:
#0: very short list of homologenes (tinyhgene_F*.txt)
#1: homologenecomparisonvalues.txt
#2: ComparisonTable-data
#3: output file

use strict;
use warnings;

open(HGENES, "<$ARGV[0]") or die "error reading $ARGV[0]";

#declare variables
my $hgene;
my $maxLen = 0;
my @temp;
my $line;
my @tokens;
my %hgeneInput;
my %HoProf;
my %HoHgenes;
my $key;
my @value;
my $cat;
my %HoCats;
my $c;
my $second;
my @comptable;
my $line2;
my @tokens2;
my $count;

#parse the initial gene list and save in a data strcture
while(<HGENES>){
	chomp;

	#initialize hgene variable
	$hgene = $_;

	#increment count
	++$maxLen;

	#add to hgenee array
	$hgeneInput{$hgene} = $maxLen;

	#find all lines in hcv with that hgene
	@temp = qx(grep -w "$hgene" "$ARGV[1]");

	#create a hash with comparison id keys and aggregate profiles
	foreach (@temp){
		chomp;

		#initialize line variable
		$line = $_;

		#split each line into tokens where [hgene,compID,cell value]
		@tokens = split(/\t/,$line);

		#if the comparison id already exists
		if (exists $HoProf{$tokens[1]}){
			push (@{$HoProf{$tokens[1]}}, $tokens[2]);
			push (@{$HoHgenes{$tokens[1]}}, $hgene);
		}
		#if the comparison id is novel
		else{
			$HoProf{$tokens[1]} = [$tokens[2]];
			$HoHgenes{$tokens[1]} = [$hgene];
		}
	}
}
close HGENES;

#module that sorts profiles into categories
#0: completely the same
#>0 && <1: some gaps, but otherwise the same
#1-maxLen: 1 diff, # depending on location
#>maxLen: too many diffs to matter
sub sorter{
	$second = "x";
	$count = @_;
	print $count;
	if ($count * 2 < $maxLen){
		return ($count * 2) + 100;
	}
	else{
		$c = 0;
		my $first = $_[0];
		foreach (@_){
			++$c;
			if ($first ne $_){
				if ($second eq "x"){
					$second = $_;
				}
				else{
					if($second eq $_){
						$first = $second;
					}
					else{
						return ($maxLen + 1);
					}
				}
			}
			else{
				if($c == $count){
					if ($count < $maxLen){
						return (1 - ($count / $maxLen));
					}
					else{
						return 0;
					}
				}
			}
		}
		return 500;
	}
}

#parses data strcuture to sort by profile similarity
while(($key,@value) = each %HoProf){
	$count = 0;
	$cat = &sorter(@value);
	$HoCats{$key} = $cat;
}




open(OUT1, ">$ARGV[3]") or die "error opening $ARGV[3]";

#prepare output
foreach my $key2 (sort {$HoCats{$a} cmp $HoCats{$b}} keys %HoCats){
	@comptable = qx(grep -w "$key2" "$ARGV[2]");
	foreach(@comptable){
		chomp;
		$line2 = $_;
		@tokens2 = split (/\t/, $line2);
		if ($tokens2[0] eq $key2){
			print OUT1 "$tokens2[1]\t$HoCats{$key2}\t$tokens2[3]\t$tokens2[4]\n";
			$c = 0;
			foreach(@{$HoProf{$key2}}){
				print OUT1 "\t$_ : @{$HoHgenes{$key2}}[$c]\n";
				$c++;
			}
			print OUT1 "\n"
		}
	}
}

close OUT1;