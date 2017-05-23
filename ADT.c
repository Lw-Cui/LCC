#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include "ADT.h"

static const int MIN_SIZE = 5;

static int roundup(int n) {
    int r = 1;
    while (n > r) r <<= 2;
    return r;
}

static void resize(Vector *vec, int n) {
    vec->capacity = roundup(n);
    void **p = malloc(sizeof(void *) * vec->capacity);
    memcpy(p, vec->body, sizeof(void *) * vec->len);
    free(vec->body);
    vec->body = p;
}

Vector *make_vector() {
    Vector *p = malloc(sizeof(Vector));
    p->len = 0;
    p->capacity = roundup(MIN_SIZE);
    p->body = malloc(sizeof(void *) * p->capacity);
    return p;
}

void push_back(Vector *vec, void *ptr) {
    if (vec->len == vec->capacity - 1) {
        resize(vec, vec->capacity * 2);
    }
    vec->body[vec->len++] = ptr;
}

char *c_str(Vector *vec) {
    char *str = malloc(sizeof(char) * vec->len + 1);
    for (int i = 0; i < vec->len; i++) {
        str[i] = *(char *) vec->body[i];
    }
    str[vec->len] = 0;
    return str;
}

void **get_array(Vector *vec) {
    return vec->body;
}

void *at(Vector *vec, int i) {
    return vec->body[i];
}

void clear(Vector *vec) {
    for (int i = 0; i < vec->len; i++) {
        if (vec->body[i])
            free(vec->body[i]);
    }
    vec->len = 0;
}

void del_vec(Vector *vec) {
    free(vec->body);
    free(vec);
}

String *make_string(char *buf) {
    String *str = malloc(sizeof(String));
    str->impl = make_vector();
    int len = (int) strlen(buf);
    for (int i = 0; i < len; i++) {
        char *p = malloc(sizeof(char));
        *p = buf[i];
        push_back(str->impl, p);
    }
    return str;
}

char *str(String *str) {
    if (str == NULL) return "";
    else return c_str(str->impl);
}

void *back(Vector *vec) {
    return vec->body[size(vec) - 1];
}

int size(Vector *vec) {
    return vec->len;
}

List *make_list(List *prev, void *body, List *next) {
    List *ptr = malloc(sizeof(List));
    ptr->prev = prev;
    if (prev) prev->next = ptr;
    ptr->next = next;
    if (next) next->prev = ptr;
    return ptr;
}
