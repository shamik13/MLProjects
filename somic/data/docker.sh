docker build -t dvc .
docker run --rm --env-file=somic.env --mount type=bind,source=/home/shamik/WORK/SOMIC/AIRFLOW_DIR/DATA,target=/app dvc
