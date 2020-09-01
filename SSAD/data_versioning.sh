#!/bin/bash

repo=${repo:-}
DVC_dir=${DVC_dir:-}
commit_hash=${commit_hash:-}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
   fi

  shift
done

git clone $repo /mlflow/DVC
cd /mlflow/DVC
git checkout $commit_hash
dvc pull raw_datasets/*.zip.dvc
dvc repro --cwd repro
cd /mlflow/code
