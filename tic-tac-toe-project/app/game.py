def new_board():
    return [["" for _ in range(3)] for _ in range(3)]

def check_winner(board):
    lines = board + list(map(list, zip(*board)))  # rows + columns
    lines += [[board[i][i] for i in range(3)], [board[i][2 - i] for i in range(3)]]
    for line in lines:
        if line == ["X"] * 3:
            return "X"
        elif line == ["O"] * 3:
            return "O"
    if all(cell for row in board for cell in row):
        return "Draw"
    return None

def ai_move(board):
    for i in range(3):
        for j in range(3):
            if board[i][j] == "":
                board[i][j] = "O"
                return board
    return board
