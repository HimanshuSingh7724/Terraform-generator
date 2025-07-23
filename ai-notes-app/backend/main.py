from fastapi import FastAPI, UploadFile, File
import boto3
import uuid
import psycopg2
import os  # ✅ Environment vars ke liye
from transcribe_utils import start_transcription_job, get_transcription_text

app = FastAPI()

# ✅ AWS region fix
AWS_REGION = 'eu-north-1'

# ✅ Get env vars
RDS_ENDPOINT = os.getenv("DB_HOST")
RDS_PASSWORD = os.getenv("DB_PASSWORD")
S3_BUCKET = os.getenv("S3_BUCKET")

# ✅ AWS Clients
s3_client = boto3.client('s3', region_name=AWS_REGION)
transcribe_client = boto3.client('transcribe', region_name=AWS_REGION)

# ✅ DB Connection
db_conn = psycopg2.connect(
    host=RDS_ENDPOINT,
    database="notesdb",
    user="postgres",
    password=RDS_PASSWORD
)
db_cursor = db_conn.cursor()


@app.post("/upload")
async def upload_audio(file: UploadFile = File(...)):
    file_id = str(uuid.uuid4())
    s3_key = f"audio/{file_id}.wav"

    # ✅ Upload to S3
    s3_client.upload_fileobj(file.file, S3_BUCKET, s3_key)

    # ✅ Start transcription job
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
