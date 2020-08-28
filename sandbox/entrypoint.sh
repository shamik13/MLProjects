sed -i "s/console, file/file/" /opt/conda/lib/python3.6/site-packages/hydra/conf/hydra/job_logging/default.yaml
mkdir -p /dgx/data
sshfs inoue.momo:/dgx/inoue/data/ /dgx/data

export PYTHONPATH="/dgx/github/SSAD:$PYTHONPATH"

mkdir -p /dgx/github
cd /dgx/github
git clone https://github.com/TaikiInoue/SSAD.git
cd /dgx/github/SSAD
git checkout master
git checkout e079a334bd52dee160e46dcf9f695f549e9c7faf

python ssad/run.py conf/config.yaml
