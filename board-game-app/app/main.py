from fastapi import FastAPI, HTTPException
from app.game_logic import TicTacToe

app = FastAPI()
game = TicTacToe()

@app.get("/")
def read_root():
    return {"message": "Tic Tac Toe API running!"}

@app.post("/move/{player}/{row}/{col}")
def make_move(player: str, row: int, col: int):
    try:
        result = game.make_move(player, row, col)
        return {"board": game.board, "status": result}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/status")
def get_status():
    return {"board": game.board, "winner": game.check_winner()}
