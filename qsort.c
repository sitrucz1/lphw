#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>

#define FALSE 0
#define TRUE !FALSE
#define MAX 20

void swap(int *, int, int);
int issorted(int *, int);
void quicksort(int *, int, int);
void quicksortlom(int *, int, int);

int main(int argc, char **argv)
{
    int *a = NULL;

    if ((a = (int *) malloc(MAX * sizeof(int))) == NULL) {
        printf("Array could not be allocated.");
        exit(1);
    }

    srand(time(NULL));
    for (int i = 0; i < MAX; i++) {
        int j = rand()%100+1;
        printf("%d ", (a[i] = j));
    }
    printf("\n");

    quicksort(a, 0, MAX-1);
    /* quicksortlom(a, 0, MAX-1); */
    assert(issorted(a, MAX));

    for (int i = 0; i < MAX; i++)
        printf("%d ", a[i]);
    printf("\n");
    printf("%d\n", issorted(a, MAX));
    free(a);
    a = NULL;
}

void quicksort(int *a, int l, int r)
{
    if (l >= r)
        return;
    swap(a, l, l+(r-l)/2);
    int i = l, j = r+1, p = a[l];
    printf("%d %d %d\n", l, r, p);
    while (TRUE) {
        while (a[++i] < p && i < r);
        assert(i <= r);
        while (p < a[--j]);
        assert(j >= l);
        if (i >= j)
            break;
        printf(" %d %d\n", i, j);
        swap(a, i, j);
    }
    swap(a, l, j);
    printf("  %d %d\n", j, i);
    quicksort(a, l, j-1);
    quicksort(a, j+1, r);
}

void quicksortlom(int *a, int l, int r)
{
    if (l >= r)
        return;
    swap(a, l, l+(r-l)/2);
    int j = l, p = a[l];
    for (int i = l+1; i <= r; i++)
        if (a[i] < p)
            swap(a, ++j, i);
    swap(a, l, j);
    quicksortlom(a, l, j-1);
    quicksortlom(a, j+1, r);
}

int issorted(int *a, int n)
{
    for (int i = 1; i < n; i++)
        if (a[i] < a[i-1])
            return FALSE;
    return TRUE;
}

void swap(int *a, int i, int j)
{
    int t = a[i];
    a[i] = a[j];
    a[j] = t;
}
