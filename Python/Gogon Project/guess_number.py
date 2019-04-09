#!/usr/bin/env python3.7
#import section
import random
import sys 


def main_code():
    #variables
    random_number = random.randint(1,10)
    guessed_number = 0
    tries = 1
    question = "n"
    
    #Ask if the user wants to play..
    uname = input("Hello, What is your Name? ")
    print("Hello "+uname+".","How are you doing today?")
    while question != "y" or question != "n":
        question = input("Would you like to play a game?")
        question = question.lower()
        if question == "y":
            print("Cool - lets play...") 
            break
        elif question == "n":
            #If the user doesn't want to play then return to OS
            print("OK then bye")
            return
        else:
            print("You need to enter n or y.")
    
    #If the user wants to play then you reach this code.
    print("I'm thinking of a number between 1 and 10 - can you guess what it is?")
    while guessed_number != random_number:
        try:
            print("Enter your "+str(tries)+" guess : ")
            guessed_number = int(input())
            #guessed_number = int(guessed_number)
            if guessed_number < random_number:
                print("It's higher than that...") 
            elif guessed_number > random_number:
                print("It's lower than that")
            tries += 1
        except:
            print("You need to enter a number between 1 and 10.")
    
    print("Well done - you guessed in "+str(tries)+" tries.")

main_code()