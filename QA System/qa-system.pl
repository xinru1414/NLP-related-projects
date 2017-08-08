#!/usr/bin/perl
#
# This is QA system that can answer Who, What, When and Where questions. 
# CS5761 PA6 
# Written by Xinru Yan, University of Minnesota Duluth, yanxx418@d.umn.edu
# Dec 10th, 2015
#
# Introduction 
# This program takes an approach similar to the AskMSR system:
# It recognizes questions it can't answer and respond with an "Sorry I don't get that" message.
# It uses WWW::Wikipedia module from http://search.cpan.org to interact with Wikipedia. 
# Command setting is:
# 
# 
# examples of input and output:
# ?> When was Instagram launched
# =>Instagram was launched in October 2010 as a free mobile app.
#

#use strict;
#use warning;

#########################################
##----- DATA - STRUCRTURE - START -----##
# use module to interact with Wikipedia
use WWW::Wikipedia;


# constant value for true/false
use constant { true => 1, false => 0 };
# used in the while loop for getting user input
my $running = true;
# answer propmt
my $anlead = "=>";
# question prompt 
my $qulead = "?> ";
my $element;
my $out;
my $i;
my $in2;
my $n;
##----- DATA - STRUCTURE - END -----##
######################################

######################################
##----- MAIN - PROGRAM - START -----##
# intro
print "This is a HORRIBLE QA system, written by Xinru Yan :p\n";
print "It will try to find something for questions that start with Who, What, When or Where.\nEnter exit to leave the program.\n";
print "Now please ask your questions\n";



open(LOGFILE, ">$ARGV[0]") or die "Couldn't open file $ARGV[0], $!";
# get rid of wide character
binmode LOGFILE, ":encoding(UTF-8)";
my $in = <>;

