# **OVERVIEW**

## This repo contains small NLP related projects I have done

# **Academic Eliza**

**Overview**: This is an Eliza program written in Perl. It serves as an academic advisor for college kids. This program tries to engage a dialoge with the user.

**Run**: perl academic.pl

# **Decision Tree**

**Overview**: Applied the decision list method described in Yarowsky’s decision list paper “Decision Lists For Lexical Ambiguity Resolution”. This project is written in Perl.

**Details**: This is a decision list classifier with three Perl programs to perform word sense disambiguation: 
* **decision-list-train.pl** learns a decision list from sense tagged training data (interest and line data)
* **decision-list-test.pl**  applies decision list to each of the context found in text and assign a sense to each context
* **decision-list-eval.pl** decision-list-eval.pl compares answer file with the gold standard answers given, computes the accuracy of sense tagging, and also outputs a confusion matrix

# **QA System**
**Overview**: This is a Question Answering (QA) system written in Perl. The system is able to answer Who, What, When and Where questions by interacting with Wikipidia.

**Details**:
The system takes an similar approach to the AskMSR system

User should ask fact questions and the questions need to be well formed and grammatical

**Run**: This program runs interactively, and prompts the user for questions until the user says "exit"

perl qa-system.pl mylogfile.txt
