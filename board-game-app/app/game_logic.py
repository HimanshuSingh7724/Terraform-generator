class TicTacToe:
    def __init__(self):
        self.board = [["" for _ in range(3)] for _ in range(3)]

    def make_move(self, player, row, col):
        if self.board[row][col] != "":
            raise ValueError("Cell already taken.")
        self.board[row][col] = player
        return "Move accepted."

    def check_winner(self):
        b = self.board
        for row in b:
            if row[0] == row[1] == row[2] != "":
                return row[0]
        for col in range(3):
            if b[0][col] == b[1][col] == b[2][col] != "":
                return b[0][col]
        if b[0][0] == b[1][1] == b[2][2] != "":
            return b[0][0]
        if b[0][2] == b[1][1] == b[2][0] != "":
            return b[0][2]
        return None
