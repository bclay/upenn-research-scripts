#!/usr/bin/perl
#adds genes one-by-one to a list for an Arda figure, then generates map1 and runs an R script on that
#the final result is a tab-delimited table with datapoints
#
#
#ARGS:
#0:IN:intital gene list
#1:IN:results list (genes to add)
#2:IN:DB
#
#OUT:combined list of genes
#OUT:table with graph stats


use strict;
use warnings;
use Statistics::R;


#variables




#import a list of genes (on Arda figure and genes that have already been added)
open (TOADD, "ARGV[]") or die "error reading $ARGV[]";
