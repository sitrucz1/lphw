#!/usr/bin/env python
""" Reading and Writing Files """

from __future__ import print_function, division
from builtins import input  # pylint: disable=redefined-builtin
from sys import argv

def main():
    """ Main routine """
    script, filename = argv # pylint: disable=unbalanced-tuple-unpacking, unused-variable

    print("We're going to erase {!r}.".format(filename))
    print("If you don't want that, hit CTRL-C (^C).")
    print("If you do want that, hit RETURN.")

    input("?")

    print("Opening the file...")
    target = open(filename, 'w')

    print("Truncating the file.  Goodbye!")
    target.truncate()

    print("Now I'm going to ask you for three lines.")

    line1 = input("line 1: ")
    line2 = input("line 2: ")
    line3 = input("line 3: ")

    print("I'm going to write these to the file.")

    target.write(line1)
    target.write("\n")
    target.write(line2)
    target.write("\n")
    target.write(line3)
    target.write("\n")

    print("And finally, we close it.")
    target.close()

if __name__ == "__main__":
    main()
