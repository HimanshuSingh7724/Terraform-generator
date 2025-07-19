# app/main.py
from flask import Flask, jsonify
import requests
import os

app = Flask(__name__)
API_KEY = os.getenv("WEATHER_API_KEY")

print("Starting app with WEATHER_API_KEY:", API_KEY)  # Debug print

@app.route("/weather/<city>")
def get_weather(city):
    if not API_KEY:
        return jsonify({"error": "API key not set"}), 500

    url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric"
    res = requests.get(url)

    print(f"Request URL: {url}")
    print(f"Response status code: {res.status_code}")
    print(f"Response body: {res.text}")

    if res.status_code != 200:
        return jsonify({"error": "Failed to fetch weather data", "details": res.json()}), res.status_code

    return jsonify(res.json())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
