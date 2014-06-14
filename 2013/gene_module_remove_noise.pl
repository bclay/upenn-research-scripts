#!/usr/bin/perl
#takes files with homologene and modularity value and removes noise
#(i.e. homologenes that are the same across)
#
#inputs:
#0: output from 


use strict;
use warnings;


#variable declarations
my @FILES = @ARGV;
my %data;
my %hundredLines;
my $count;
my $line;
my $val;
my @lineSplit;
my $lineNum;
my $hgene2;
my $fileCount;

#loop to do for each file

foreach my $file (@FILES){
	local $/ = undef;
	open my $fh, '<', $file;
	$data{$file} = <$fh>;
}

print "Hgene\tValue\tAcinar\tEndocr\tAdultBeta\tImmatBeta";

sub getHundred{
	while($_[$count] && $count < 100){
		$val = 100 - $count;
		@lineSplit = split('\t',$_[$count]);
		$hgene2 = $lineSplit[0];

		if (exists $hundredLines{$hgene2}){
			${$hundredLines{$hgene2}}[0]+=($val+100);
			#print "if\n";
		}
		else{
			${$hundredLines{$hgene2}}[0] = $val;
			#print "else\n";
			$fileCount = scalar @FILES;
			while ($fileCount > 0){
				${$hundredLines{$hgene2}}[$fileCount] = 0;
				$fileCount--;
			}
		}
		${$hundredLines{$hgene2}}[$lineNum] = $val;
		$count++;
	}
}

$lineNum = 0;
foreach my $key (keys %data){
	$count = 0;
	$lineNum++;
	getHundred (split ('\n',$data{$key}));
	print "\n"
}

foreach my $hgene (sort {${$hundredLines{$b}}[0] <=> ${$hundredLines{$a}}[0]} keys %hundredLines){
	print "$hgene\t";
	print join("\t",@{$hundredLines{$hgene}});
	print "\n";
}
