# **OVERVIEW**

## This repo contains small NLP related projects I have done

# **Academic Eliza**

**Overview**: This is an Eliza program written in Perl. It serves as an academic advisor for college kids. This program tries to engage a dialoge with the user.

**Example**: Below is an example of the system interacting with an user
```
Academic Advisor > Hi, I'm an Academic Advisor. What's your name?
You < ted
Academic Advisor > Nice to meet you, ted. How's this semester going? Any problems?
ted< i am failing math.
Academic Advisor > Please continue.
ted< i want to drop my math class.
Academic Advisor > What do you think about it?
ted< i hate it.
Academic Advisor > Tell me more.
ted< it makes me angry.
Academic Advisor > Which professor do you like the most so far?
ted< dr. dunham is very nice.
```
**Run**: 
```
perl academic.pl
```

# **Decision Tree**

**Overview**: Applied the decision list method described in Yarowsky’s decision list paper “Decision Lists For Lexical Ambiguity Resolution”. This project is written in Perl.

**Details**: This is a decision list classifier with three Perl programs to perform word sense disambiguation: 
* **decision-list-train.pl** learns a decision list from sense tagged training data (interest and line data)
* **decision-list-test.pl**  applies decision list to each of the context found in text and assign a sense to each context
* **decision-list-eval.pl** decision-list-eval.pl compares answer file with the gold standard answers given, computes the accuracy of sense tagging, and also outputs a confusion matrix

# **QA System**
**Overview**: This is a Question Answering (QA) system written in Perl. The system is able to answer Who, What, When and Where questions by interacting with Wikipidia.

**Details**:
* **Approach** The system takes an similar approach to the AskMSR system
* **User** The user should ask well formed, fact questions
* **Record** The system keeps a log file that records the users question, the searches it actually executes, the raw results it obtains from Wikipedia, and finally the answer it generates.

**Example**: Below is an example of the system answering a "When" question
```
?> When was Washington born?
=> Sorry I don't get that
?> When was George Washington born?
=>George Washington was Born into the provincial gentry of Colonial Virginia, his family were wealthy planters who owned tobacco plantations and slaves which he inherited.
?> When was Obama born?
=>Obama was born on August 4, 1961.
?> When was Xinru born?
=> Sorry I don't get that 
```
**Run**: This program runs interactively, and prompts the user for questions until the user says "exit"
```
perl qa-system.pl mylogfile.txt
```
