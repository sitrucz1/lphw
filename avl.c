/* AVL Tree Implementation */

#define  QSIZE 50
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

struct avlnode {
    int m_key;
    char m_height;
    struct avlnode *m_left;
    struct avlnode *m_right;
};

struct avltree {
    struct avlnode *m_root;
    int m_cnt;
};

struct avlnode *initavlnode(int);
struct avltree *initavltree();
struct avlnode *avltreeput(struct avltree *, int);
struct avlnode *avltreeputn(struct avltree *, struct avlnode *, int);
void freeavltree(struct avltree *);
void freeavlnode(struct avlnode *);
int max(int a, int b);
char getbalance(struct avlnode *n);
char getheight(struct avlnode *n);
void setheight(struct avlnode *n);
struct avlnode *balance(struct avlnode *n);
struct avlnode *rotateleft(struct avlnode *n);
struct avlnode *rotateright(struct avlnode *n);
int avltreeisvalid(struct avltree *);
int avltreeisvalidn(struct avlnode *);
void avltreeprint(struct avltree *);
void preorder(struct avlnode *);
void inorder(struct avlnode *);
void postorder(struct avlnode *);
struct avlnode *avlremovemin(struct avltree *t);
struct avlnode *avlremoveminn(struct avltree *t, struct avlnode *n);
struct avlnode *avlremovemax(struct avltree *t);
struct avlnode *avlremovemaxn(struct avltree *t, struct avlnode *n);
struct avlnode *avltreeremove(struct avltree *, int);
struct avlnode *avltreeremoven(struct avltree *, struct avlnode *, int);

int main(int agrc, char *argv[])
{
    struct avltree *t = initavltree();
    srand(time(0));
    for (int i=0; i<30; i++) {
        avltreeput(t, rand() % 100 +1);
        if (!avltreeisvalid(t))
            break;
    }
    /* postorder(t->m_root); */
    /* printf("\n"); */
    avltreeprint(t);
    printf("%d\n", avltreeisvalid(t));
    while (t->m_cnt && avltreeisvalid(t)) {
        /* avltreeremove(t, t->m_root->m_key); */
        avlremovemin(t);
        /* avlremovemax(t); */
        avltreeprint(t);
    }
    printf("%d\n", avltreeisvalid(t));
    freeavltree(t);
    return 0;
}

struct avlnode *initavlnode(int key)
{
    struct avlnode *n = (struct avlnode *) malloc(sizeof(struct avlnode));
    if (n != NULL) {
        n->m_key = key;
        n->m_height = 1;
        n->m_left = n->m_right = NULL;
    }
    return n;
}

struct avltree *initavltree()
{
    struct avltree *t = (struct avltree *) malloc(sizeof(struct avltree));
    if (t) {
        t->m_root = NULL;
        t->m_cnt = 0;
    }
    return t;
}

void freeavltree(struct avltree *t)
{
    freeavlnode(t->m_root);
    free(t);
}

void freeavlnode(struct avlnode *n)
{
    if (n == NULL)
        return;
    freeavlnode(n->m_left);
    freeavlnode(n->m_right);
    free(n);
}

int avltreeisvalid(struct avltree *t)
{
    return avltreeisvalidn(t->m_root) != -1;
}

int avltreeisvalidn(struct avlnode *n)
{
    if (n == NULL)
        return 0;
    if ((n->m_left != NULL && n->m_left->m_key > n->m_key) || (n->m_right != NULL && n->m_right->m_key < n->m_key)) {
        printf("ERROR => not a BST.  %d\n", n->m_key);
        return -1;
    }
    int lh, rh;
    lh = avltreeisvalidn(n->m_left);
    rh = avltreeisvalidn(n->m_right);
    if (lh == -1 || rh == -1)
        return -1;
    if (abs(getbalance(n)) > 1) {
        printf("ERROR => balance is out or range -1..1.  %d\n", n->m_key);
        return -1;
    }
    if (getheight(n) != 1 + max(lh, rh)) {
        printf("ERROR => heights don't match.  %d\n", n->m_key);
        return -1;
    }
    return 1 + max(lh, rh);
}

void preorder(struct avlnode *n)
{
    if (n == NULL)
        return;
    printf("%d,%d ", n->m_key, n->m_height);
    preorder(n->m_left);
    preorder(n->m_right);
}

void inorder(struct avlnode *n)
{
    if (n == NULL)
        return;
    inorder(n->m_left);
    printf("%d,%d ", n->m_key, n->m_height);
    inorder(n->m_right);
}

void postorder(struct avlnode *n)
{
    if (n == NULL)
        return;
    postorder(n->m_left);
    postorder(n->m_right);
    printf("%d,%d ", n->m_key, n->m_height);
}

