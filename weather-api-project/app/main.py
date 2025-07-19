# app/main.py
from flask import Flask, jsonify
import requests
import os

app = Flask(__name__)
API_KEY = os.getenv("WEATHER_API_KEY")

@app.route("/weather/<city>")
def get_weather(city):
    if not API_KEY:
        return jsonify({"error": "API key not set"}), 500

    url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric"
    res = requests.get(url)
    data = res.json()

    if res.status_code != 200:
        return jsonify({"error": "API call failed", "details": data}), res.status_code

    filtered = {
        "city": data.get("name"),
        "temperature": data["main"]["temp"],
        "feels_like": data["main"]["feels_like"],
        "humidity": data["main"]["humidity"],
        "weather": data["weather"][0]["description"],
        "wind_speed": data["wind"]["speed"]
    }

    return jsonify(filtered)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
