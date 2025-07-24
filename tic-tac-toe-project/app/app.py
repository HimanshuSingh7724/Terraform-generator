from flask import Flask, render_template, request, redirect, url_for, session
from game import new_board, check_winner, ai_move

app = Flask(__name__)
app.secret_key = 'tictactoesecret'

@app.route('/')
def index():
    if 'board' not in session:
        session['board'] = new_board()
    board = session['board']
    winner = check_winner(board)
    return render_template('index.html', board=board, winner=winner)

@app.route('/move/<int:x>/<int:y>')
def move(x, y):
    board = session.get('board', new_board())
    if board[x][y] == "" and not check_winner(board):
        board[x][y] = "X"
        if not check_winner(board):
            board = ai_move(board)
    session['board'] = board
    return redirect(url_for('index'))

@app.route('/reset')
def reset():
    session.pop('board', None)
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
