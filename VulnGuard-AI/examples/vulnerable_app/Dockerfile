FROM python:3.9-slim
RUN apt-get update && apt-get install -y libssl1.1
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt
CMD ["python3"]
