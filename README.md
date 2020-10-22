# CS 514 Applied Artificial Intelligence

## Project 2 : Domain: Vacation Recommender

Abstract

Weekend Planner is an expert system built using JESS rule engine that helps you to
determine the place that you would like to visit during a weekend or a vacation. This system
gives recommendation based on the person’s budget, no of days he has, his preferred
mode of transportation, his place of interest and the distance he wants to travel. It also
validates his budget and travel plan.

Features:

```
❖ The system takes following inputs to recommend a location:
```
1. Budget that a person has
2. Time for which he wants to travel
3. Distance he is willing to travel
4. Preferred mode of transportation
5. Does he want to go to the beach?
6. Is he interested in hiking?
7. Is he interested in historical landmarks?
❖ The system also validates the budget, i.e., whether it is possible to travel for those
many days with the budget he has and the mode of transportation that he is
planning to use.
❖ The system also checks whether the input is feasible or not.


Rules:

There are 26 rules in this application which are as follows

Rule 1: Setting up global variables

Rule 2: Prints user input data

Rule 3: Validates Travel Plan

Rule 4 – 24 : Finds a travel destination based on the travel plan.

Rule 25: Executes if travel plan does not exist

Rule 26: Provides input to the program

Instructions:

1. Extract the zip file and open the project in Eclipse
2. Include the “fuzzyJ-2.0.jar” in the library
3. In the edit configuration change the jess main class to “nrc.fuzzy.jess.FuzzyMain”
4. Run the file in eclipse

```
❖ Input is changed through Rule 26
```
Test Cases with Output:

1. Rule 4 :
    (assert (planner (distance 100 )(budget 150 )(time 1 )(hike 0 )(beach
    1 )(history 0 )(preference 0 )))
2. Rule 7:
    (assert (planner (distance 4000 )(budget 6000 )(time 5 )(hike 0 )(beach
    1 )(history 0 )(preference 1 )))


3. Rule 1 3
    (assert (planner (distance 1500 )(budget 1000 )(time 3 )(hike 1 )(beach
    0 )(history 0 )(preference 1 )))
4. Rule 1 8
    (assert (planner (distance 800 )(budget 400 )(time 2 )(hike 0 )(beach
    0 )(history 1 )(preference 1 )))

Summary:

The vacation recommender can recommend places for you to visit based on your input
criteria.
