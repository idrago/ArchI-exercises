#!/usr/bin/env python3

from openai import OpenAI
import sys
import os
import re

# Set up your API key
client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])

# Check if the correct number of command line arguments is provided
if len(sys.argv) != 2:
    print("Usage: python translator.py <file_name>")
    sys.exit(1)

# Get the file name from the command line arguments
file_name = sys.argv[1]

# Check if the file exists
if not os.path.exists(file_name):
    print(f"File '{file_name}' does not exist.")
    sys.exit(1)

try:
    # Open the file in read mode
    with open(file_name, 'r') as file:
        # Read the contents of the file
        file_contents = file.read()

    promptbase = "I am preparing an exam, and need to translate the questions from English to Italian. Translate the text you will find in the following piece of code from English to Italian, keep the source code valid, return only the translation, no other comments: \n"
    promptbase += file_contents

    # print(promptbase + "\n\n")
    response = client.chat.completions.create(
        model="gpt-4-1106-preview",
        messages=[
            {"role": "system", "content": "Hello"},
            {"role": "user", "content": promptbase}
        ]
    )    
    print(response.choices[0].message.content)
    #print(promptbase)
    print("")

except Exception as e:
    print(f"An error occurred: {e}")
    sys.exit(1)






