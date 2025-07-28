import json
import boto3

def lambda_handler(event, context):
    print("Event received:", event)

    s3 = boto3.client("s3")
    bucket = event['Records'][0]['s3']['bucket']['name']
    key    = event['Records'][0]['s3']['object']['key']
    
    # Simulated scan logic
    if key.endswith(".exe") or key.endswith(".js"):
        print(f"Malicious file detected: {key}")
    else:
        print(f"{key} is clean.")

    return {
        "statusCode": 200,
        "body": json.dumps("Scan complete!")
    }
