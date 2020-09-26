import argparse
import sys
import os
import yaml
sys.path.append("/code/")
from squirrel.config.segmentation import Builder
from squirrel.datasets import SomicDataset, SomicCfgDataset
from squirrel.losses import CrossEntropy2D
import torch
import torch.optim as optim
from squirrel.trainers import SegmentationTrainer

class CustomBuilder(Builder):
    """
    This is the custom builder class for semantic segmentation tasks. If you'd like to use custom dataset, augmentation, preprocessing or model,
    please override the required functions from Parent `Builder` class available in `squirrel.config.segmentation`.
    """
    def __init__(self,path):
        super(CustomBuilder, self).__init__(path)
    
    def dataset_path(self):
        config_file = self.cfg['dataset']['path']
        with open(config_file) as f:
            data_cfg = yaml.load(f)
            return data_cfg

    def get_dataset(self):
        data_cfg = self.dataset_path()
        type = self.cfg['dataset']['type']
        train_dataset = SomicCfgDataset(cfg=data_cfg[type]['train'],
                              augmentations = self.train_augmentation(),
                              preprocessing= self.preprocessing())
        val_dataset   = SomicCfgDataset(cfg=data_cfg[type]['test'],
                              augmentations = self.val_augmentation(),
                              preprocessing= self.preprocessing())
        datasets = {}
        datasets["train"] = train_dataset
        datasets["val"]   = val_dataset
        return datasets
    
    def get_trainer(self):
        """
        this function reads all the necessary information for the training process from config file and return a trainer object.
        
        :return: trainer object.
        """
        net = self.get_model()
        datasets = self.get_dataset()
        device = self.cfg['exp_details']['training']['device']
        if self.cfg['exp_details']['training']['optimizer']['name'] == "adam":
            optimizer = optim.Adam(net.parameters(),lr = float(self.cfg['exp_details']['training']['optimizer']['args']['lr']))
        if self.cfg['exp_details']['training']['scheduler']['name'] == "CosineAnnealingLR":
            scheduler = optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max = self.cfg['exp_details']['training']['scheduler']['args']['T_max'])
#         loss_function = self.cfg['exp_details']['training']['loss']['name']
#         fn = getattr(losses,loss_function)
#         if "args" in self.cfg['exp_details']['training']['loss']:
#             loss_fn = fn(**self.cfg['exp_details']['training']['loss']['args'])
#         else:
#             loss_fn = fn()
#         weights = [0.01,0.99]
#         class_weights = torch.FloatTensor(weights).to(device)
#         loss_fn = CrossEntropy2D(weight=class_weights)
        loss_fn = CrossEntropy2D()
        metrics = list(self.cfg['exp_details']['training']['metrics']['name'])
        metric_params = self.cfg['exp_details']['training']['metrics']['params']
        batch_size = self.cfg['exp_details']['training']['batch_size']
        pref = self.cfg['exp_details']['training']['model_saving_pref']
        pref_cond = self.cfg['exp_details']['training']['model_saving_pref_cond']
        self.multi_gpu_backend = self.cfg['exp_details']['training']['multi_gpu_backend']
        trainer = SegmentationTrainer(model = net,
                              datasets= datasets, 
                              optimizer = optimizer,
                              loss_function = loss_fn,
                              batch_size = batch_size,
                              scheduler = scheduler,
                              pretrained_weights = None,
                              metrics = metrics,
                              metric_params = metric_params,
                              device=device, 
                              perf_measure = pref,
                              perf_cond=pref_cond,
                              multi_gpu_backend=self.multi_gpu_backend,
                              use_mlflow_tracking = self.use_mlflow_tracking)
        return trainer
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("yaml", help="yaml path", type=str)
    args = parser.parse_args()
    builder = CustomBuilder(args.yaml)
    builder.run()