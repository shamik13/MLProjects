#!/bin/bash

data_dir=${data_dir:-}
branch=${branch:-}
commit_id=${commit_id:-}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
   fi

  shift
done

cd $data_dir
git checkout $branch
git checkout $commit_id
dvc repro
