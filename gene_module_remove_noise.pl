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


#loop to do for each file

foreach my $file (@FILES){
	local $/ = undef;
	open my $fh, '<', $file;
	$data{$file} = <$fh>;
}

sub getHundred{
	while($_[$count] && $count < 100){
		$val = 100 - $count;
		print "$_[$count]\t$val\n";
		$count++;
	}
}


foreach my $key (keys %data){
	$count = 0;
	getHundred (split ('\n',$data{$key}));
	print "\n"
}

