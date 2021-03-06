#!/usr/bin/perl

# This is eliza the academic advisor perl program for CS5761 Fall2015 PA1
# Written by Xinru Yan, University of Minnesota Duluth, yanxx418@d.umn.edu
# Sept 19th, 2015
#
# Introduction
# ELIZA is a computer program for the study of Natural Language Communication
# between man and machine invented by Joseph Weizenbaum in 1966. Input sentences
# are analyzed on the basis of decomposition rules which are triggered by key 
# words appearing in the input text. Responses are generated by reassembly 
# rules associated with selected decomposition rules.
#
# For this programming assignment I implement a simply version of Eliza, which 
# serve as an academic advisor for students, in perl. The main scheme this program
# use is keyword spot and pattern transform by using regex. 
# 
# example of input and output:
# input: What if I can't graduate?
# output: How many years left for you to graduate?
# the program detect keyword "graduate" for the first time and output 
# matched response (first response in the array).
# 
# subroutines: 
# &language_check:
#   0.flag set to false (in data structure)
#   1.check the dirty words 
#   2.set the flag to true if keyword detected
#   3.return flag
# &keyword_spotting:
#   0.flag set to true (in main program)
#   1.check for complexity. 
#   2.keywords check:
#       importance is determined by the order
#       different responses match each check
#       flag will be set to false if keyword detected
#       part of memory impplement here
#   3.if any keywords have been detected, set the $no_match to 0
#   4.return flag
# &pattern_transform (scheme is similar to &keyword_spotting)
#   0.flag set to true (in main program)
#   1.pattern check
#   2.if any pattern detected, set the $no_match to 0
#   3.return flag
# &keep_talking
#   an array stores different responses to keep the user taking
#   rendomly choose one to response
#   $no_match will be add 1 if the subroutine has been used
# &go_memory
#   an array stores different questions to get personal info
#   print one each time (in oder) 


use strict;
use warnings;

#########################################
##----- DATA - STRUCRTURE - START -----##
# constant value for true/false
use constant { true => 1, false => 0 };
# used in the while loop for getting user input
my $running = true;
# store string "Academic Advisor >" for leading eliza
my $advisor = "Academic Advisor >";
# store string "You < " for leading user input
my $user = "You < ";
# greeting and ask for name
my $greeting = "$advisor Hi, I'm an Academic Advisor. What's your name?\n";
# flag for subroutine &language_check
my $badlanguage = false;
# keep track of how many times keyword spotting failed 
my $no_match = 0;
# flag for subroutine &keyword_spotting
my $keycheck;
# flag for subroutine &pattern_transform
my $transcheck;
# array for storing userinput for memory
my @remember;
# keep track of how many questions have been asked for memory
my $memory = 0;
# $i, $j, $p, $k, $l, $o all served in array tracking
my $i = 0;
my $j = 0;
my $p = 0;
my $k = 0;
my $l = 0;
my $o = 0;
# the very first user input for checking name use 
my $START;
# store user name
my $name = "" ;
my $tmp = "" ;

##----- DATA - STRUCTURE - END -----##
######################################

###################################
##----- SUBROUTINES - START -----##

# subroutine language_check
sub language_check {
  # pass in user input
  my $string = $_[0];
  # dirty words check
  if ($string =~ /shit|fuck|damn|wtf/i) {
    #set the flag 
    $badlanguage = true;
  }
  # return flag
  return $badlanguage; 
}

