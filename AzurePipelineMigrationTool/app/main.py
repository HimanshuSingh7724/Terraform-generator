from flask import Flask, request, render_template
from converter import azure_to_github
import os

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        azure_yaml = request.files["azure_yaml"]
        azure_content = azure_yaml.read().decode("utf-8")
        github_yaml = azure_to_github(azure_content)
        return f"<h2>Converted GitHub Workflow:</h2><pre>{github_yaml}</pre>"
    return render_template("index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
