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


#loop to do for each file

foreach my $file (@FILES){
	local $/ = undef;
	open my $fh, '<', $file;
	$data{$file} = <$fh>;
}

foreach my $key (keys %data){
	print $data{$key};
}

