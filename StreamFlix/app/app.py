from flask import Flask, render_template, request, redirect, url_for, session
from db import init_db
from models import create_user, get_user

app = Flask(__name__)
app.secret_key = 'supersecretkey'
init_db()

@app.route('/')
def home():
    if 'username' in session:
        return render_template('index.html', username=session['username'])
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user = get_user(request.form['username'], request.form['password'])
        if user:
            session['username'] = user[0]
            return redirect(url_for('home'))
        return "Login failed"
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        create_user(request.form['username'], request.form['password'])
        return redirect(url_for('login'))
    return render_template('signup.html')

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

@app.route('/watch')
def watch():
    if 'username' in session:
        return render_template('player.html')
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
