int putchar(int);

int print_board(int board[8][8]) {
    for (int i = 0; i < 8; i = i + 1) {
        for (int j = 0; j < 8; j = j + 1) {
            if (board[i][j]) {
                putchar(81);
                putchar(32);
            } else {
                putchar(46);
                putchar(32);
            }
        }
        putchar(10);
    }
    putchar(10);
    putchar(10);
}

int conflict(int board[8][8], int row, int col) {
    for (int i = 0; i < row; i = i + 1) {
        if (board[i][col])
            return 1;
        int delta = row - i;
        if (col - delta >= 0)
            if (board[i][col - delta])
                return 1;
        if (col + delta < 8)
            if (board[i][col + delta])
                return 1;
    }
    return 0;
}

int solve(int board[8][8], int row) {
    if (row == 8) {
        print_board(board);
        return 0;
    }
    for (int i = 0; i < 8; i = i + 1) {
        if (conflict(board, row, i) == 0) {
            board[row][i] = 1;
            solve(board, row + 1);
            board[row][i] = 0;
        }
    }
}

int main(int argc) {
    int board[8][8];
    for (int i = 0; i < 8; i = i + 1)
        for (int j = 0; j < 8; j = j + 1)
            board[i][j] = 0;
    solve(board, 0);
    return 0;
}