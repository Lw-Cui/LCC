int main(int count) {
    int v1 = 6 + 1 * count; // v1 = 7
    int v2 = v1 - 5;        // v2 = 2
    int v3 = 0;
    v3 = v1 + 8 / v2;       // v3 = 11
    int v4 = v3 >> 2;       //
    v4 = v4 << 1;           // v4 = 4
    int v5 = v1 <= 7;
    {
        if (v4 < 0)
            v5 = v5 + 1;    // v5 = 1
        int tmp = 0;
    }
    if (v4 != 4) {
        return v4 + 3;       // 7
    } else {
        while (v4 != 0) {
            v5 = v5 + 2;
            v4 = v4 - 1;
        }
        if (v5 == 9)
            return v4 + 3 + v5;// 12
        else return 0;
    }
}

