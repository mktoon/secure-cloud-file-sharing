# download_file.py
# This Lambda function generates a pre-signed URL to download a file from S3.
# It expects `file_name` as a query parameter.

import json
import boto3
import os

s3 = boto3.client('s3')
bucket_name = os.environ.get('BUCKET_NAME')

def lambda_handler(event, context):
    try:
        file_name = event['queryStringParameters']['file_name']

        presigned_url = s3.generate_presigned_url(
            ClientMethod='get_object',
            Params={
                'Bucket': bucket_name,
                'Key': file_name
            },
            ExpiresIn=3600  # URL valid for 1 hour
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'download_url': presigned_url})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
