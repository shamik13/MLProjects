# #!/bin/bash

for i in "$@"
do
case $i in
    --data_repo=*)
    data_repo="${i#*=}"
    shift
    ;;
    --data_commit_hash=*)
    data_commit_hash="${i#*=}"
    shift
    ;;
    --code_repo=*)
    code_repo="${i#*=}"
    shift
    ;;
    --code_commit_hash)
    code_commit_hash="${i#*=}"
    shift
    ;;
    *)
    ;;
esac
done


git clone ${data_repo} /mlflow/data
git clone ${code_repo} /mlflow/code

cd /mlflow/data
git checkout ${data_commit_hash}
dvc remote modify blob_storage url azure://somic/dvc_storage
dvc remote modify --local blob_storage connection_string $AZURE_STORAGE_CONNECTION_STRING
dvc pull raw_datasets/*.zip.dvc
dvc repro --cwd repro

cd /mlflow/code
export PYTHONPATH="/mlflow/code:$PYTHONPATH"
git checkout ${code_commit_hash}

cd /mlflow/projects/code
python run.py conf/config.yaml
