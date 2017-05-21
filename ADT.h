#ifndef VECTOR_H
#define VECTOR_H

typedef struct {
    void **body;
    int len;
    int capacity;
} Vector;


void push_back(Vector *vec, void *ptr);

Vector *make_vector();

void **get_array(Vector *vec);

char *c_str(Vector *vec);

void *at(Vector *vec, int i);

void clear(Vector *vec);

void del_vec(Vector *vec);

typedef struct {
    Vector *impl;
} String;

String *make_string(char *);

char *str(String *);

#endif
