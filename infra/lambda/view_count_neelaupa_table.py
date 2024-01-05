import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('neelaupa_table')

def lambda_handler(event, context):
    ip_address = event['requestContext']['http']['sourceIp']
    print(f"Request received from IP: {ip_address}")

    response = table.get_item(Key={
       'id':'0'
    })
    views = response['Item']['views']
    views = views + 1
    print(views)
    response = table.put_item(Item={
        'id':'0',
        'views':views
    })
    
    return views