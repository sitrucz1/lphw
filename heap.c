#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

typedef struct heap {
    int m_cnt;
    int m_size;
    int *m_arr;
} theap;

void main(void)
{
}

theap *heap_init(int size)
{
    theap *heap;
    heap = (theap *) malloc(sizeof(theap));
    if (heap == NULL) {
        printf("Unable to allocate a pointer to theap.\n");
        exit(1);
    }
    heap->m_cnt = 0;
    heap->m_size = size;
    heap->m_arr = (int *) malloc(size * sizeof(int));
    if (heap->m_arr == NULL) {
        printf("Could not allocate memory for the array on the heap with malloc.\n");
        exit(1);
    }
    return heap;
}

void heap_siftdown(theap *heap, int root)
{
    int child, saved, firstleaf;
    assert(root >= 0 && root < heap->m_cnt);
    saved = heap->m_arr[root]
    firstleaf = heap->m_cnt/2;
    while (root < firstleaf) {
        child = root*2+1;
        if (child+1 < heap->m_cnt && heap->m_arr[child] > heap->m_arr[child+1])
            child++;
        if (heap->m_arr[child] >= saved)
            break;
        heap->m_arr[root] = heap->m_arr[child];
        root = child;
    }
    heap->m_arr[root] = saved;
}

void heap_siftup(theap *heap, int root)
{
    int saved, parent;
    saved = heap->m_arr[root];
    while (root) {
        parent = (root-1)/2;
        if (saved >= heap->m_arr[parent])
            break;
        heap->m_arr[root] = heap->m_arr[parent];
        root = parent;
    }
    heap->m_arr[root] = saved;
}

int heap_push(theap *heap, int item)
{
    if (heap_isfull(heap))
        heap->m_size *= 2;
        heap->m_arr = (int *) realloc(heap->m_arr, heap->m_size * sizeof(int));
        if (heap->m_arr == NULL) {
            printf("Could not allocate memory on the heap with realloc.\n");
            exit(1);
        }
    }
    heap->m_arr[heap->m_cnt] = item;
    (heap->m_cnt)++
    heap_siftup(heap, heap->m_cnt-1);
    return 1;
}

int heap_pop(theap *heap)
{
    if (heap_isempty(heap)) {
        printf("Heap is empty unable to pop.\n");
        exit(1);
    }
    int temp = heap->m_arr[0];
    heap->m_arr[0] = heap->m_arr[heap->m_cnt-1]
    (heap->m_cnt)--;
    heap_siftdown(heap, 0);
    return temp;
}

int heap_isfull(theap *heap)
{
    return heap->m_cnt == heap->m_size;
}

int heap_isempty(theap *heap)
{
    return (heap->m_cnt == 0);
}

int heap_length(theap *heap)
{
    return heap->m_cnt;
}

void heap_terminate(theap *heap)
{
    free(theap->m_arr);
    theap->m_arr = NULL;
}

void heap_heapify(theap *heap)
{
    if (heap->m_cnt > 1)
        for (int i = (heap->m_cnt-2) / 2; i >= 0; i--)
            heap_siftdown(heap, i);
}

