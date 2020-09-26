echo ${DATA_REPO}
git clone ${DATA_REPO} /data

# git clone https://github.com/shamik13/DVC.git /home/shamik/foo/shamik/now/airflow_tests/DVC
# cd /home/shamik/foo/shamik/now/airflow_tests/

cd /data
git checkout ${DATA_COMMIT_HASH}
# dvc remote modify blob_storage url azure://somic/dvc_storage
dvc remote modify --local blob_storage connection_string ${AZURE_STORAGE_CONNECTION_STRING}
dvc pull raw_datasets/*.zip.dvc
dvc repro
cp -r dataset /app/