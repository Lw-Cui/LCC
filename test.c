int foo(char a, int b) {
    if (a > b) return a - b;
    else return 1 + foo(b, a);
}

int main(int count) {
    int v1 = 6 + 1 * count; // v1 = 7
    char v2 = v1 - 5;        // v2 = 2
    char v3 = 0;
    v3 = v1 + 8 / v2;       // v3 = 11
    int v4 = v3 >> 2;
    v4 = v4 << 1;
    for (int i = 0; i < 3; i = i + 1)
        v4 = v4 + 1;        // v4 = 7
    for (int i = 3; i >= 0;) {
        i = i - 1;
        v4 = v4 - 1;
    }
    int v5 = v1 <= 7;
    {
        if (v4 < 0)
            v5 = v5 + 1;    // v5 = 1
        int tmp = 0;
    }
    if (v4 == v2) {
        return v4 + 3;       // 7
    } else {
        while (v4 != 0) {
            v5 = v5 + 2;
            v4 = v4 - 1;
        }
        if (v5 == 7)
            return v4 + 3 + v5 + v2 + foo(0, 1);// 14
        else return 0;
    }
}

