from fastapi import FastAPI, UploadFile, File
import boto3
import uuid
import psycopg2
from transcribe_utils import start_transcription_job, get_transcription_text

app = FastAPI()

# AWS clients with region
s3_client = boto3.client('s3', region_name='eu-north-1')
transcribe_client = boto3.client('transcribe', region_name='eu-north-1')

# Database connection details (use env vars in prod!)
db_conn = psycopg2.connect(
    host="YOUR_RDS_ENDPOINT",
    database="notesdb",
    user="postgres",
    password="YOUR_PASSWORD"
)
db_cursor = db_conn.cursor()

S3_BUCKET = 'your-s3-bucket'

@app.post("/upload")
async def upload_audio(file: UploadFile = File(...)):
    file_id = str(uuid.uuid4())
    s3_key = f"audio/{file_id}.wav"

    s3_client.upload_fileobj(file.file, S3_BUCKET, s3_key)

    start_transcription_job(file_id, s3_key)

    return {"message": "Uploaded and transcription started", "file_id": file_id}

@app.get("/transcription/{file_id}")
def get_transcription(file_id: str):
    text = get_transcription_text(file_id)

    if text:
        db_cursor.execute(
            "INSERT INTO notes (id, content) VALUES (%s, %s)",
            (file_id, text)
        )
        db_conn.commit()
        return {"text": text}
    else:
        return {"message": "Transcription not ready"}

@app.get("/search")
def search_notes(q: str):
    db_cursor.execute(
        "SELECT id, content FROM notes WHERE content ILIKE %s",
        (f"%{q}%",)
    )
    results = db_cursor.fetchall()
    return {"results": results}
