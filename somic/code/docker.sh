docker build -t somic .
MLFLOW_EXPERIMENT_NAME='/Users/shamik@nablas.com/airflow_test' mlflow run --docker-args gpus=all .
