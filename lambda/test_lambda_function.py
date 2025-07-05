import os
import boto3
from moto import mock_dynamodb2
import pytest

# ensure test table name
os.environ["TABLE_NAME"] = "test-table"

@mock_dynamodb2
def test_lambda_handler_increment():
    # setup
    dynamodb = boto3.resource("dynamodb", region_name="us-west-2")
    table = dynamodb.create_table(
        TableName="test-table",
        KeySchema=[{"AttributeName":"id","KeyType":"HASH"}],
        AttributeDefinitions=[{"AttributeName":"id","AttributeType":"S"}],
        BillingMode="PAY_PER_REQUEST"
    )
    # seed initial item
    table.put_item(Item={"id":"visitor_count","count":0})

    from lambda_function import lambda_handler
    resp = lambda_handler({}, {})
    assert resp["statusCode"] == 200
    body = resp["body"]
    assert '"count": 1' in body