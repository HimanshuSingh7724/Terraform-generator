FROM python:3.10-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y tesseract-ocr libglib2.0-0 libsm6 libxrender1 libxext6 && \
    pip install --upgrade pip

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt && \
    python -m spacy download en_core_web_sm

COPY app/ .

EXPOSE 5000

CMD ["python", "app.py"]
