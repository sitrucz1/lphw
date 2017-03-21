#! /usr/bin/env python
""" Prompting and Passing """

from __future__ import print_function, division
from builtins import input  # pylint: disable=redefined-builtin
from sys import argv

def main():
    """ Main routine """

    # pylint: disable=unbalanced-tuple-unpacking
    script, user_name = argv
    prompt = "> "

    print("Hi {}, I'm the {} script.".format(user_name, script))
    print("I'd like to ask you a few questions.")
    print("Do you like me {}?".format(user_name))
    likes = input(prompt)

    print("Where do you live {}?".format(user_name))
    lives = input(prompt)

    print("What kind of computer do  you have?")
    computer = input(prompt)

    print("""
    Alright, so you said {!r} about liking me.
    You live in {!r}.  Not sure where that is.
    And you have a {!r} computer.  Nice.
    """.format(likes, lives, computer))

if __name__ == "__main__":
    main()
