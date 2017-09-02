#!/usr/bin/env python
""" Hash Testing """

from __future__ import print_function, division

def main():
    """ Main routine """
    hash_size = 13
    print("Hash size is {}".format(hash_size))
    print(mkhash("Curt") % hash_size)
    print(mkhash("Kelly") % hash_size)
    print(mkhash("curt@matzzone.com") % hash_size)
    print(mkhash("curtis@matzzone.com") % hash_size)
    print(mkhash("kelly@matzzone.com") % hash_size)
    print(mkhash("sara@matzzone.com") % hash_size)

def mkhash(key):
    """ Generates a hash of a string """
    hashnum = 5381
    for __c in key:
        hashnum = ((hashnum << 5) + hashnum) + ord(__c)
    return hashnum

if __name__ == "__main__":
    main()
