from flask import Flask, request, render_template
from ocr_utils import extract_text_from_image
from nlp_utils import extract_entities
import os

app = Flask(__name__)

UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route("/", methods=["GET", "POST"])
def index():
    extracted_text = ""
    entities = {}

    if request.method == "POST":
        file = request.files["document"]
        filepath = os.path.join(UPLOAD_FOLDER, file.filename)
        file.save(filepath)

        extracted_text = extract_text_from_image(filepath)
        entities = extract_entities(extracted_text)

    return render_template("index.html", text=extracted_text, entities=entities)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
