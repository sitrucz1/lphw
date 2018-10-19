/* LLRB Tree Implementation */

#define  QSIZE  50
#define  BLACK  0
#define  RED    1
#define  BOOL   char
#define  TRUE   1
#define  FALSE  0

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

struct rbnode {
    int m_key;
    BOOL m_color;
    struct rbnode *m_left;
    struct rbnode *m_right;
};

struct rbtree {
    struct rbnode *m_root;
    int m_cnt;
};

struct rbnode *initrbnode(int);
struct rbtree *initrbtree();
struct rbnode *rbtreeput(struct rbtree *, int);
struct rbnode *rbtreeputn(struct rbtree *, struct rbnode *, int);
void freerbtree(struct rbtree *);
void freerbnode(struct rbnode *);
int rbtreeisvalid(struct rbtree *);
int rbtreeisvalidn(struct rbnode *);
BOOL isred(struct rbnode *n);
void colorflip(struct rbnode *n);
struct rbnode *rotateright(struct rbnode *n);
struct rbnode *rotateleft(struct rbnode *n);
struct rbnode *rbsucc(struct rbnode *n);
struct rbnode *rbmoveredleft(struct rbnode *n);
struct rbnode *rbmoveredright(struct rbnode *n);
void rbtreeprint(struct rbtree *);
void preorder(struct rbnode *);
void inorder(struct rbnode *);
void postorder(struct rbnode *);
struct rbnode *rbbalance(struct rbnode *n);
struct rbnode *rbtreedeletemax(struct rbtree *t);
struct rbnode *rbtreedeletemaxn(struct rbtree *t, struct rbnode *n);
struct rbnode *rbtreedeletemin(struct rbtree *t);
struct rbnode *rbtreedeleteminn(struct rbtree *t, struct rbnode *n);
struct rbnode *rbtreedelete(struct rbtree *, int);
struct rbnode *rbtreedeleten(struct rbtree *, struct rbnode *, int);
struct rbnode *rbget(struct rbtree *, int);
struct rbnode *rbgetn(struct rbnode *, int);

int main(int agrc, char *argv[])
{
    struct rbtree *t = initrbtree();
    srand(time(0));
    for (int i=0; i<20; i++) {
        rbtreeput(t, rand() % 100 +1);
        rbtreeprint(t);
        if (!rbtreeisvalid(t))
            break;
    }
    /* postorder(t->m_root); */
    /* printf("\n"); */
    /* rbtreeprint(t); */
    printf("%d\n", rbtreeisvalid(t));
    struct rbnode *n = NULL;
    n = rbget(t, t->m_root->m_key);
    printf("%d\n", n->m_key);
    n = rbget(t, 500);
    if (n != NULL) printf("%d\n", n->m_key);
    n = rbget(t, rand() % 100 +1);
    if (n != NULL) printf("%d\n", n->m_key);
    while (t->m_cnt > 0 && rbtreeisvalid(t)) {
        rbtreedeletemin(t);
        /* rbtreedelete(t, t->m_root->m_key); */
        rbtreeprint(t);
    }
    printf("%d\n", rbtreeisvalid(t));
    freerbtree(t);
    return 0;
}

struct rbnode *initrbnode(int key)
{
    struct rbnode *n = (struct rbnode *) malloc(sizeof(struct rbnode));
    if (n != NULL) {
        n->m_key = key;
        n->m_color = RED;
        n->m_left = n->m_right = NULL;
    }
    return n;
}

struct rbtree *initrbtree()
{
    struct rbtree *t = (struct rbtree *) malloc(sizeof(struct rbtree));
    if (t != NULL) {
        t->m_root = NULL;
        t->m_cnt = 0;
    }
    return t;
}

void freerbtree(struct rbtree *t)
{
    freerbnode(t->m_root);
    free(t);
}

void freerbnode(struct rbnode *n)
{
    if (n == NULL)
        return;
    freerbnode(n->m_left);
    freerbnode(n->m_right);
    free(n);
}

int rbtreeisvalid(struct rbtree *t)
{
    if (isred(t->m_root)) {
        printf("ERROR => Root is red.  %d\n", t->m_root->m_key);
        return FALSE;
    }
    else
        return (rbtreeisvalidn(t->m_root) != -1);
}

