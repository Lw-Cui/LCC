#include <stdio.h>
#include <pwd.h>
#include <time.h>
#include <grp.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include "utility.h"

void traverse(const char *path, void (*callback)(struct dirent *dir), void (*dirProc)(const char *dir)) {
    DIR *pDir = opendir(path);
    struct dirent *entry = NULL;
    while ((entry = readdir(pDir)) != 0) {
        if (entry->d_type == DT_DIR && dirProc)
            dirProc(entry->d_name);
        else if (callback)
            callback(entry);
    }
    closedir(pDir);
}

char *Month[] = {"Mon", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"};

char parseType(unsigned char type) {
    switch (type) {
        case DT_REG:
            return '-';
        case DT_DIR:
            return 'd';
        case DT_LNK:
            return 'l';
        case DT_FIFO:
            return 'p';
        case DT_CHR:
            return 'c';
        case DT_SOCK:
            return 's';
        case DT_BLK:
            return 'b';
        case DT_UNKNOWN:
        default:
            return '?';
    }
}

char *parseMode(mode_t mode, char st[]) {
    int count = 0;
    st[count++] = (char) (mode & S_IRUSR ? 'r' : '-');
    st[count++] = (char) (mode & S_IWUSR ? 'w' : '-');
    st[count++] = (char) (mode & S_IXUSR ? 'x' : '-');
    st[count++] = (char) (mode & S_IRGRP ? 'r' : '-');
    st[count++] = (char) (mode & S_IWGRP ? 'w' : '-');
    st[count++] = (char) (mode & S_IXGRP ? 'x' : '-');
    st[count++] = (char) (mode & S_IROTH ? 'r' : '-');
    st[count++] = (char) (mode & S_IWOTH ? 'w' : '-');
    st[count++] = (char) (mode & S_IXOTH ? 'x' : '-');
    return st;
}



