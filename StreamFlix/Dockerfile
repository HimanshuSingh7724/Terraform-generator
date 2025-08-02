FROM python:3.10-slim

WORKDIR /app

# Copy requirements.txt into container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY app/ .

EXPOSE 5000

CMD ["python", "app.py"]
