echo ${CODE_REPO}
git clone ${CODE_REPO}  /code

cd /code
git checkout ${CODE_COMMIT_HASH}

cd /mlflow/projects/code
python run.py conf/fastfcn_resnest_tobu.yaml
# git clone https://$GITHUB_USERNAME:$GITHUB_PASSWORD@github.com/nablas-inc/somic.git  /home/shamik/foo/shamik/now/airflow_tests/somic
# cd /home/shamik/foo/shamik/now/airflow_tests/somic