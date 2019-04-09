#!/usr/bin/env python3.7
#import section.
#Get_words_from_dictionary.py
from random import choice, sample
import sys

#Functions below.

#Open dictionary file for reading and create Python 'set' of words.
def load_words():
    with open('/home/mark/coding/Python/Dict/english-words-new/words_alpha.txt') as word_file:
        words = set(word_file.read().split())
    return words


#Return random words
def get_word(english_words_set,min_num,max_num):
    while True:
        word = choice(list(english_words_set))
        if len(word) >= min_num and len(word) <= max_num:
            return word


#Load words into a set.
english_words_set = load_words()

'''
Pseudo code - selection of words for Gogen.
Rules
25 letters total only (no z).
Each letter of the alphabet must only appear once.
Word can be a minimum and 3 chars and a maximum of 8 - Done
'''
#Main code.
#Set word count to 1.
word_count = 1
#Create string with all the letters of the alphabet except z.
alphabet_string = ("abcdefghijklmnopqrstuvwxy")
#Dictionary for the alphabet to store if the letters have been found.
alphabet_dict = {
                'a': False, 'b': False, 'c': False, 'd': False, 'e': False,
                'f': False, 'g': False, 'h': False, 'i': False, 'j': False, 
                'k': False, 'l': False, 'm': False, 'n': False, 'o': False, 
                'p': False, 'q': False, 'r': False, 's': False, 't': False, 
                'u': False, 'v': False, 'w': False, 'x': False, 'y': False
                }
#Counter for the number of matches found in the alphabet - once we hit 25 or over, we stop looking.
alphabet_matches = 0
#List for storing the final word list we will use to create the Gogen.
final_word_list = []
#Boolean for whether or not we have found all the letters of the alphabet (except z).
all_letters_consumed = False
#Generate word list for Gogen.
while not all_letters_consumed:
    english_word = get_word(english_words_set,3,8)
    #Rules
    #1. Check word has no duplicate letters - Done.
    english_word_letter = 0
    english_word_length = len(english_word)
    has_duplicates = False
    while english_word_letter <= english_word_length-1:
        if english_word.count(english_word[english_word_letter]) > 1:
            english_word_letter += 1
            has_duplicates = True
            break
        else:
            english_word_letter += 1
    
    #2. Update values in alphabet dictionary to 'True' for the letters found
    if not has_duplicates:
        for english_word_letter in english_word:
            alphabet_dict[english_word_letter] = True
    #3. Check word_list does not have all letters of the alphabet consumed - in progress.
        for letter in alphabet_dict:
            if alphabet_dict[letter] == False:
                all_letters_consumed = False
                final_word_list.append(english_word)
                word_count += 1
                break
            else:
                all_letters_consumed = True
            
    if all_letters_consumed == True and not has_duplicates:
        final_word_list.append(english_word)
        word_count += 1
                
    '''if not has_duplicates:
        for letter in english_word:
            found_match = alphabet_string.count(letter)
            if found_match:
                alphabet_matches += 1 '''
    
print(final_word_list)
'''
Test alphabet Tuple
alphabet_count = 0
while alphabet_count <= len(alphabet_tuple)-1:
    print(alphabet_tuple[alphabet_count])
    alphabet_count += 1

while alphabet_count <= len(alphabet_string)-1:
temp_word_list.append(english_word)

alphabet_count = 0
alphabet_count += 1  
temp_word_list = []
'''
#print(english_words{1})

# demo print
# random_word = random.choice(english_words)
# print(random_word)

'''Ditch code
The below was removed as it didn't work well.
'''
#from random_word import RandomWords
#words = RandomWords()
#print(words.get_random_word(hasDictionaryDef="True"))

