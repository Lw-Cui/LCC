#include <stdlib.h>
#include <memory.h>
#include <stdio.h>
#include <string.h>
#include <zconf.h>
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

List_node *make_list(List_node *prev, void *body, List_node *next) {
    List_node *ptr = malloc(sizeof(List_node));
    ptr->body = body;
    ptr->prev = prev;
    if (prev) prev->next = ptr;
    ptr->next = next;
    if (next) next->prev = ptr;
    return ptr;
}

String * append_string(String *s1, String *s2) {
    for (int i = 0; i < len(s2); i++)
        append_char(s1, string_pos(s2, i));
    return s1;
}

int len(String *ptr) {
    return size(ptr->impl);
}

String * append_char(String *s1, char c) {
    char *p = malloc(sizeof(char));
    *p = c;
    push_back(s1->impl, p);
    return s1;
}

char string_pos(String *ptr, int pos) {
    return *(char *) at(ptr->impl, pos);
}

String *merge_string(String *s1, String *s2) {
    String *tmp = make_string(str(s1));
    append_string(tmp, s2);
    return tmp;
}

String *sprint(char *fmt, ...) {
#define MAXLINE 500
    char buf[MAXLINE];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(buf, MAXLINE, fmt, ap);
    va_end(ap);
    return make_string(buf);
}

void append_list(List_node *p1_beg, List_node *p1_end, List_node *p2_beg, List_node *p2_end) {
    if (p2_beg->next != p2_end) {
        List_node *prev = p1_end->prev;
        prev->next = p2_beg->next;
        p2_beg->next->prev = prev;

        prev = p2_end->prev;
        prev->next = p1_end;
        p1_end->prev = prev;
    }
}

int equal_string(String *s1, String *s2) {
    if (s1 == NULL || s2 == NULL || size(s1->impl) != size(s2->impl)) return 0;
    for (int idx = 0; idx < size(s1->impl); idx++)
        if (*(char *) at(s1->impl, idx) != *(char *) at(s2->impl, idx)) return 0;
    return 1;
}
