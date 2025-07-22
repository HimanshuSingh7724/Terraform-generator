import boto3
import os
from PIL import Image

s3 = boto3.client('s3')

def handler(event, context):
    print("Event Received:", event)

    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    resized_bucket = os.environ['RESIZED_BUCKET']

    download_path = f"/tmp/{key}"
    upload_key = f"resized-{key}"
    upload_path = f"/tmp/{upload_key}"

    # Download image from S3
    s3.download_file(source_bucket, key, download_path)

    # Resize image
    with Image.open(download_path) as image:
        image = image.resize((128, 128))
        image.save(upload_path)

    # Upload to resized bucket
    s3.upload_file(upload_path, resized_bucket, upload_key)

    return {
        'statusCode': 200,
        'body': f"Image resized and uploaded to {resized_bucket}/{upload_key}"
    }
