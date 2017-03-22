#!/usr/bin/env python
""" Parameters, Unpacking, Variables """

from __future__ import print_function, division
from sys import argv
from builtins import input  # pylint: disable=redefined-builtin

def main():
    """ Main routine """

    # pylint: disable=unbalanced-tuple-unpacking
    script, first, second, third = argv

    print("The script is called:", script)
    print("Your first variable is:", first)
    print("Your second variable is:", second)
    print("Your third variable is:", third)
    in1 = input("Pick something 1: ")
    in2 = input("Pick something 2: ")
    print("You entered {} and {}.".format(in1, in2))

if __name__ == "__main__":
    main()
