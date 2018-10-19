#!/usr/bin/env python
""" A hanoi implementation """

from __future__ import print_function, division
from random import shuffle

def main():
    """ Main routine """
    # hanoi()
    # mergesort()
    arr = [i for i in range(20, 0, -1)]
    shuffle(arr)
    print(arr)
    quicksort(arr, 0, len(arr)-1)
    print(arr)

def hanoi(disk=3, src="a", dest="c", aux="b"):
    """hanoi"""
    print(disk, src, dest, aux) # trace
    if disk > 0:
        hanoi(disk-1, src, aux, dest)
        print("**", disk, src, dest)
        hanoi(disk-1, aux, dest, src)

# pylint: disable=invalid-name

def mergesort(lo=0, hi=9):
    """mergesort"""
    if lo < hi:
        mi = lo + (hi-lo) // 2
        mergesort(lo, mi)
        mergesort(mi+1, hi)
        print(lo, mi, mi+1, hi)

def quicksort(arr, lo, hi):
    """quicksort"""
    if lo < hi:
        print(lo, hi)
        piv = arr[lo]
        i = lo+1
        j = hi
        while True:
            while i < hi and arr[i] < piv:
                i += 1
            while piv < arr[j]:
                j -= 1
            if i >= j:
                break
            arr[i], arr[j] = arr[j], arr[i]
            i += 1
            j -= 1
        arr[lo], arr[j] = arr[j], arr[lo]
        quicksort(arr, lo, j-1)
        quicksort(arr, j+1, hi)

if __name__ == "__main__":
    main()