void avltreeprint(struct avltree *t)
{
    int qc = 0, qh = -1, qt = -1;
    struct avlnode *qq[QSIZE];
    if (t->m_root == NULL)
        return;
    qq[++qh % QSIZE] = t->m_root; qc++;
    while (qc > 0) {
        int lcnt = qc;
        while (lcnt > 0) {
            struct avlnode *n = qq[++qt % QSIZE]; qc--;
            if (n != NULL) {
                printf("%d,%d  ", n->m_key, getheight(n));
                qq[++qh % QSIZE] = n->m_left; qc++;
                qq[++qh % QSIZE] = n->m_right; qc++;
            }
            else
                printf("*,*  ");
            lcnt--;
        }
        printf("\n");
    }
}

int max(int a, int b)
{
    return (a > b ? a : b);
}

char getbalance(struct avlnode *n)
{
    return (getheight(n->m_right) - getheight(n->m_left));
}

char getheight(struct avlnode *n)
{
    return (n == NULL ? 0 : n->m_height);
}

void setheight(struct avlnode *n)
{
    n->m_height = 1 + max(getheight(n->m_left), getheight(n->m_right));
}

struct avlnode *balance(struct avlnode *n)
{
    char bal = getbalance(n);
    if (bal == -2) {
        if (getbalance(n->m_left) == 1)
            n->m_left = rotateleft(n->m_left);
        n = rotateright(n);
    }
    else if (bal == 2) {
        if (getbalance(n->m_right) == -1)
            n->m_right = rotateright(n->m_right);
        n = rotateleft(n);
    }
    else
        setheight(n);
    return n;
}

struct avlnode *rotateright(struct avlnode *n)
{
    printf("Rotate right. %d\n", n->m_key);
    struct avlnode *t = n->m_left;
    n->m_left = t->m_right;
    t->m_right = n;
    setheight(n);
    setheight(t);
    return t;
}

struct avlnode *rotateleft(struct avlnode *n)
{
    printf("Rotate left. %d\n", n->m_key);
    struct avlnode *t = n->m_right;
    n->m_right = t->m_left;
    t->m_left = n;
    setheight(n);
    setheight(t);
    return t;
}

struct avlnode *avltreeput(struct avltree *t, int key)
{
    printf("** Inserting => %d\n", key);
    t->m_root = avltreeputn(t, t->m_root, key);
    return t->m_root;
}

struct avlnode *avltreeputn(struct avltree *t, struct avlnode *n, int key)
{
    if (n == NULL) {
        n = initavlnode(key);
        if (n != NULL)
            t->m_cnt++;
        return n;
    }
    if (key == n->m_key)
        return n;
    if (key < n->m_key)
        n->m_left = avltreeputn(t, n->m_left, key);
    else
        n->m_right = avltreeputn(t, n->m_right, key);
    return balance(n);
}

struct avlnode *avlremovemin(struct avltree *t)
{
    printf("** Removing min\n");
    if (t->m_root == NULL)
        return NULL;
    t->m_root = avlremoveminn(t, t->m_root);
    return NULL;
}

struct avlnode *avlremoveminn(struct avltree *t, struct avlnode *n)
{
    if (n->m_left == NULL) {
        struct avlnode *q = n->m_right;
        t->m_cnt--;
        free(n);
        return q;
    }
    n->m_left = avlremoveminn(t, n->m_left);
    return balance(n);
}

struct avlnode *avlremovemax(struct avltree *t)
{
    printf("** Removing max\n");
    if (t->m_root == NULL)
        return NULL;
    t->m_root = avlremovemaxn(t, t->m_root);
    return NULL;
}

struct avlnode *avlremovemaxn(struct avltree *t, struct avlnode *n)
{
    if (n->m_right == NULL) {
        struct avlnode *q = n->m_left;
        t->m_cnt--;
        free(n);
        return q;
    }
    n->m_right = avlremovemaxn(t, n->m_right);
    return balance(n);
}

struct avlnode *avltreeremove(struct avltree *t, int key)
{
    printf("** Removing => %d\n", key);
    t->m_root = avltreeremoven(t, t->m_root, key);
    return NULL;
}

struct avlnode *avltreeremoven(struct avltree *t, struct avlnode *n, int key)
{
    if (n == NULL)
        return n; // not found
    if (key < n->m_key)
        n->m_left = avltreeremoven(t, n->m_left, key);
    else if (key > n->m_key)
        n->m_right = avltreeremoven(t, n->m_right, key);
    else {
        if (n->m_left != NULL && n->m_right != NULL) {
            struct avlnode *s = n->m_right;
            while (s->m_left != NULL)
                s = s->m_left;
            n->m_key = s->m_key;
            n->m_right = avltreeremoven(t, n->m_right, s->m_key);
        }
        else {
            struct avlnode *q = n;
            if (n->m_left == NULL)
                n = n->m_right;
            else
                n = n->m_left;
            free(q);
            t->m_cnt--;
            return n;
        }
    }
    return balance(n);
}
