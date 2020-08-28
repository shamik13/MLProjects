sed -i "s/console, file/file/" /opt/conda/lib/python3.6/site-packages/hydra/conf/hydra/job_logging/default.yaml
mkdir -p /dgx/data
sshfs inoue.momo:/dgx/inoue/data/ /dgx/data

export PYTHONPATH="/dgx/github/SSAD:$PYTHONPATH"

mkdir -p /dgx/github
cd /dgx/github
git clone https://github.com/TaikiInoue/SSAD.git
cd /dgx/github/SSAD
git checkout master
git checkout 31c664b53f14719a2f1623e83af7ad7e366be194

python ssad/run.py ssad/conf/config.yaml
