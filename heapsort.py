#!/usr/bin/env python
""" Heapsort in Python """

from __future__ import print_function, division

def main():
    """ Main routine """
    arr = [3, 7, 1, 2, 9, 0, 5, 8, 4, 6]
    print(arr)
    heap_heapify(arr)
    print(arr)
    heap_put(arr, 12)
    print(arr)
    heap_put(arr, 4)
    print(arr)
    heapsort(arr)
    print(arr)

def heap_put(arr, data):
    """ Puts data into the heap """
    arr.append(data)
    _siftup(arr, len(arr)-1)

def _siftup(arr, i):
    """ Sifts node i up the heap to the proper location """
    while i:
        parent = (i-1) // 2
        if arr[i] <= arr[parent]:
            break
        arr[i], arr[parent] = arr[parent], arr[i]
        i = parent

def _siftdown(arr, i):
    """ Sifts the heap item at location i down the heap """
    lastleaf = len(arr) - 1
    child = i * 2 + 1           # left child
    while child <= lastleaf:
        if child < lastleaf and arr[child+1] > arr[child]:
            child += 1          # right child
        if arr[i] >= arr[child]:
            break
        arr[i], arr[child] = arr[child], arr[i]
        i = child
        child = i * 2 + 1

def heap_heapify(arr):
    """ Creates a max heap from an array """
    for i in range((len(arr)-1) // 2, -1, -1):
        _siftdown(arr, i)

def _heapsort(arr):
    """ Sorts arr using a heap """
    heap_heapify(arr)
    # need to think here

def heapsort(arr):
    """ Heapsort """
    # Make the heap
    lastleaf = len(arr) - 1
    for i in range((lastleaf-1) // 2, -1, -1):
        parent = i
        child = parent * 2 + 1      # left child
        while child <= lastleaf:
            if child < lastleaf and arr[child+1] > arr[child]:
                child += 1          # right child
            if arr[parent] > arr[child]:
                break
            arr[parent], arr[child] = arr[child], arr[parent]
            parent = child
            child = parent * 2 + 1
    print(arr)
    # Sort the heap
    for i in range(len(arr)-1, 0, -1):
        arr[0], arr[i] = arr[i], arr[0]
        lastleaf = i-1
        parent = 0
        child = parent * 2 + 1      # left child
        while child <= lastleaf:
            if child < lastleaf and arr[child+1] > arr[child]:
                child += 1          # right child
            if arr[parent] > arr[child]:
                break
            arr[parent], arr[child] = arr[child], arr[parent]
            parent = child
            child = parent * 2 + 1

if __name__ == "__main__":
    main()
