#!/usr/bin/env python
""" Reading the File test.txt """

from __future__ import print_function, division
from sys import argv

def main():
    """ Main routine """
    script, filename = argv # pylint: disable=unbalanced-tuple-unpacking, unused-variable

    print("Opening the file...")
    source = open(filename, 'r')

    print(source.read())

    print("And finally, we close it.")
    source.close()

if __name__ == "__main__":
    main()
