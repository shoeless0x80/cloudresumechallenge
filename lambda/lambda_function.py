import os
import boto3
import json

def lambda_handler(event, context):
    # Debug table name
    table_name = os.environ.get("TABLE_NAME")
    print(f"[DEBUG] TABLE_NAME = {table_name}")

    # Initialize DynamoDB and table
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table(table_name)

    # Increment the counter
    response = table.update_item(
        Key={"id": "visitor_count"},
        UpdateExpression="ADD #c :inc",
        ExpressionAttributeNames={"#c": "count"},
        ExpressionAttributeValues={":inc": 1},
        ReturnValues="UPDATED_NEW"
    )

    # Get the new count and convert Decimal → int
    count_decimal = response["Attributes"]["count"]
    count = int(count_decimal)

    return {
        "statusCode": 200,
        "headers": {"Access-Control-Allow-Origin": "*"},
        "body": json.dumps({"count": count})
    }