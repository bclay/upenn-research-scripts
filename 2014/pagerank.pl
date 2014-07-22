#!/usr/bin/perl
#6/17/14
#objective: output a list of x random genes
#0: # of genes in list

use strict;
use warnings;

open(DATAFILE, "<$ARGV[1]") or die "error reading $ARGV[1]";

#variable declaration

close DATAFILE;