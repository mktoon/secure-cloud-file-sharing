import boto3
import os

def handler(event, context):
    s3 = boto3.client('s3')
    bucket_name = os.environ['BUCKET_NAME']
    file_path = '/tmp/uploaded_file.txt'
    
    # Simulate file creation
    with open(file_path, 'w') as f:
        f.write('This is a test file.')

    try:
        s3.upload_file(file_path, bucket_name, 'uploaded_file.txt')
        return {
            'statusCode': 200,
            'body': 'File uploaded successfully!'
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Error uploading file: {str(e)}'
        }
        
