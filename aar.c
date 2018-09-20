/* AA Tree Implementation */

#define  QSIZE 50
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

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
struct aanode *aatreeputn(struct aatree *, struct aanode *, int);
void freeaatree(struct aatree *);
void freeaanode(struct aanode *);
struct aanode *aaskew(struct aanode *);
struct aanode *aasplit(struct aanode *);
int aatreeisvalid(struct aatree *);
int aatreeisvalidn(struct aanode *, int);
void aatreeprint(struct aatree *);
void preorder(struct aanode *);
void inorder(struct aanode *);
void postorder(struct aanode *);
struct aanode *aatreeremove(struct aatree *, int);
struct aanode *aatreeremoven(struct aatree *, struct aanode *, int);

struct aanode s_nil = { 0, 0, &s_nil, &s_nil };
struct aanode *nil = &s_nil;

int main(int agrc, char *argv[])
{
    struct aatree *t = initaatree();
    srand(time(0));
    for (int i=0; i<30; i++) {
        aatreeput(t, rand() % 100 +1);
    }
    /* postorder(t->m_root); */
    /* printf("\n"); */
    aatreeprint(t);
    printf("%d\n", aatreeisvalid(t));
    while (t->m_cnt && aatreeisvalid(t)) {
        aatreeremove(t, t->m_root->m_key);
        aatreeprint(t);
    }
    printf("%d\n", aatreeisvalid(t));
    freeaatree(t);
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

void freeaatree(struct aatree *t)
{
    freeaanode(t->m_root);
    free(t);
}

void freeaanode(struct aanode *n)
{
    if (n == nil)
        return;
    freeaanode(n->m_left);
    freeaanode(n->m_right);
    free(n);
}

int aatreeisvalid(struct aatree *t)
{
    return aatreeisvalidn(t->m_root, 0) != -1;
}

int aatreeisvalidn(struct aanode *n, int plevel)
{
    if (n == nil)
        return 0;
    if ((n->m_left != nil && n->m_left->m_key > n->m_key) || (n->m_right != nil && n->m_right->m_key < n->m_key)) {
        printf("ERROR => not a BST.  %d\n", n->m_key);
        return -1;
    }
    if (n->m_level <= 0) {
        printf("ERROR => node level must be > 0.  %d\n", n->m_key);
        return -1;
    }
    if (n->m_left->m_level != n->m_level-1) {
        printf("ERROR => left child level must be < parent.  %d\n", n->m_key);
        return -1;
    }
    if (n->m_right->m_level != n->m_level && n->m_right->m_level != n->m_level-1) {
        printf("ERROR => right child level but be equal or one less than parent.  %d\n", n->m_key);
        return -1;
    }
    if (n->m_right->m_right->m_level >= n->m_level) {
        printf("ERROR => right grandchild level must be less than grandparent.  %d\n", n->m_key);
        return -1;
    }
    int lh, rh;
    lh = aatreeisvalidn(n->m_left, n->m_level);
    rh = aatreeisvalidn(n->m_right, n->m_level);
    if (lh == -1 || rh == -1)
        return -1;
    if (lh != rh) {
        printf("ERROR => heights don't match.  %d\n", n->m_key);
        return -1;
    }
    if (n->m_level != plevel)
        return lh+1;
    return lh;
}

void preorder(struct aanode *n)
{
    if (n == nil)
        return;
    printf("%d,%d ", n->m_key, n->m_level);
    preorder(n->m_left);
    preorder(n->m_right);
}

void inorder(struct aanode *n)
{
    if (n == nil)
        return;
    inorder(n->m_left);
    printf("%d,%d ", n->m_key, n->m_level);
    inorder(n->m_right);
}

void postorder(struct aanode *n)
{
    if (n == nil)
        return;
    postorder(n->m_left);
    postorder(n->m_right);
    printf("%d,%d ", n->m_key, n->m_level);
}

void aatreeprint(struct aatree *t)
{
    int qc = 0, qh = -1, qt = -1;
    struct aanode *qq[QSIZE];
    if (t->m_root == nil)
        return;
    qq[++qh % QSIZE] = t->m_root; qc++;
    while (qc) {
        int lcnt = qc;
        while (lcnt) {
            struct aanode *n = qq[++qt % QSIZE]; qc--;
            printf("%d", n->m_key);
            if (n->m_right->m_level == n->m_level)
                printf(",%d", n->m_right->m_key);
            printf("  ");
            if (n->m_left != nil) {
                qq[++qh % QSIZE] = n->m_left; qc++;

            }
            if (n->m_right->m_level == n->m_level) {
                struct aanode *tmp = n->m_right;
                if (tmp->m_left != nil) {
                    qq[++qh % QSIZE] = tmp->m_left; qc++;

                }
                if (tmp->m_right != nil) {
                    qq[++qh % QSIZE] = tmp->m_right; qc++;
                }
            }
            else {
                if (n->m_right != nil) {
                    qq[++qh % QSIZE] = n->m_right; qc++;
                }
            }
            lcnt--;
        }
        printf("\n");
    }
}

struct aanode *aaskew(struct aanode *n)
{
    if (n->m_level == n->m_left->m_level) {
        printf("Case 1 - skew. %d\n", n->m_key);
        struct aanode *t = n;
        n = n->m_left;
        t->m_left = n->m_right;
        n->m_right = t;
    }
    return n;
}

struct aanode *aasplit(struct aanode *n)
{
    if (n->m_level == n->m_right->m_right->m_level) {
        printf("Case 2 - split. %d\n", n->m_key);
        struct aanode *t = n;
        n = n->m_right;
        t->m_right = n->m_left;
        n->m_left = t;
        n->m_level++;
    }
    return n;
}

struct aanode *aatreeput(struct aatree *t, int key)
{
    printf("** Inserting => %d\n", key);
    t->m_root = aatreeputn(t, t->m_root, key);
    return t->m_root;
}

struct aanode *aatreeputn(struct aatree *t, struct aanode *n, int key)
{
    if (n == nil) {
        n = initaanode(key);
        if (n)
            t->m_cnt++;
        return n;
    }
    if (key == n->m_key)
        return n;
    if (key < n->m_key)
        n->m_left = aatreeputn(t, n->m_left, key);
    else
        n->m_right = aatreeputn(t, n->m_right, key);
    // fixup
    n = aaskew(n);
    n = aasplit(n);
    return n;
}

struct aanode *aatreeremove(struct aatree *t, int key)
{
    printf("** Removing => %d\n", key);
    t->m_root = aatreeremoven(t, t->m_root, key);
    return nil;
}

struct aanode *aatreeremoven(struct aatree *t, struct aanode *n, int key)
{
    if (n == nil)
        return n; // not found
    if (key < n->m_key)
        n->m_left = aatreeremoven(t, n->m_left, key);
    else if (key > n->m_key)
        n->m_right = aatreeremoven(t, n->m_right, key);
    else {
        if (n->m_left != nil && n->m_right != nil) {
            struct aanode *s = n->m_right;
            while (s->m_left != nil)
                s = s->m_left;
            n->m_key = s->m_key;
            n->m_right = aatreeremoven(t, n->m_right, s->m_key);
        }
        else {
            struct aanode *q = n;
            if (n->m_left == nil)
                n = n->m_right;
            else
                n = n->m_left;
            free(q);
            t->m_cnt--;
        }
    }
    // fixup
    if (n->m_left->m_level < n->m_level-1 || n->m_right->m_level < n->m_level-1) {
        n->m_level--;
        if (n->m_right->m_level > n->m_level)
            n->m_right->m_level = n->m_level;
        n = aaskew(n);
        n->m_right = aaskew(n->m_right);
        n->m_right->m_right = aaskew(n->m_right->m_right);
        n = aasplit(n);
        n->m_right = aasplit(n->m_right);
    }
    return n;
}
