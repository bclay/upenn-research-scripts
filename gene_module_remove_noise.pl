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

#loop to do for each file

foreach my $file (@FILES){
	local $/ = undef;
	open my $fh, '<', $file;
	$data{$file} = <$fh>;
}

sub getHundred{
	while($_[$count] && $count < 100){
		$val = 100 - $count;
		@lineSplit = split('\t',$_[$count]);
		if (exists $hundredLines{$lineSplit[0]}){
			$hundredLines{$lineSplit[0]}+=$val;
		}
		else{
			$hundredLines{$lineSplit[0]} = $val;
		}
		$count++;
	}
}


foreach my $key (keys %data){
	$count = 0;
	getHundred (split ('\n',$data{$key}));
	print "\n"
}

foreach my $hgene (sort {$hundredLines{$b} <=> $hundredLines{$a}} keys %hundredLines){
	print "$hgene\t$hundredLines{$hgene}\n";
}
