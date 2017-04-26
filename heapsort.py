#!/usr/bin/env python
""" Heapsort in Python """

from __future__ import print_function, division
from random import randrange

def main():
    """ Main routine """
    arr = [3, 7, 1, 2, 9, 0, 5, 8, 4, 6]
    print(_heap_isheap(arr), arr)
    heap_heapify(arr)
    print(_heap_isheap(arr), arr)
    for _ in range(10):
        heap_put(arr, randrange(20))
    print(_heap_isheap(arr), arr)
    heap_pop(arr)
    print(_heap_isheap(arr), arr)
    _heapsort(arr)
    print(arr)

def heap_put(arr, data):
    """ Puts data into the heap """
    arr.append(data)
    _siftup(arr, len(arr)-1)

def heap_get(arr):
    """ Peeks at the value at the top of the heap """
    if len(arr):
        return arr[0]
    else:
        return

def heap_pop(arr):
    """ Deletes the root from the heap """
    heapsize = len(arr)
    if not heapsize:
        return
    arr[0], arr[heapsize-1] = arr[heapsize-1], arr[0]
    _siftdown(arr, 0, heapsize-1)
    return arr.pop()

def _heap_isheap(arr):
    for child in range(len(arr)-1, 0, -1):
        parent = (child-1) // 2
        if arr[child] > arr[parent]:
            print("Node index {}={} has a child that doesn't match {}={}.".format(
                parent, arr[parent], child, arr[child]))
            return False
    return True

def _siftup(arr, root):
    """ Sifts node root up the heap to the proper location """
    save = arr[root]
    parent = (root-1) // 2
    while root and save > arr[parent]:
        arr[root] = arr[parent]
        root = parent
        parent = (root-1) // 2
    arr[root] = save

def _siftdown(arr, root, heapsize):
    """ Sifts the heap item at location root down the heap """
    save = arr[root]
    child = root * 2 + 1        # left child
    while child < heapsize:
        if child < (heapsize-1) and arr[child+1] > arr[child]:
            child += 1          # right child
        if save >= arr[child]:
            break
        arr[root] = arr[child]
        root = child
        child = root * 2 + 1
    arr[root] = save

def heap_heapify(arr):
    """ Creates a max heap from an array """
    heapsize = len(arr)
    for i in range((heapsize-2) // 2, -1, -1):
        _siftdown(arr, i, heapsize)

def _heapsort(arr):
    """ Sorts arr using a heap """
    heap_heapify(arr)
    for i in range(len(arr)-1, 0, -1):
        arr[0], arr[i] = arr[i], arr[0]
        _siftdown(arr, 0, i)

def heapsort(arr):
    """ Heapsort """
    # Make the heap
    heapsize = len(arr)
    for i in range((heapsize-2) // 2, -1, -1):
        root = i
        save = arr[root]
        child = root * 2 + 1        # left child
        while child < heapsize:
            if child < (heapsize-1) and arr[child+1] > arr[child]:
                child += 1          # right child
            if save >= arr[child]:
                break
            arr[root] = arr[child]
            root = child
            child = root * 2 + 1
        arr[root] = save
    print(arr)
    # Sort the heap
    for i in range(len(arr)-1, 0, -1):
        arr[0], arr[i] = arr[i], arr[0]
        heapsize = i
        root = 0
        save = arr[0]
        child = 1                   # left child
        while child < heapsize:
            if child < (heapsize-1) and arr[child+1] > arr[child]:
                child += 1          # right child
            if save >= arr[child]:
                break
            arr[root] = arr[child]
            root = child
            child = root * 2 + 1    # left child
        arr[root] = save

if __name__ == "__main__":
    main()
