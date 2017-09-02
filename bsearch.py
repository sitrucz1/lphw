#!/usr/bin/env python
""" Binary Search Testing """

from __future__ import print_function, division
from random import randint

def main():
    """ Main routine """
    samples = 10
    items = [i for i in range(1, samples+1, 3)]
    print(items)
    ssum1 = 0
    ssum2 = 0
    ssum3 = 0
    for __i in range(samples):
        rand = randint(1, samples)
        print("random {}".format(rand))
        ssum1 += bsearch1(items, rand)
        ssum2 += bsearch2(items, rand)
        ssum3 += intbsearch(items, rand)
    print(ssum1 / samples)
    print(ssum2 / samples)
    print(ssum3 / samples)

def bsearch1(items, key):
    """ Binary Search 3 Conditions """
    left = 0
    right = len(items)-1
    count = 0
    while left <= right:
        count += 1
        mid = left + (right - left) // 2
        if key == items[mid]:
            count += 1
            return count
            # return mid
        elif key < items[mid]:
            count += 2
            right = mid-1
        else:
            count += 2
            left = mid+1
    count += 1
    return count
    # return -1

def bsearch2(items, key):
    """ Binary Search 2 Conditions """
    left = 0
    right = len(items)-1
    count = 0
    mid = left + (right - left) // 2
    while left < right and key != items[mid]:
        count += 2
        if key < items[mid]:
            count += 1
            right = mid-1
        else:
            count += 1
            left = mid+1
        mid = left + (right - left) // 2
    if left >= right:
        count += 1
    else:
        count += 2
    if key == items[mid]:
        count += 1
        return count
        # return mid
    else:
        count += 1
        return count
        # return -1

def intbsearch(items, key):
    """ Interpolation Binary Search 3 Conditions """
    left = 0
    right = len(items)-1
    count = 0
    while items[left] != items[right] and items[left] <= key and key <= items[right]:
        count += 3
        mid = int(left + (key - items[left]) / (items[right] - items[left]) * (right - left))
        print("Mid is {}".format(mid))
        if key == items[mid]:
            count += 1
            return count
            # return mid
        elif key < items[mid]:
            count += 2
            right = mid-1
        else:
            count += 2
            left = mid+1
    if items[left] == items[right]:
        count += 1
    elif items[left] > key:
        count += 2
    else:
        count += 3
    if key == items[left]:
        count += 1
        return count
        # return left
    else:
        count += 1
        return count
        # return -1

if __name__ == "__main__":
    main()
