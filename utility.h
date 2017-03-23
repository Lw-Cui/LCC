#ifndef LS_H
#define LS_H

void traverse(const char *path, void (*callback)(struct dirent *dir), void (*dirProc)(const char *dir));

char *parseMode(mode_t mode, char st[]);

char parseType(unsigned char type);

extern char *Month[];

#endif
