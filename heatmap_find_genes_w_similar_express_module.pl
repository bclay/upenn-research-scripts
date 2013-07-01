#!/usr/bin/perl
#finds
#
#inputs:
#0: output from study_similarity_profiles.pl
#(comparisonID, SE, description, profile)
#1: homologenecomparison
#2: normal output
#3?: Out file

use strict;
use warnings;

open(HGCV, "<$ARGV[1]") or die "error reading $ARGV[1]";

#variable declarations
my %HoH;
my $line;
my @tokens;
my %HoHG;

my $line2;
my @tokens2;
my $compID;
my $SE;
my $compProf;
my @cellVals;
my %HoCV;
my $cellVal;
my $domVal;
my $domValVal;
my $useVal;

#parse homologenecomparisonvalues.txt

while (<HGCV>){
	chomp;
	$line = $_;
	@tokens = split(/\t/, $line);
	$HoH{$tokens[1]}{$tokens[0]} = $tokens[2];
}
close HGCV;



open(SEFILE, "<$ARGV[0]") or die "error reading $ARGV[0]";
#open(OUT2, ">$ARGV[3]") or die "error reading $ARGV[3]";
#parse the input file 
while(<SEFILE>){
	chomp;
	$line2 = $_;
	@tokens2 = split(/\t/, $line2);
	$compID = $tokens2[0];
	$SE = $tokens2[1];
	$compProf = $tokens2[3];
	
	
	if ($SE < 1){
	#print OUT2 "$compID\t$SE\t$compProf\n";
		@cellVals = split(/ /, $compProf);
		
		foreach (@cellVals){
			$cellVal = $_;
			if (exists $HoCV{$cellVal}){
				$HoCV{$cellVal}++;
			}
			else{
				$HoCV{$cellVal} = 1;
			}
		} 

		

		#find the dominant value, which is the value that shows up in the profile over 50% of the time
		$domValVal = 0;
		$domVal = 0;
		foreach my $key (keys %HoCV){
			#print OUT2 "$compID\t$key\t$HoCV{$key}\n";
			if ($domValVal < $HoCV{$key}){
				$domVal = $key;
			}
		}

		#create a hash where the keys are the cell values and the values are the number of occurences of that hash value in a profile
		
		#create a hash where the key is the compID and the value is [SE,domVal]
		#iterate through the HoH, going 1 hgene at a time, and compare values to expected profile values

		foreach my $hgene (keys %{$HoH{$compID}}){

			if ($SE == 0){
				$useVal = 10;
			}
			else {
				$useVal = 1/$SE;
			}
			
			#print "$useVal\n";

			if ($HoH{$compID}{$hgene} eq $domVal){
				if (exists $HoHG{$hgene}){
					$HoHG{$hgene} = $HoHG{$hgene} + $useVal;
					#print "Does this ever happen?\n";
				}
				
				else{
					$HoHG{$hgene} = $useVal;
				}
				#print OUT2 "$hgene\t$compID\t$useVal\t$HoHG{$hgene}\n";

			}
		}

		foreach (keys %HoCV){
			delete $HoCV{$_};
		}
	}	
}
close SEFILE;
#close OUT2;

for my $hgene34 (keys %HoHG){
	#print "$hgene34\t$HoHG{$hgene34}\n";
}


open(OUT, ">$ARGV[2]") or die "error reading $ARGV[2]";

for my $hgene2 (sort{($HoHG{$b} <=> $HoHG{$a})} keys %HoHG){
	print OUT "$hgene2\t$HoHG{$hgene2}\n";
}
close OUT;
