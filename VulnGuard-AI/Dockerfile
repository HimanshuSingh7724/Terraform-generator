# Stage 1: Trivy image
FROM aquasec/trivy:latest AS trivy

# Stage 2: Your Python app
FROM python:3.10-slim

WORKDIR /app

# Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .

# Copy Trivy binary from first stage
COPY --from=trivy /usr/local/bin/trivy /usr/local/bin/trivy

# Ensure Trivy is executable
RUN chmod +x /usr/local/bin/trivy

# Run FastAPI
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
