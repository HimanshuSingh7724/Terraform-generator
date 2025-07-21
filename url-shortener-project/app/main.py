# app/main.py
from flask import Flask, request, redirect, jsonify
import sqlite3, string, random

app = Flask(__name__)
DB = "urls.db"

def init_db():
    conn = sqlite3.connect(DB)
    conn.execute("CREATE TABLE IF NOT EXISTS urls(short TEXT PRIMARY KEY, long TEXT)")
    conn.close()

def shorten_url(long_url):
    short = ''.join(random.choices(string.ascii_letters + string.digits, k=6))
    conn = sqlite3.connect(DB)
    conn.execute("INSERT INTO urls(short, long) VALUES (?, ?)", (short, long_url))
    conn.commit()
    conn.close()
    return short

@app.route('/shorten', methods=['POST'])
def shorten():
    data = request.get_json()
    if not data or 'url' not in data:
        return jsonify({"error": "Missing URL"}), 400
    short = shorten_url(data['url'])
    return jsonify({"short_url": request.host_url + short})

@app.route('/<short>')
def redirect_short(short):
    conn = sqlite3.connect(DB)
    row = conn.execute("SELECT long FROM urls WHERE short=?", (short,)).fetchone()
    conn.close()
    if row:
        return redirect(row[0])
    return jsonify({"error": "Not found"}), 404

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000)
