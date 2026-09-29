import json
import time
import os
import urllib.request
import urllib.error
import boto3

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = "PipelineHistory"
table = dynamodb.Table(TABLE_NAME)


BOT_CONFIG = {
    "jakarta": {
        "token": os.environ.get("TELEGRAM_BOT_TOKEN_JAKARTA"),
        "chat_id": os.environ.get("TELEGRAM_CHAT_ID_JAKARTA"),
    },
    "bandung": {
        "token": os.environ.get("TELEGRAM_BOT_TOKEN_BANDUNG"),
        "chat_id": os.environ.get("TELEGRAM_CHAT_ID_BANDUNG"),
    },
}


def detect_site(body, original_message):
    try:
        attrs = body.get('MessageAttributes', {})
        site_attr = attrs.get('site', {}).get('Value')
        if site_attr:
            return site_attr.lower()
    except Exception:
        pass

    text_lower = original_message.lower()
    if "bandung" in text_lower:
        return "bandung"
    if "jakarta" in text_lower:
        return "jakarta"

    return "jakarta"


def send_telegram_alert(site, text):
    config = BOT_CONFIG.get(site)
    if not config:
        print(f"Site '{site}' tidak dikenal, skip alert")
        return

    token = config["token"]
    chat_id = config["chat_id"]

    if not token or not chat_id:
        print(f"Bot token/chat_id untuk site '{site}' belum diset, skip alert")
        return

    url = f"https://api.telegram.org/bot{token}/sendMessage"
    payload = json.dumps({
        "chat_id": chat_id,
        "text": f"[{site.upper()}] {text}"
    }).encode('utf-8')

    req = urllib.request.Request(
        url,
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST"
    )
    try:
        with urllib.request.urlopen(req, timeout=8) as response:
            print(f"Telegram alert ({site}) terkirim, status: {response.status}")
    except urllib.error.HTTPError as e:
        print(f"Telegram API error ({site}): {e.code} - {e.read().decode('utf-8')}")
    except urllib.error.URLError as e:
        print(f"Gagal konek ke Telegram API ({site}): {str(e)}")


def lambda_handler(event, context):
    print(f"RAW EVENT: {json.dumps(event)}")

    for record in event['Records']:
        body = json.loads(record['body'])
        original_message = body.get('Message', 'Pesan tidak ditemukan')
        sns_message_id = body.get('MessageId', record.get('messageId', 'unknown'))

        site = detect_site(body, original_message)
        print(f"Pesan diterima dari SQS (site: {site}): {original_message}")

        item = {
            'event_id': sns_message_id,
            'timestamp': int(time.time() * 1000),
            'message': original_message,
            'source': 'sqs-consumer-lambda',
            'site': site,
            'status': 'processed',
        }

        try:
            table.put_item(Item=item)
            print(f"Berhasil ditulis ke DynamoDB: {item['event_id']}")
        except Exception as e:
            print(f"GAGAL nulis ke DynamoDB: {str(e)}")
            send_telegram_alert(site, f"GAGAL nulis history ke DynamoDB!\n{original_message}\nError: {str(e)}")
            raise

        send_telegram_alert(site, f"Pipeline event diproses:\n{original_message}")

    return {
        'statusCode': 200,
        'body': json.dumps('Pesan berhasil diproses, dicatat ke DynamoDB, dan alert terkirim')
    }
