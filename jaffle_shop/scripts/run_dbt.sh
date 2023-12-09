#!/bin/bash
# Invoked in container. Will run in ECS Fargate. Called by Orchestration Tool (i.e. Airflow)

echo "Installing dbt deps"
dbt deps --profiles-dir . --project-dir .
echo "Running dbt main flow"
dbt run --profiles-dir . --project-dir .
echo "Running macro that updates unified model tables"
dbt run-operation update_unified_model --profiles-dir . --project-dir .
echo "dbt process has just finished"