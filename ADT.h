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

String *make_string(char *);

char *str(String *);

typedef struct List {
    struct List *prev, *next;
    void *body;
} List;

List *make_list(List *prev, void *body, List *next);


#endif
