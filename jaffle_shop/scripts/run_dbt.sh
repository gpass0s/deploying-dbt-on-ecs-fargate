#!/bin/bash
# Invoked in container. Will run in ECS Fargate. Called by Orchestration Tool (i.e. Airflow)

echo "Running dbt main flow"
dbt run --profiles-dir . --project-dir .