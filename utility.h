#ifndef SHELL_UTILITY_H
#define SHELL_UTILITY_H

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

#endif //SHELL_UTILITY_H