int rbtreeisvalidn(struct rbnode *n)
{
    if (n == NULL)
        return 0;
    else if ((n->m_left != NULL && n->m_left->m_key > n->m_key) || (n->m_right != NULL && n->m_right->m_key < n->m_key)) {
        printf("ERROR => not a BST.  %d\n", n->m_key);
        return -1;
    }
    else if (isred(n->m_right)) {
        printf("ERROR => right leaning red node.  %d\n", n->m_key);
        return -1;
    }
    else if (isred(n) && isred(n->m_left)) {
        printf("ERROR => two red nodes.  %d\n", n->m_key);
        return -1;
    }
    else {
        int lh, rh;
        lh = rbtreeisvalidn(n->m_left);
        rh = rbtreeisvalidn(n->m_right);
        if (lh == -1 || rh == -1)
            return -1;
        else if (lh != rh) {
            printf("ERROR => heights don't match.  %d\n", n->m_key);
            return -1;
        }
        else if (isred(n))
            return lh;
        else
            return lh+1;
    }
}

BOOL isred(struct rbnode *n)
{
    return (n != NULL && n->m_color == RED);
}

void colorflip(struct rbnode *n)
{
    printf("Colorflip %d\n", n->m_key);
    n->m_color = !n->m_color;
    n->m_left->m_color = !n->m_left->m_color;
    n->m_right->m_color = !n->m_right->m_color;
}

struct rbnode *rotateright(struct rbnode *n)
{
    printf("Rotate Right %d\n", n->m_key);
    struct rbnode *t = n->m_left;
    n->m_left = t->m_right;
    t->m_right = n;
    t->m_color = n->m_color;
    n->m_color = RED;
    return t;
}

struct rbnode *rotateleft(struct rbnode *n)
{
    printf("Rotate Left %d\n", n->m_key);
    struct rbnode *t = n->m_right;
    n->m_right = t->m_left;
    t->m_left = n;
    t->m_color = n->m_color;
    n->m_color = RED;
    return t;
}

struct rbnode *rbsucc(struct rbnode *n)
{
    struct rbnode *s = n->m_right;
    while (s->m_left != NULL)
        s = s->m_left;
    return s;
}

void preorder(struct rbnode *n)
{
    if (n == NULL)
        return;
    printf("%d", n->m_key);
    preorder(n->m_left);
    preorder(n->m_right);
}

void inorder(struct rbnode *n)
{
    if (n == NULL)
        return;
    inorder(n->m_left);
    printf("%d", n->m_key);
    inorder(n->m_right);
}

void postorder(struct rbnode *n)
{
    if (n == NULL)
        return;
    postorder(n->m_left);
    postorder(n->m_right);
    printf("%d", n->m_key);
}

void rbtreeprint(struct rbtree *t)
{
    int qc = 0, qh = -1, qt = -1; // queue
    struct rbnode *qq[QSIZE];
    if (t->m_root == NULL)
        return;
    qq[++qh % QSIZE] = t->m_root; qc++;
    while (qc > 0) {
        int lcnt = qc;
        while (lcnt > 0) {
            struct rbnode *n = qq[++qt % QSIZE]; qc--;
            if (isred(n->m_left)) {
                struct rbnode *tmp = n->m_left;
                if (tmp->m_left != NULL) {
                    qq[++qh % QSIZE] = tmp->m_left; qc++;
                }
                if (tmp->m_right != NULL) {
                    qq[++qh % QSIZE] = tmp->m_right; qc++;
                }
                printf("%d,", n->m_left->m_key);
            }
            else {
                if (n->m_left != NULL) {
                    qq[++qh % QSIZE] = n->m_left; qc++;
                }
                printf("*,");
            }
            printf("%d,*  ", n->m_key);
            if (n->m_right != NULL) {
                qq[++qh % QSIZE] = n->m_right; qc++;
            }
            lcnt--;
        }
        printf("\n");
    }
}

struct rbnode *rbget(struct rbtree *t, int key)
{
    printf("** Get => %d.\n", key);
    return rbgetn(t->m_root, key);
}

struct rbnode *rbgetn(struct rbnode *n, int key)
{
    while (n != NULL && key != n->m_key) {
        if (key < n->m_key)
            n = n->m_left;
        else
            n = n->m_right;
    }
    return n;
}

struct rbnode *rbtreeput(struct rbtree *t, int key)
{
    printf("** Inserting => %d\n", key);
    t->m_root = rbtreeputn(t, t->m_root, key);
    if (t->m_root != NULL) // node insert may fail
        t->m_root->m_color = BLACK;
    return t->m_root;
}

struct rbnode *rbtreeputn(struct rbtree *t, struct rbnode *n, int key)
{
    if (n == NULL) {
        n = initrbnode(key);
        if (n != NULL)
            t->m_cnt++;
        return n;
    }
    else if (key == n->m_key)
        n->m_key = key;
    else if (key < n->m_key)
        n->m_left = rbtreeputn(t, n->m_left, key);
    else
        n->m_right = rbtreeputn(t, n->m_right, key);
    return rbbalance(n);
}

