#ifndef VECTOR_H
#define VECTOR_H

typedef struct {
    void **body;
    int len;
    int capacity;
} Vector;

int size(Vector *vec);

void *back(Vector *vec);

void push_back(Vector *vec, void *ptr);

Vector *make_vector();

void **get_array(Vector *vec);

char *c_str(Vector *vec);

void *at(Vector *vec, int i);

void clear(Vector *vec);

void del_vec(Vector *vec);

typedef struct String {
    Vector *impl;
} String;

int len(String *);

char *str(String *);

String *make_string(char *);

String *sprint(char *fmt, ...);

String *merge_string(String *s1, String *s2);

void append_string(String *s1, String *s2);

void append_char(String *s1, char s2);

char string_pos(String *, int pos);

typedef struct List_node {
    struct List_node *prev, *next;
    void *body;
} List_node;

List_node *make_list(List_node *prev, void *body, List_node *next);


#endif
