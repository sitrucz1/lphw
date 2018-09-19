#include <stdio.h>
#include <stdlib.h>
/* AA Tree Implementation */

struct aanode {
    int m_key;
    int m_level;
    struct aanode *m_left;
    struct aanode *m_right;
};

struct aatree {
    struct aanode *m_root;
    int m_cnt;
};
     
struct aanode *initaanode(int);
struct aatree *initaatree();
struct aanode *aatreeput(struct aatree *, int);
struct aanode *aatreeputn(struct aanode *, int);

struct aanode s_nil { 0, 0, &s_nil, &s_nil };
struct aanode *nil = &s_nil;

int main(int agrc, char *argv[])
{
    struct aatree *t = initaatree();
    struct aanode *n = initaanode(5);
    printf("%d %d\n", n->m_key, n->m_level);
    free(n);
    free(t);
    return 0;
}

struct aanode *initaanode(int key)
{
    struct aanode *n = (struct aanode *) malloc(sizeof(struct aanode)); 
    if (n) {
        n->m_key = key;
        n->m_level = 1;
        n->m_left = n->m_right = nil;
    }
    return n;
}

struct aatree *initaatree()
{
    struct aatree *t = (struct aatree *) malloc(sizeof(struct aatree));
    if (t) {
        t->m_root = nil;
        t->m_cnt = 0;
    }
    return t;
}

struct aanode *aatreeput(struct aatree *t, int key)
{
    t->m_root = aatreeputn(t->m_root, key)
    return t->m_root;
}

struct aanode *aatreeputn(struct aanode *n, int key)
{
    if (n == nil)
        return initaanode(key);
    if (key == n->m_key)
        return n;
    if (key < n->m_key)
        n->m_left = aatreeputn(t, n->m_left, key);
    else
        n->m_right = aatreeputn(t, n->m_right, key);
    // fixup here
    return n;
}