struct rbnode *rbbalance(struct rbnode *n)
{
    printf("Balance\n");
    if (isred(n->m_right) && !isred(n->m_left))
        n = rotateleft(n);
    if (isred(n->m_left) && isred(n->m_left->m_left))
        n = rotateright(n);
    if (isred(n->m_left) && isred(n->m_right))
        colorflip(n);
    return n;
}

struct rbnode *rbmoveredleft(struct rbnode *n)
{
    printf("Move red left %d\n", n->m_key);
    colorflip(n);
    if (isred(n->m_right->m_left)) {
        n->m_right = rotateright(n->m_right);
        n = rotateleft(n);
        colorflip(n);
    }
    return n;
}

struct rbnode *rbmoveredright(struct rbnode *n)
{
    printf("Move red right %d\n", n->m_key);
    colorflip(n);
    if (isred(n->m_left->m_left)) {
        n = rotateright(n);
        colorflip(n);
    }
    return n;
}

struct rbnode *rbtreedeletemax(struct rbtree *t)
{
    printf("** Delete MAX.\n");
    if (t->m_root == NULL)
        return NULL;
    if (!isred(t->m_root->m_left) && !isred(t->m_root->m_right))
        t->m_root->m_color = RED;
    t->m_root = rbtreedeletemaxn(t, t->m_root);
    if (t->m_root != NULL)
        t->m_root->m_color = BLACK;
    return NULL;
}

struct rbnode *rbtreedeletemaxn(struct rbtree *t, struct rbnode *n)
{
    if (isred(n->m_left))
        n = rotateright(n);
    if (n->m_right == NULL) {
        printf("Deleted %d\n", n->m_key);
        free(n);
        t->m_cnt--;
        return NULL;
    }
    if (!isred(n->m_right) && !isred(n->m_right->m_left))
        n = rbmoveredright(n);
    n->m_right = rbtreedeletemaxn(t, n->m_right);
    return rbbalance(n);
}

struct rbnode *rbtreedeletemin(struct rbtree *t)
{
    printf("** Delete MIN.\n");
    if (t->m_root == NULL)
        return NULL;
    if (!isred(t->m_root->m_left) && !isred(t->m_root->m_right))
        t->m_root->m_color = RED;
    t->m_root = rbtreedeleteminn(t, t->m_root);
    if (t->m_root != NULL)
        t->m_root->m_color = BLACK;
    return NULL;
}

struct rbnode *rbtreedeleteminn(struct rbtree *t, struct rbnode *n)
{
    if (n->m_left == NULL) {
        printf("Deleted %d\n", n->m_key);
        free(n);
        t->m_cnt--;
        return NULL;
    }
    if (!isred(n->m_left) && !isred(n->m_left->m_left))
        n = rbmoveredleft(n);
    n->m_left = rbtreedeleteminn(t, n->m_left);
    return rbbalance(n);
}

struct rbnode *rbtreedelete(struct rbtree *t, int key)
{
    printf("** Deleting => %d\n", key);
    if (rbget(t, key) == NULL) {
        printf("Key not found %d.", key);
        return NULL;
    }
    if (!isred(t->m_root->m_left) && !isred(t->m_root->m_right))
        t->m_root->m_color = RED;
    t->m_root = rbtreedeleten(t, t->m_root, key);
    if (t->m_root != NULL)
        t->m_root->m_color = BLACK;
    return NULL;
}

struct rbnode *rbtreedeleten(struct rbtree *t, struct rbnode *n, int key)
{
    if (key < n->m_key) {
        if (!isred(n->m_left) && !isred(n->m_left->m_left))
            rbmoveredleft(n);
        n->m_left = rbtreedeleten(t, n->m_left, key);
    }
    else {
        if (isred(n->m_left))
            n = rotateright(n);
        if (key == n->m_key && n->m_right == NULL) {
            printf("Deleted %d\n", n->m_key);
            free(n);
            t->m_cnt--;
            return NULL;
        }
        if (!isred(n->m_right) && !isred(n->m_right->m_left))
            n = rbmoveredright(n);
        if (key == n->m_key) {
            struct rbnode *s = rbsucc(n);
            printf("Delete successor %d\n", s->m_key);
            n->m_key = s->m_key;
            n->m_right = rbtreedeleteminn(t, n->m_right);
        }
        else
            n->m_right = rbtreedeleten(t, n->m_right, key);
    }
    return rbbalance(n);
}
