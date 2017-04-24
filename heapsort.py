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

def _siftup(arr, root):
    """ Sifts node i up the heap to the proper location """
    while root:
        parent = (root-1) // 2
        if arr[root] <= arr[parent]:
            break
        arr[root], arr[parent] = arr[parent], arr[root]
        root = parent

def _siftdown(arr, root, heapsize):
    """ Sifts the heap item at location i down the heap """
    child = root * 2 + 1        # left child
    while child < heapsize:
        if child < (heapsize-1) and arr[child+1] > arr[child]:
            child += 1          # right child
        if arr[root] >= arr[child]:
            break
        arr[root], arr[child] = arr[child], arr[root]
        root = child
        child = root * 2 + 1

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
        child = root * 2 + 1        # left child
        while child < heapsize:
            if child < (heapsize-1) and arr[child+1] > arr[child]:
                child += 1          # right child
            if arr[root] >= arr[child]:
                break
            arr[root], arr[child] = arr[child], arr[root]
            root = child
            child = root * 2 + 1
    print(arr)
    # Sort the heap
    for i in range(len(arr)-1, 0, -1):
        arr[0], arr[i] = arr[i], arr[0]
        heapsize = i
        root = 0
        child = 1                   # left child
        while child < heapsize:
            if child < (heapsize-1) and arr[child+1] > arr[child]:
                child += 1          # right child
            if arr[root] >= arr[child]:
                break
            arr[root], arr[child] = arr[child], arr[root]
            root = child
            child = root * 2 + 1    # left child

if __name__ == "__main__":
    main()
