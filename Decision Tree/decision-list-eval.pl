#!/usr/bin/perl
#
# This is decision-list-train program for decision list classifier to perform word sense disambiguation.
# CS5761 PA5 
# Written by Xinru Yan, University of Minnesota Duluth, yanxx418@d.umn.edu
# Nov 14th, 2015
#
# Introduction
# This program will compare the answer file with the gold standard answers given
# compute the accuracy of the sense tagging and output a confusion matrix
# Command setting is:
# ./decision-list-eval.pl line-key.txt my-answer.txt
#
# examples of input and output:
# input(Command line): line-key.txt my-answer.txt
# output:
#          phone product
# phone    16        56
# product    6        47
# Total assigned: 126
# Correctly assigned: 73
# Accuracy: 0.579365079365079
#
# sub routine
# &uniq
# sort uniq values of an array 

use strict;
use warnings;
#########################################
##----- DATA - STRUCRTURE - START -----##
# read in gold standard answer file
my $file1 = $ARGV[0];
# read in the program answer file
my $file2 = $ARGV[1];
# the matrix
my $matrix = {};
# store gold standard answer
my @seq1;
# store program answer
my @seq2;
# a sorted version of @seq2
my @sorted;
# total assigned #
my $count = 0;
# correctly assigned #
my $right = 0;
# accuracy
my $accuracy = 0;
# store the sense read in from each file
my $sense0;
# sense1
my $sense1;
# sense2
my $sense2;
# store the sense
my $p;
##----- DATA - STRUCTURE - END -----##
######################################

###################################
##----- SUBROUTINES - START -----##
sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}
##----- SUBROUTINES - END-----##
################################

######################################
##----- MAIN - PROGRAM - START -----##
open my $info1, $file1 or die "Could not open $file1: $!";
open my $info2, $file2 or die "Could not open $file2: $!";
# get correct answer put it into @seq1
while( <$info1>)  {
	$sense0 = $_;
	if ($sense0 =~ /senseid="(\w*)"/) {
		$p = $1;
		if (! defined $sense1) {
             $sense1 = $p;
         }
         elsif ((! defined $sense2) &&($sense1 ne $p )) {
             $sense2 = $p;
         }

        if($p eq $sense1){
         	push (@seq1, $sense1);
		}
		else {
			push (@seq1, $sense2);
		}
		
	} 
	
}
close $info1;
# re-use
undef $sense1;
undef $sense2;
# get program answer put it into @seq2
while( <$info2>)  {
	$sense0 = $_;
	if ($sense0 =~ /senseid="(\w*)"/) {
		$p = $1;
		if (! defined $sense1) {
             $sense1 = $p;
         }
         elsif ((! defined $sense2) &&($sense1 ne $p )) {
             $sense2 = $p;
         }

        if($p eq $sense1){
         	push (@seq2, $sense1);
		}
		else {
			push (@seq2, $sense2);
		}
		
	} 
}
close $info2;
# sort uniq value of @seq2 prepare it to print for the matrix's column
@sorted = uniq(sort @seq2);

# set up the matrix and add compute how many sense assigned correctly
for (my $i=0; $i < @seq1; $i++){
	if ($seq1[$i] eq $seq2[$i]) {
		$right++;
	}
    $matrix->{$seq1[$i]}->{$seq2[$i]}++;
    $count++;
}
# print the matrix
print "         " . "@sorted" . "\n";
 for my $k (sort keys %$matrix) {
     print $k;
     foreach (@sorted) {
     	if (exists($matrix->{$k}->{$_})) {
     		print "    " . $matrix->{$k}->{$_} . "    ";
 		} else {
 			print "    0    ";
 		}
     }
     print "\n";
 }
 # compute accuracy
 $accuracy = $right/$count;
 # result print
print "Total assigned: $count" . "\n" . "Correctly assigned: $right" . "\n" . "Accuracy: $accuracy" . "\n";
##----- MAIN - PROGRAM - END -----##
####################################


