docker build -t dvc .
docker run --rm --mount type=bind,source=/home/shamik/WORK/SOMIC/AIRFLOW_DIR/DATA,target=/app
