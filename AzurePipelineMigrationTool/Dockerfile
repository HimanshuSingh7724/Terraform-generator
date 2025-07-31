FROM python:3.10-slim

WORKDIR /app

COPY app/ ./app
COPY templates/ ./app/templates
COPY static/ ./app/static
COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["python", "app/main.py"]
