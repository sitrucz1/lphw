#!/usr/bin/env python
""" More Files """

from __future__ import print_function, division
from builtins import input  # pylint: disable=redefined-builtin
from sys import argv
from os.path import exists

def main():
    """ Main routine """
    script, from_file, to_file = argv # pylint: disable=unbalanced-tuple-unpacking, unused-variable

    print("Copying from {} to {}".format(from_file, to_file))

    # we could do these two on one line too, how?
    in_file = open(from_file)
    indata = in_file.read()

    print("The input file is {} bytes long".format(len(indata)))

    print("Does the output file exist? {!r}".format(exists(to_file)))
    print("Ready, hit RETURN to continue, CTRL-C to abort.")
    input()

    out_file = open(to_file, 'w')
    out_file.write(indata)

    print("Alright, all done.")

    out_file.close()
    in_file.close()

if __name__ == "__main__":
    main()
