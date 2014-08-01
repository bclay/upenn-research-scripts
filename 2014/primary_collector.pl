#!/usr/bin/perl
#0:m2 node stats

use strict;
use warnings;

my $hgene;
my %hgenes;

open(INPUT, "<$ARGV[1]") or die "errr reading $ARGV[0]";