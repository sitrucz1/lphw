#!/usr/bin/env python
""" Functions and Files """

from __future__ import print_function, division
from sys import argv

def main():
    """ Main routine """
    script, input_file = argv   # pylint: disable=unbalanced-tuple-unpacking, unused-variable

    current_file = open(input_file)

    print("First let's print the whole file:\n")

    print_all(current_file)

    print("Now let's rewind, kind of like a tape.")

    rewind(current_file)

    print("Let's print three lines:")

    current_line = 1
    print_a_line(current_line, current_file)

    current_line += 1
    print_a_line(current_line, current_file)

    current_line += 1
    print_a_line(current_line, current_file)

def print_all(fp_):
    """ Prints the whole file """
    print(fp_.read())

def rewind(fp_):
    """ Moves pointer to beginning of the file """
    fp_.seek(0)

def print_a_line(line_count, fp_):
    """ Prints a line in the file """
    print(line_count, fp_.readline(), end="")

if __name__ == "__main__":
    main()
