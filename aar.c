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
    struct aanode *m_nil;
    int m_cnt;
};
     
struct aanode *initaanode(int, struct aanode *);
struct aatree *initaatree();

int main(int agrc, char *argv[])
{
    struct aatree *t = initaatree();
    struct aanode *n = initaanode(5, t->m_nil);
    printf("%d %d\n", n->m_key, n->m_level);
    free(n);
    free(t);
    return 0;
}

struct aanode *initaanode(int key, struct aanode *nil)
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
        t->m_nil = initaanode(0, 0);
        if (t->m_nil) {
            t->m_nil->m_level = 0;
            t->m_nil->m_left = t->m_nil->m_right = t->m_nil;
        }
        t->m_root = t->m_nil;
        t->m_cnt = 0;
    }
    return t;
}

struct aanode * aatreeput(