# loop to read
while ($running){
  print $qulead;
  # read in question
	my $in = <>;
  # put in log file
  print LOGFILE $in;
  print LOGFILE "\n";
  # exit the program if the user wants to
	if ($in =~ /\bexit\b/ ) {
        $running = false;
        exit;
  }elsif($in =~ /Who|Where|When|What/){
      # defination kinda question (with is followed such as Where is; What is)
    	if ($in =~ /(Who|Where|What|When)\s(is)\s(\w+)\s(\w+)|(Where|Who|What|When)\s(is)\s(\w+)/){
    		# reformulate the question
    		if (defined $4) {
    			$in = $3 . " " . $4;
    		} else {
    			$in = $7;
    		}
    		# look for answers
    		my $wiki = WWW::Wikipedia->new();
    		my $result = $wiki->search($in);
        # no entry in wikipedia
    		if (!$result){
    			print "$anlead Sorry I don't get that\n";
    		}
    		else {
    			my $info = $result->text_basic();
          # print to the log file
          print LOGFILE $info;
          print LOGFILE "\n";
          # parse the text
    			$info =~ s/\n+//g;
    			$info =~ s/<!--.*?-->//g;
    			$info =~ s/<ref\.*//g;
    			$info =~ s/<\/ref>//g;
    			if ($info =~ /\}'.*?$3.*$4.*?'.*\(|\}'.*?$7.*?'.*\(/) {
    				$info ="$&$'";
    			}
    			$info =~ s/\(.*\d{1,2},\s\d{4}\)//g;
     			my @lines = split (/\.\s[A-Z]/, $info);
     			foreach (@lines) {
            # find the answer!
  					if ($_ =~ /'.*?$3.*$4.*?'|'.*?$7.*?'/){
  						print $anlead;
  						# parse
  						$out = "$&$'";
  						$out =~ s/[\{|\(].*[\}\)]//g;
  		 				$out =~ s/[<>!@#$%^&*]//g;
  						$out =~ s/\s+/ /g;
              # print the answer
  						print $out;
              print LOGFILE $out;
  						print ".\n";
  						last;
  					}
				}
			}}elsif($in =~ /Who\s(\w+)\s(\w+)\s(\w+)|Who\s(\w+)\s(\w+)/) { # other who questions 
        # reformulate
    		if (defined $3) {
    			$in = $2 . " " . $3 . " was " . $1;
    			$i = $2 . " " . $3;
    			$n = $1;
    		} else {
    			$in = $5 . " was " . $4;
    			$n = $4;
    			$i = $5;
    		}
    		my $wiki = WWW::Wikipedia->new();
    		my $result = $wiki->search($i);
        # no entry in wikipedia
    		if (!$result){
    			print "$anlead Sorry I don't get that \n";
    		}
    		else {
    			my $info = $result->text_basic();
          print LOGFILE $info;
          print LOGFILE "\n";
    			# find the answer
    			if ($info =~ /$in/i) {
    				print $anlead;
    				#print "$info\n";
    				$info ="$&$'";
    				my @lines = split (/\.\s*[A-Z]*<*/, $info);
    				print "$lines[0].\n";
            print LOGFILE $lines[0];
    			}
          # tilling 
    			else{
    				if (defined $n) {
    					if ($info =~ /$n/i){
    						print $anlead;
    						$info ="$&$'";
    						my @lines = split (/\.\s*[A-Z]*<*/, $info);
    						print "$i was $lines[0].\n";
                print LOGFILE $i;
                print LOGFILE " was ";
                print LOGFILE $lines[0];
                print LOGFILE "\n";
    					}else {
    						print "$anlead Sorry I don't get that\n";
    					}
    				}
    				
    			}
    			
    		}
    	}elsif($in =~ /(When\s(was|did)\s(\w+)\s(\w+)\s(\w+))|(When\s(was|did)\s(\w+)\s(\w+))/){ # when was question
        # reformulating
        if (defined $1) {
          $in = $3. " " . $4 . " was " . $5;
          $i = $3. " " . $4;
          $in2 = $5;
          #print $in;
        } else {
          $in = $8. " was " . $9;
          $i = $8;
          $in2 = $9;
        }
    		# looking for answers
    		my $wiki = WWW::Wikipedia->new();
    		my $result = $wiki->search($i);
        # no entry in wikipedia
    		if (!$result){
    			print "$anlead Sorry I don't get that \n";
    		}
    		else {
    			my $info = $result->text_basic();
          print LOGFILE $info;
          print LOGFILE "\n";
    			# find answer
    			if ($info =~ /$in/i) {
    				print $anlead;
    				#print "$info\n";
    				$info ="$&$'";
    				my @lines = split (/\.\s*[A-Z]*<*/, $info);
            if ($lines[0] =~ /[0-9]{4,}/) {
                  $lines[0] ="$`$&";
            }
    				print "$lines[0].\n";
            print LOGFILE $lines[0];
    			}
          # tilling
    			else{
    				if ($info =~ /$in2/i){
    					print $anlead;
    					$info ="$&$'";
    					my @lines = split (/\.\s*[A-Z]*<*/, $info);
              if ($lines[0] =~ /\)/) {
                  $lines[0] ="$`$&";
              }
              if ($lines[0] =~ /[0-9]{4,}/) {
                  $lines[0] ="$`$&";
              }
              $lines[0] =~ s/born/born on/g;
    					print $i. " was $lines[0].\n";
              print LOGFILE $lines[0];
              print LOGFILE "\n";
    				}
            else {
    					print "$anlead Sorry I don't get that\n";
    				}
    			}
    			
    		}
    	}elsif($in =~ /Where\s(did|was)\s(\w+)\s(\w+)/){ # other where questions
        # reformulating
    		$in = $2. " " . $3;
    		$i = $2;
    		$in2 = $3;
    		#print "$in\n";
        # looking for answer
    		my $wiki = WWW::Wikipedia->new();
    		my $result = $wiki->search($i);
        # no entry in wikipedia
    		if (!$result){
    			print "$anlead Sorry I don't get that \n";
    		}
    		else {
    			my $info = $result->text_basic();
          print LOGFILE $info;
          print LOGFILE "\n";
    			# find answer
    			if ($info =~ /$in/i) {
    				print $anlead;
    				#print "$info\n";
    				$info ="$&$'";
    				my @lines = split (/\.\s*[A-Z]*<*/, $info);
    				print "$lines[0].\n";
            print LOGFILE $lines[0];
            print LOGFILE "\n";
    			}
          # tilling
    			else{
    				if ($info =~ /$in2/i){
    					print $anlead;
    					$info ="$&$'";
    					my @lines = split (/\.\s*[A-Z]*<*/, $info);
    					print $i. " $lines[0].\n";
              print LOGFILE $i;
              print LOGFILE $lines[0];
              print LOGFILE "\n";
    				}else {
    					print "$anlead Sorry I don't get that\n";
    				}
    			}
    			
    		}
    	}
    	
    }
    else{ # no answer find
    	print "$anlead Sorry I don't get that\n";
    }
}

close(LOGFILE) || print "Couldn't close file properly";
##----- MAIN - PROGRAM - END -----##
####################################


