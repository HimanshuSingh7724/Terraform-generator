from flask import Flask, request, render_template
import boto3
import os

app = Flask(__name__)
s3 = boto3.client("s3", region_name="eu-north-1")

BUCKET_NAME = os.environ.get("BUCKET_NAME")

@app.route("/", methods=["GET", "POST"])
def upload():
    message = ""
    if request.method == "POST":
        file = request.files["file"]
        if file:
            s3.upload_fileobj(file, BUCKET_NAME, file.filename)
            message = f"{file.filename} uploaded and awaiting scan."
    return render_template("index.html", message=message)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
