#!/usr/bin/env python
""" CAR Hoare's Implementation of quicksort """

from __future__ import print_function, division

def main():
    """ Main routine """
    arr = [3, 7, 1, 2, 9, 0, 5, 8, 4, 6]
    # arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    print(arr)
    qsort(arr, 0, len(arr)-1)
    print(arr)

def insertsort(arr, left, right):
    """ Insertion Sort """
    for i in range(left+1, right+1):
        save = arr[i]
        j = i-1
        while j >= left and arr[j] > save:
            arr[j+1] = arr[j]
            j -= 1
        arr[j+1] = save

def qsort(arr, left, right):
    """
    Hoare's partition quicksort scheme with median of three and tail
    recursion elimination
    """
    # pylint: disable=too-many-branches
    print(left, right)
    while left < right:
        # median of 3 - arr[left+1] <= arr[left] <= arr[right]
        # provides a sentinel moving to the right so inner loop is tight
        mid = left + (right - left) // 2
        if arr[mid] > arr[left]:
            arr[mid], arr[left] = arr[left], arr[mid]
        if arr[mid] > arr[right]:
            arr[mid], arr[right] = arr[right], arr[mid]
        if arr[left] > arr[right]:  # Sentinel to remove bound check
            arr[left], arr[right] = arr[right], arr[left]
        if (right - left) > 3:      # Put min of 3 at left+1
            arr[left+1], arr[mid] = arr[mid], arr[left+1]
        # Init loop variables
        pivot = arr[left]
        i = left+1
        j = right
        while True:
            while arr[i] < pivot:
                i += 1
            while pivot < arr[j]:
                j -= 1
            if i >= j:
                break
            arr[i], arr[j] = arr[j], arr[i]
            i += 1
            j -= 1
        arr[left], arr[j] = arr[j], arr[left]
        # Use manual tail call elimination to minimize stack space
        if j <= mid:
            if left < (j-1):
                qsort(arr, left, j-1)
            left = j+1
        else:
            if (j+1) < right:
                qsort(arr, j+1, right)
            right = j-1

def qsort2(arr, left, right):
    """ Quicksort without a partition """
    if left >= right:
        return
    pivot = arr[left + (right - left) // 2]
    i = left
    j = right
    while True:
        while arr[i] < pivot:
            i += 1
        while pivot < arr[j]:
            j -= 1
        if i >= j:
            break
        arr[i], arr[j] = arr[j], arr[i]
        i += 1
        j -= 1
    qsort2(arr, left, j)
    qsort2(arr, j+1, right)

def qsortl(arr, left, right):
    """ Lomuto partition quicksort scheme """
    while left < right:
        mid = left + (right - left) // 2
        arr[left], arr[mid] = arr[mid], arr[left]
        pivot = arr[left]
        last = left
        for i in range(left+1, right+1):
            if arr[i] < pivot:
                last += 1
                arr[i], arr[last] = arr[last], arr[i]
        arr[left], arr[last] = arr[last], arr[left]
        # Use manual tail call elimination to minimize stack space
        if last <= mid:
            if left < (last-1):
                qsortl(arr, left, last-1)
            left = last+1
        else:
            if (last+1) < right:
                qsortl(arr, last+1, right)
            right = last-1

if __name__ == "__main__":
    main()
