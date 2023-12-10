#!/bin/bash
# Invoked in container. Will run in ECS Fargate. Called by Orchestration Tool (i.e. Airflow)

echo "Running dbt main flow"
# The --profiles-dir flag is essential for directing dbt execution to the profiles.yml file within this project.
dbt run --profiles-dir . --project-dir .