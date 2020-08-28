sed -i "s/console, file/file/" /opt/conda/lib/python3.6/site-packages/hydra/conf/hydra/job_logging/default.yaml
mkdir -p /dgx/data
sshfs inoue.momo:/dgx/inoue/data/ /dgx/data

export PYTHONPATH="/dgx/github/SSAD:$PYTHONPATH"

ls /dgx/data

mkdir -p /dgx/github
cd /dgx/github
git clone https://github.com/TaikiInoue/SSAD.git
cd /dgx/github/SSAD
git checkout master
git checkout 18013875df1da233f25bf38d8751d100033a4cda

python ssad/run.py conf/config.yaml
