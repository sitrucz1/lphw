#!/usr/bin/env python
""" Names, Variables, Code, Functions """

from __future__ import print_function, division

def main():
    """ Main routine """
    print_two("Zed", "Shaw")
    print_two_again("Zed", "Shaw")
    print_one("First!")
    print_none()

# this one is like your scripts with argv
def print_two(*args):
    """ this one is like your scripts with argv """
    arg1, arg2 = args
    print("arg1: {!r}, arg2: {!r}".format(arg1, arg2))

# ok, that *args is actually pointless, we can just do this
def print_two_again(arg1, arg2):
    """ ok, that *args is actually pointless, we can just do this """
    print("arg1: {!r}, arg2: {!r}".format(arg1, arg2))

# this just takes one argument
def print_one(arg1):
    """ this just takes one argument """
    print("arg1: {!r}".format(arg1))

# this one takes no arguments
def print_none():
    """ this one takes no arguments """
    print("I got nothin'.")

if __name__ == "__main__":
    main()
