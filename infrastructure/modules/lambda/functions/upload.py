# upload_file.py
# This Lambda function decodes a base64-encoded file and uploads it to S3.
# It expects `file_name` and `file_data` (base64) in the request body.

import json
import boto3
import base64
import os

s3 = boto3.client('s3')
bucket_name = os.environ.get('BUCKET_NAME')

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        file_name = body['file_name']
        file_data = base64.b64decode(body['file_data'])

        s3.put_object(Bucket=bucket_name, Key=file_name, Body=file_data)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': f'{file_name} uploaded successfully'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
