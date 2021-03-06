#!/usr/bin/perl
#
# This is decision-list-train program for decision list classifier to perform word sense disambiguation.
# CS5761 PA5 
# Written by Xinru Yan, University of Minnesota Duluth, yanxx418@d.umn.edu
# Nov 14th, 2015
#
# Introduction 
# This program will take the learned decision list and use it to assign senses to the word in the test data
# Command setting is:
# ./decision-list-test.pl my-decision-list.txt line-test.txt > my-answer.txt
# The command is redirecting output to my-answer.txt file
# 
# examples of input and output:
# input(Command line): my-decision-list.txt line-test.txt
# output:
# how many in: 126
# how many out:126
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="phone"
# senseid="phone"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="phone"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="product"
# senseid="product"
# senseid="product"
# senseid="phone"
# senseid="phone"

use strict;
use warnings;
#########################################
##----- DATA - STRUCRTURE - START -----##
# get decision list which is generated by train program
my $file1 = $ARGV[0];
# get test file
my $file2 = $ARGV[1];
# store the feature
my @array1;
# store the predicted sense
my @array2;
# store each line read in from test file
my $line;
# keep track of how many words we need to assign
my $many = 0;
# keeep track of whether the sense has been assigned to the word or not
my $sign = 0;
# output array
my @output;
# length of the output to keep track of how many words we assigned 
my $j;
##----- DATA - STRUCTURE - END -----##
######################################

######################################
##----- MAIN - PROGRAM - START -----##
open my $info1, $file1 or die "Could not open $file1: $!";
open my $info2, $file2 or die "Could not open $file2: $!";

# read in the decision list, put each feature into array1 and associated sense into array2 
while (<$info1>) {
	if ($_ =~ /feature:\s(\w*)\spredict:\s(\w*)/){
		push(@array1, $1);
		push(@array2, $2);
	}
}
close $info1;
# read in test file
while( <$info2>)  {
	$line = $_;
	# it has the word we are looking for
	if ($line =~ /<head>\S+<\/head>/) {
		# count how many word we need to assign sense
		$many++;
		# match feature pattern
		if ($line =~ /\s(\w+)\s(\w+)\s<head>\S+<\/head>\s(\w+)\s(\w+)/) {
			for(my $i = 0; $i < @array1-1; $i++){
				$sign = 0;
				# if the feature appears ,go thru the feature array to see which specific one appears then based on that assign sense
				if (($1 eq $array1[$i]) || ($2 eq $array1[$i]) || ($3 eq $array1[$i]) || ($4 eq $array1[$i])){
					push (@output, "senseid=\"$array2[$i]\"");
					# if it's been assigned, mark 
					$sign = 1;
					last;
				}
				# if the pattern maches but no feature matches, set to default sense
				if($i == @array1-2 && $sign == 0){
					my $t = @array1-1;
					push (@output, "senseid=\"$array2[$t]\"");
					$sign = 1;
				}
			}
			
		 }
		 # if pattern doesn't match and feature doesn't appear, set default sense
		 else{
		 		my $t = @array1-1;
				push (@output, "senseid=\"$array2[$t]\"");
				$sign = 1;
		}
	}
	
	
}
close $info2;
# keep track of how many words we assigned sense
$j = @output;
# test if we assigned all words
print "how many in: $many\n";
print "how many out:$j\n";
# print the sense line by line
@output=join("\n", @output);
print "@output" . "\n";
##----- MAIN - PROGRAM - END -----##
####################################