#!/bin/bash

git clone https://github.com/TaikiInoue/DVC.git /app/DVC
cp /mlflow/projects/code/.dvc/config.local /app/DVC/.dvc/config.local
cp /mlflow/projects/code/.mlflow/.databrickscfg ~/.databrickscfg

cd /app/DVC
dvc pull raw_datasets/*.zip.dvc
dvc repro --cwd repro
cd /mlflow/projects/code

python run.py conf/config.yaml
