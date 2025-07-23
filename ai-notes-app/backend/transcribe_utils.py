import boto3

# AWS Transcribe client with region
transcribe_client = boto3.client('transcribe', region_name='eu-north-1')
S3_BUCKET = 'your-s3-bucket'

def start_transcription_job(job_name, s3_key):
    transcribe_client.start_transcription_job(
        TranscriptionJobName=job_name,
        Media={'MediaFileUri': f's3://{S3_BUCKET}/{s3_key}'},
        MediaFormat='wav',
        LanguageCode='en-US',
        OutputBucketName=S3_BUCKET
    )

def get_transcription_text(job_name):
    job = transcribe_client.get_transcription_job(TranscriptionJobName=job_name)
    if job['TranscriptionJob']['TranscriptionJobStatus'] == 'COMPLETED':
        transcript_file_uri = job['TranscriptionJob']['Transcript']['TranscriptFileUri']
        # Normally download & parse JSON here
        # For demo, return dummy text
        return "Sample transcribed text"
    else:
        return None
