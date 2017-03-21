#! /usr/bin/env python
""" Reading Files """

from __future__ import print_function, division
from builtins import input      # pylint: disable=redefined-builtin
from sys import argv

def main():
    """ Main routine """
    script, filename = argv     # pylint: disable=unbalanced-tuple-unpacking, unused-variable

    txt = open(filename)

    print("Here's your file {!r}:".format(filename))
    print(txt.read())
    txt.close()

    print("Type the filename again:")
    file_again = input("> ")

    txt_again = open(file_again)

    print(txt_again.read())
    txt_again.close()

if __name__ == "__main__":
    main()
