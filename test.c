int putchar(int);

int diff(char a, int b);

int getV1(int count) {
    return 6 + 1 * count;
}

int minus_one(int v);

int minus(int a, int b) {
    return a - b;
}

long shift_left(long v, char n) {
    return v >> n;
}

long shift_right(long v, char n) {
    return v << n;
}

int main(int argc) {
    int v1 = getV1(argc);           // v1 = 7
    short v2 = minus(v1, 5);        // v2 = 2
    char v3 = 0;
    v3 = v1 + 8 / v2;               // v3 = 11
    long v4 = shift_left(v3, 2);
    v4 = minus_one(shift_right(v4, 1));
    int v5 = v1 <= 7;               // v5 = 1
    {
        if (v4 < 0)
            v5 = v5 + 1;
        int tmp = 0;
    }

    if (v4 == v2) {
        return v4 + 3;              // 7
    } else {
        while (v4 != 0) {
            v5 = v5 + 2;
            v4 = v4 - 1;
        }
        if (v5 == 7) return v4 + 3 + v5 + v2 + diff(0, 1);// 14
        else return 0;
    }
}

int diff(char a, int b) {
    putchar(98);
    if (a > b) return a - b;
    else return 1 + diff(b, a);
}

int minus_one(int v) {
    for (int i = 0; i < 3; i = i + 1)
        v = v + 1;                // v4 = 7
    for (int i = 3; i >= 0;) {
        i = i - 1;
        v = v - 1;
    }
    return v;
}
