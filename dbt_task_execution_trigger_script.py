import boto3
import logging
import traceback
import os
import re
import json

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

ECS_CLUSTER_NAME = os.environ['ECS_CLUSTER_NAME']
ECS_TASK_DEFINITION_ARN = os.environ['ECS_TASK_DEFINITION_ARN']
ECS_SECURITY_GROUP_ID = os.environ["ECS_SECURITY_GROUP_ID"]
ECS_TASK_SUBNET_ID = os.environ["ECS_TASK_SUBNET_ID"]
SECRET_MANAGER_NAME = os.environ["SECRET_MANAGER_NAME"]
CONTAINER_NAME = os.environ["CONTAINER_NAME"]


def get_snowflake_credentials():
    # Retrieve snowflake credentials from SSM parameter store
    session = boto3.session.Session()
    client = session.client(
        service_name="secretsmanager",
        region_name="us-east-1"
    )

    credentials = {}
    logger.info(f"Retrieving credentials from secret {SECRET_MANAGER_NAME}")
    response = client.get_secret_value(SecretId=SECRET_MANAGER_NAME)
    secret = response["SecretString"]
    credentials.update(json.loads(secret))

    return credentials


def lambda_handler(event, context):
    try:
        # Create an ECS client
        ecs_client = boto3.client('ecs')

        # Extract ecs_task_definition_name from ecs_task_definition_arn using a regular expression
        match = re.search(r'task-definition/(.+):(\d+)', ECS_TASK_DEFINITION_ARN)
        ecs_task_definition_name = match.group(1) + ':' + match.group(2)

        logger.info("Setting container environment variables")
        snowflake_credentials = get_snowflake_credentials()

        # Set the container overrides
        container_overrides = [
            {
                'name': CONTAINER_NAME,
                'environment': [
                    {'name': 'SNF_ACCOUNT', 'value': snowflake_credentials['account']},
                    {'name': 'SNF_USER', 'value': snowflake_credentials['user']},
                    {'name': 'SNF_ROLE', 'value': snowflake_credentials['role']},
                    {'name': 'SNF_PASSWORD', 'value': snowflake_credentials['password']},
                    {'name': 'SNF_WAREHOUSE', 'value': snowflake_credentials['warehouse']},
                    {'name': 'SNF_DATABASE', 'value': snowflake_credentials['database']},
                    {'name': 'SNF_SCHEMA', 'value': snowflake_credentials['schema']},
                    {'name': 'DBT_ENV', 'value': os.getenv('ENVIRONMENT')}
                ]
            },
        ]

        logger.info("Submitting task to ECS")

        response = ecs_client.run_task(
            taskDefinition=ecs_task_definition_name,
            cluster=ECS_CLUSTER_NAME,
            launchType='FARGATE',
            overrides={'containerOverrides': container_overrides},
            networkConfiguration={
                'awsvpcConfiguration': {
                    'subnets': [ECS_TASK_SUBNET_ID],
                    'securityGroups': [ECS_SECURITY_GROUP_ID],
                    'assignPublicIp': 'ENABLED'
                }
            }
        )
        logger.info(f"Task successfully submitted to ECS. Task arn: {response['tasks'][0]['taskArn']}")
    except Exception as error:
        logger.error(traceback.format_exc())
