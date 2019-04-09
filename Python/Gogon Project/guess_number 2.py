#!/usr/bin/env python3.7
#import section
import random
import sys

def playyn(text):
    question = "n"
    while question != "y" or question != "n":
        question = input(text)
        question = question.lower()
        if question == "y":
            print("Cool - lets play...") 
            return
        elif question == "n":
            print("OK then bye")
            return("exit")
        else:
            print("You need to enter n or y.")

def game():
    random_number = random.randint(1,10)
    guessed_number = 0
    tries = 1
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
        except:
            print("You need to enter a number between 1 and 10.")
        tries += 1

    print("Well done - you guessed in "+str(tries-1)+" tries.")
    return

def main_code():
    notplayed = True
    playyn_ans = "undecided"
    uname = input("Hello, What is your Name? ")
    print("Hello "+uname+".","How are you doing today?")
  
    #Ask if the user wants to play..
    while playyn_ans != "exit":
        if notplayed:
            playyn_ans = playyn("Do you want to play a game? ")
        else:
            playyn_ans = playyn("Do you want to play again? ")
        if playyn_ans != "exit":
            game()
            notplayed = False
    return
    
main_code()