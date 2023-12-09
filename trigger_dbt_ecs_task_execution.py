import boto3
import logging
import traceback
import os
import re
import json
import time

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

_ecs_cluster_name = os.environ['ECS_CLUSTER_NAME']
_ecs_task_definition_arn = os.environ['ECS_TASK_DEFINITION_ARN']
_ecs_security_group_id = os.environ["ECS_SECURITY_GROUP_ID"]
_ecs_task_public_subnet_id = os.environ["ECS_TASK_SUBNET_ID"]
_secret_manager_name = os.environ["SECRET_MANAGER_NAME"]
_container_name = os.environ["CONTAINER_NAME"]
_containers_interval_in_seconds = int(os.environ["CONTAINERS_INTERVAL_IN_SECONDS"])


def get_snowflake_credentials():
    # Retrieve snowflake credentials from SSM parameter store
    session = boto3.session.Session()
    client = session.client(
        service_name="secretsmanager",
        region_name="us-east-1"
    )

    credentials = {}
    logger.info(f"Retrieving credentials from secret {_secret_manager_name}")
    response = client.get_secret_value(SecretId=_secret_manager_name)
    secret = response["SecretString"]
    credentials.update(json.loads(secret))

    return credentials


def lambda_handler(event, context):

    try:
        # Create an ECS client
        ecs_client = boto3.client('ecs')

        # task_definitions_arn = [secret.strip() for secret in _ecs_task_definitions_arn.split(",")]
        # containers = [secret.strip() for secret in _containers_name.split(",")]

        # Extract ecs_task_definition_name from ecs_task_definition_arn using a regular expression
        match = re.search(r'task-definition/(.+):(\d+)', _ecs_task_definition_arn)
        ecs_task_definition_name = match.group(1) + ':' + match.group(2)

        logger.info(f"Setting container environment variables")
        snowflake_credentials = get_snowflake_credentials()

        # Set the container overrides
        container_overrides = [
            {
                'name': _container_name,
                'environment': [
                    {
                        'name': 'SNF_ACCOUNT',
                        'value': snowflake_credentials['account']
                    },
                    {
                        'name': 'SNF_USER',
                        'value': snowflake_credentials['username']
                    },
                    {
                        'name': 'SNF_PRIVATE_KEY',
                        'value': snowflake_credentials['private_key']
                    },
                    {
                        'name': 'SNF_ROLE',
                        'value': snowflake_credentials['role']
                    },
                    {
                        'name': 'SNF_WAREHOUSE',
                        'value': snowflake_credentials['warehouse']
                    },
                    {
                        'name': 'SNF_DATABASE',
                        'value': snowflake_credentials['database']
                    },
                    {
                        'name': 'SNF_SCHEMA',
                        'value': snowflake_credentials['schema']
                    },
                    {
                        'name': 'DBT_ENV',
                        'value': os.getenv('ENVIRONMENT')
                    }
                ]
            },
        ]

        logger.info(f"Submitting task to ECS")

        response = ecs_client.run_task(
            taskDefinition=ecs_task_definition_name,
            cluster=_ecs_cluster_name,
            launchType='FARGATE',
            overrides={
                'containerOverrides': container_overrides
            },
            networkConfiguration={
                'awsvpcConfiguration': {
                    'subnets': [_ecs_task_public_subnet_id],
                    'securityGroups': [_ecs_security_group_id],
                    'assignPublicIp': 'ENABLED'
                }
            }
        )
        logger.info(f"Task successfully submitted to ECS. Task arn: {response['tasks'][0]['taskArn']}")
        time.sleep(_containers_interval_in_seconds)
    except Exception as error:
        logger.error(traceback.format_exc())

