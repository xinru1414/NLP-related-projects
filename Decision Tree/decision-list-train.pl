#!/usr/bin/perl
#
# This is decision-list-train program for decision list classifier to perform word sense disambiguation.
# CS5761 PA5 
# Written by Xinru Yan, University of Minnesota Duluth, yanxx418@d.umn.edu
# Nov 14th, 2015
#
# Introduction 
# This program will learn a decision list from sense tagged training data. It uses feature from Yarowsky: Word found in 2 word windows
# It will learn a decision list from line-train.txt and write that dicision list to STDOUT
# Command setting is:
# ./decision-list-train.pl line-train.txt > my-decision-list.txt
# The command is redirecting output to my-dicision-list.txt file 
# 
# examples of input and output:
# input(Command line): line-train.txt
# output:
# feature: a predict: product log-likelihood score: 2.76553474636298
# feature: of predict: product log-likelihood score: 2.65207669657969
# ...
# feature: NONE predict: product log-likelihood score: NONE
#
# sub routine
# &log2
# compute log2

use strict;
use warnings;

#########################################
##----- DATA - STRUCRTURE - START -----##
#get input file from command line
my $file = $ARGV[0];
# count number for how many times first sense appears for default setting
my $count1 = 0;
# count number for how many times second sense appears for default setting
my $count2 = 0;
# for storing the sense which the program gets from the training data 
my $p;
# the log2 value
my $log_likelihood;
# storing input file to an array
my @fileinput;
# senses hash
# first key is the feature
# sencond key is the sense
# value is how many times it appears
my %senses;
# decision list hash
# first ket is the feature
# second key is the word it predicts
# value is the associated absolute log value
my %associated;
# first sense of the word
my $sense1;
# second sense of the word
my $sense2;
##----- DATA - STRUCTURE - END -----##
######################################

###################################
##----- SUBROUTINES - START -----##
# compute log2 value
sub log2 {
 	my $n = shift;
    return log($n)/log(2);
}
##----- SUBROUTINES - END-----##
################################

######################################
##----- MAIN - PROGRAM - START -----##
# open the file
open my $info, $file or die "Could not open $file: $!";
# read file in, put it into an array for feature use(peek next line)
while (<$info>) {
	push (@fileinput, $_);
}
# close the file
close $info;
# iterating the input file line by line
for my $linenr (0 .. $#fileinput) {   
	# if the line set the sense for the word
    if ($fileinput[$linenr] =~ /senseid="(\w*)"/) {
    	# put the sense in $p
    	$p = $1;
    	# if next line or next next line contains feature Word found in +-2 word windows
        if (($fileinput[$linenr + 2] =~ /\s(\w+)\s(\w+)\s<head>\S+<\/head>\s(\w+)\s(\w+)/ || $fileinput[$linenr + 3] =~ /\s(\w+)\s(\w+)\s<head>\S+<\/head>\s(\w+)\s(\w+)/) &&  $linenr <= $#fileinput) {       
      		 # feature is the first key, sense is the second key, value is # of times it appears 
             $senses{$1}{$p}++;
             $senses{$2}{$p}++;
             $senses{$3}{$p}++;
             $senses{$4}{$p}++;
             # define $sense1
             if (! defined $sense1) {
             	$sense1 = $p;
             }
             # define $sense2
             elsif ((! defined $sense2) &&($sense1 ne $p )) {
             	$sense2 = $p;
             }
             # #of times sense1 appears
             if ((defined $sense1) && ($p eq $sense1)){
             	$count1++;
             }
             # #of times sense2 appears
             if ((defined $sense2) && ($p eq $sense2)){
             	$count2++;
             }
        }
    }
}
# iterating hash
foreach my $key (sort {$a cmp $b} keys %senses){
	# these two values for a certain feature how many times each sense appears
	my $v1;
	my $v2;
	foreach my $key2 (keys %{$senses{$key}}) {
		# set v1
		if ($key2 eq $sense1){
			$v1 = $senses{$key}{$key2};
		} 
		# set v2
		if ($key2 eq $sense2){
			$v2 = $senses{$key}{$key2};
		} 
	}
	# if the feature appears for both sense, we want them, we need to compute the log2 value
	if (defined $v1 && defined $v2){
			# compute log2
			$log_likelihood = &log2($v1/$v2);
			# predicts sense1, set associated keys and values
			if ($log_likelihood > 0){
				$associated{$key}{$sense1} = $log_likelihood;
			}
			# predicts sense2, set associated keys and values
			if ($log_likelihood < 0){
				$associated{$key}{$sense2} = $log_likelihood;
			}
	}
	# if the feature appears for only one sense, even better! we smooth the disappearing one and then compute the log2 value
	if (defined $v1 && (!defined $v2)){
			#smooth $v2
			$v2 = 0.00001;
			# compute log2
			$log_likelihood = &log2($v1/$v2);
			# predicts sense1, set associated keys and values
			if ($log_likelihood > 0){
				$associated{$key}{$sense1} = $log_likelihood;
			}
			# predicts sense2, set associated keys and values
			if ($log_likelihood < 0){
				$associated{$key}{$sense2} = $log_likelihood;
			}
	}
	if ((!defined $v1) && defined $v2){
			#smooth $v1
			$v1 = 0.00001;
			# compute log2
			$log_likelihood = &log2($v1/$v2);
			# predicts sense1, set associated keys and values
			if ($log_likelihood > 0){
				$associated{$key}{$sense1} = $log_likelihood;
			}
			# predicts sense2, set associated keys and values
			if ($log_likelihood < 0){
				$associated{$key}{$sense2} = $log_likelihood;
			}
	}

}
# comppute absolute value
foreach my $key (keys %associated){
	foreach my $key2(keys %{$associated{$key}}) {
		if ($associated{$key}{$key2} < 0) {
			$associated{$key}{$key2} = abs($associated{$key}{$key2});
		}
	}
}
# sort the decision list hash based on abs value from large to small numbers, print out the decision list hash
for my $keypair (
        sort { $associated{$b->[0]}{$b->[1]} <=> $associated{$a->[0]}{$a->[1]} }
        map { my $intKey=$_; map [$intKey, $_], keys %{$associated{$intKey}} } keys %associated
    ) {
		print "feature: $keypair->[0]". " predict: $keypair->[1]" . " log-likelihood score: $associated{$keypair->[0]}{$keypair->[1]}" . "\n";
	}
# print default setting based on how many times each sense appears
if ($count1>$count2){
	print "feature: NONE". " predict: $sense1" . " log-likelihood score: NONE" . "\n";
}else{
	#print "feature: NONE". " predict: $sense2" . " log-likelihood score: NONE" . "\n";
}	

##----- MAIN - PROGRAM - END -----##
####################################

