#! /usr/bin/env python
""" Prompting People """

from __future__ import print_function, division

def main():
    """ Main routine """
    age = input("How old are you? ")
    height = input("How tall are you? ")
    weight = input("How much do you weigh? ")

    print("So, you're {} old, {} tall and {} heavy.".format(age, height, weight))

if __name__ == "__main__":
    main()
