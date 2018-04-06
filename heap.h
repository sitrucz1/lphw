#ifndef __heap_h
#define __heap_h

typedef struct {
    int m_cnt;
    int m_size;
    int *m_arr;
} theap;

theap *heap_init(int);
int  heap_isfull(theap *);
int  heap_isempty(theap *);
void heap_siftdown(theap *, int);
void heap_siftup(theap *, int);
int  heap_push(theap *, int);
int  heap_pop(theap *);
int  heap_length(theap *);
void heap_terminate(theap *);
void heap_heapify(theap *);
void heap_print(theap *);

#endif
