import json
import boto3

sns_client = boto3.client('sns')

TOPIC_ARN = "arn:aws:sns:us-east-1:000000000000:user-updates-topic"

def lambda_handler(event, context):
    record = event['Records'][0]
    bucket_name = record['s3']['bucket']['name']
    object_key = record['s3']['object']['key']

    message = f"File baru diupload: {object_key} ke bucket {bucket_name}"

    sns_client.publish(
        TopicArn=TOPIC_ARN,
        Message=message
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Notifikasi terkirim!')
    }