# subroutine keyword_spotting
# there are certain responses for each check. 
# keycheck flag will be set to false for each check
sub keyword_spotting {
  # pass in user input
  my $string = $_[0];
  # complexity check: if user type in too much words
  my $num = $string =~ tr/([a-z]|[A-Z]//;
  if ($num > 70) {
      print "$advisor Sorry I didn't catch up on what you said. Can you break that apart?\n";
      $keycheck = false;
  }
  # keywords check
  else {
    # strong negative feeling
    if ($string =~ /depress|so sad|upset/) {
      print "$advisor $name, are you okay? What's going on?\n";
      $keycheck = false;
    }
    # problem question concern
    elsif ($string =~ /(problem|question|concern)/i) {
        print "$advisor I'm here to help you! What's up?\n";
        $keycheck = false;
    }
    # major minor class
    # warning 3 responses means the program only handles the keyword 3 times
    elsif ($string =~ /major|minor|class/i) {
      my @answer;
      $answer[0] = "$advisor What do you think about it?\n";
      $answer[1] = "$advisor Have you thought about switch to another one?\n";
      $answer[2] = "$advisor How do you like your minor?\n";
      print $answer[$p];
      $p++;
      $keycheck = false;
    }
    # credit
    # warning 2 responses means the program only handles the keyword 2 times
    elsif ($string =~ /credit/i) {
      my @answer;
      $answer[0] = "$advisor What's the appropriate amount of credits you think you can handle per semester?\n";
      $answer[1] = "$advisor How many credits left for you to graduate?\n";
      print $answer[$k];
      $k++;
      $keycheck = false;
    }
    # graduate degree
    elsif ($string =~ /graduate|degree/i) {
      my @answer;
      $answer[0] = "$advisor How many years left for you to graduate?\n";
      $answer[1] = "$advisor What degree you will have when you graduate?\n";
      print $answer[$l];
      $l++;
      $keycheck = false;
    }
    # freshman sophomore junior senior
    elsif ($string =~ /freshman|sophomore|junior|senior/i) {
      print "$advisor What's your academic plan for next year?\n";
      $keycheck = false;
    }
    # transfer
    # warning 2 responses means the program only handles the keyword 2 times
    elsif ($string =~ /transfer/i) {
      my @answer;
      $answer[0] = "$advisor In what year did you get transferred?\n";
      $answer[1] = "$advisor So how did the class transformation go? I know sometimes it can be really hard.\n";
      print $answer[$o];
      $o++;
      $keycheck = false;
    }
    # research
    elsif ($string =~ /research/i) {
      print "$advisor What do you want to research on?\n";
      $keycheck = false;
    }
    # uncertainty
    elsif ($string =~ /(maybe|perhaps|not sure|possible|possibly|likely)/i) {
      print "$advisor Can you explain it more\n";
      $keycheck = false;
    }
    # don't know|do not know|no idea|no clue
    elsif ($string =~ /(don't know|do not know|no idea|no clue)/) {
        print "$advisor I'm worried about you that you don't have a clear mind. College students should take good care of their academic life.\n";
        $keycheck = false;
    }
    # yes no 
    elsif ($string =~ /\byes\b|\bno\b|nope|yeah|yep|yup/i) {
      print ("$advisor Are you sure about that? Make your decision wisely, $name.\n");
      $keycheck = false;
    }
    # keyword check for memmory use
    # warning: user's response must contain keywords below to get stored in memory!
    elsif ($string =~ /favorite professor|favorite place|favorite college|favorite subject|favorite book|favorite department/i) {
        $_ = $string;
        # trim off \n
        s/\n//g;
        # chang my to you
        s/My/your/;
        $remember[$j] = $_;
        $j++;
        $keycheck = false;
        # $memory +1  
        $memory ++;
        # if 3 questions already been asked
        if ($memory > 1) {
          $memory = 0;
          # $s for keep array use
          my $s = 0;
          # memory
          print "$advisor I remember you told me about $remember[$s] Can you tell me more about it?\n";
          $s++;
        }
        else {
          print "$advisor OK.\n";
        }
    }
    # exit the program
    elsif ($string =~ /\bexit\b/ ) {
        print "$advisor Bye bye $name. Have fun this semester! If you have any questions arise later feel free to come to me!\n";
        $running = false;
        exit;
    }
    # giberrish check
    elsif ($string =~ /[~\$\*\^%@()\+=\[\]\|#]/) {
      print "$advisor I don't really understand. Can you elaborate on that?\n";
      $keycheck = false;
    }
  }
  
  # if keyword has been found, set the no_match value to 0;
  if (!$keycheck) {
    $no_match = 0;
  }
  # return flag
  return $keycheck;


}

# subroutine patter_transform
# flag will be set to false for each transform 
sub pattern_transform {
  # pass in user input
  my $string = $_[0];
  # pattern I don't X my...
  if ($string =~ /I\s(don't|do not|)\s\w*\smy/) {
      $_ = $string;
      s/I/Why do you think you/;
      s/my/your/;
      s/\./\?/;
      print "$advisor ";
      print $_ ;
      #print "\n";
      $transcheck = false;
  }
  # pattern She/He/You X me Y
  elsif ($string =~ /(She|He|You)\s\w+\sme\s\w+\./) {
      print "$advisor ";
      print "What exactly makes you feel like ";
      $_ = $string;
      s/She/she/;
      s/He/he/;
      s/You/I/;
      s/me/you/;
      s/\./\?/;
      print $_ ;
      #print "\n";
      $transcheck = false;
  }
  # pattern ... should ...
  elsif ($string =~ /should/) {
      $_ = $string;
      print "$advisor Suppose ";
      s/I/you/;
      s/You/I/;
      s/She/she/;
      s/He/he/;
      print $_;
      $transcheck = false;
  }
  # if pattern has been found, set the no_match value to 0;
  if (!$transcheck) {
    $no_match = 0;
  }
  # return flag
  return $transcheck;
}

# subroutine keep_talking
# a set of statements to keep user talking
sub keep_talking {
  my @NONE;
  $NONE[0] = "$advisor Tell me more.\n";
  $NONE[1] = "$advisor Please continue.\n";
  $NONE[2] = "$advisor Keep going.\n";
  $NONE[3] = "$advisor Please go on.\n";
  # randomly select one to prompt
  print $NONE[int(rand(@NONE))];
  # no_match value +1 for use &go_memory
  $no_match++;
}

# subroutine go_memory
# a set of statements to get personal info
sub go_memory {
  # array for getting personal info
  my @NONE; 
  $NONE[0] = ("$advisor Which professor do you like the most so far?\n");
  $NONE[1] = ("$advisor What's your favorite subject, $name?\n");
  $NONE[2] = ("$advisor What's your favorite department?\n");
  $NONE[3] = ("$advisor What's the favorite place on campus, $name?\n");
  $NONE[4] = ("$advisor Which book interests you the most?\n");
  print $NONE[$i];
  $i++;
}

##----- SUBROUTINES - END-----##
################################

######################################
##----- MAIN - PROGRAM - START -----##

# step1 intro
print "\nThis is Eliza The Academic Advisor (PA1 CS5761 Fall2015), written by Xinru Yan :p\n\n";

# step2 greetings and get the user name
print $greeting;
print $user ;

$START = <>;
$_ = $START;

# regex I'm/I am/My name is/Call me for getting the name
if(/[Ii]'m |[Ii] am |[Mm]y name is |[Cc]all me/s) {
	($tmp,$name) = /(.*'m|.* am|.* is|.* me) (\b\S*\b).*/;
}
# check for other input
else {
	if(/^[A-Za-z]+$|^[A-Z][a-z]*\s[A-Z][a-z]+.*/s)
	{
		($name, $tmp) = /(\S*)(.*)/;
	}
}
# if get the user name, change user input leading
if($name) {
	$user = join "", $name , "< " ;
	print "$advisor Nice to meet you, $name. How's this semester going? Any problems?\n";
}
# else keep original user input leading
else{
	print "$advisor Sorry I didn't catch up your name. How can I help you?\n";
}


# step3 while loop
while ($running) {
  # set flags
  $keycheck = true;
  $transcheck = true;
  # print user input leading
  print $user ;
  my $in = <>;
  # laguage check
  &language_check($in );
  if ($badlanguage ) {
         print "$advisor Watch out your language. Life is good. Keep calm and enjoy it!\n" ;
	       $badlanguage = false ;
  }
  # other check
  else {
    # keyword spot
    &keyword_spotting($in);
    # keyword spot failed
    if ($keycheck) {
      # pattern transfer
      &pattern_transform($in);
    }
    # none key word detected/pattern detected for more than twice, go get personal info
    if ($no_match >0) {
      &go_memory;
    }
    # if none keyworad matched nor pattern detected, let the user keep talking
    elsif (($keycheck) && ($transcheck)) {
      &keep_talking;
    }
  }
}

##----- MAIN - PROGRAM - END -----##
####################################

