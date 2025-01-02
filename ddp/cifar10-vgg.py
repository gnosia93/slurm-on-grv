"""
    This script is distributed training example with pytorch DDP.  
    author: soonbeom kwon
    email: gnosia93@naver.com
    revision:
        1. 2025/01/02 draft version released.
"""

import os
import sys
import tempfile
import time
import torch
import torch.distributed as dist
import torch.nn as nn 
import torch.optim as optim
import torch.multiprocessing as mp 
from torch.nn.parallel import DistributedDataParallel as DDP

from torchvision.datasets.cifar import CIFAR10
import torchvision.transforms as transforms
from torch.utils.data import DataLoader
from torch.utils.data.distributed import DistributedSampler

from torchvision.models import vgg11
from torch.optim.lr_scheduler import StepLR


def setup():
    """
    def setup(rank, world_size):
        os.environ['MASTER_ADDR'] = 'localhost'
        os.environ['MASTER_PORT'] = '12355'

        dist.init_process_group("nccl" if torch.cuda.is_available() else "gloo", 
                                rank=rank, world_size=world_size)
    """    
    dist.init_process_group("nccl")

def cleanup():
    dist.destroy_process_group()

def load_train_data(batch_size):
    trransform = transforms.Compose([
        transforms.Resize(256),
        transforms.RandomCrop(224),
        transforms.RandomHorizontalFlip(),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])
    
    train_dataset = CIFAR10(root=tempfile.gettempdir(), train=True, download=True, transform=trransform)
    train_sampler = DistributedSampler(train_dataset, shuffle=True)
    train_loader = DataLoader(train_dataset, batch_size=batch_size, sampler=train_sampler)

    return train_loader, train_sampler 

def train():
    global_rank = dist.get_rank()
    rank = global_rank % torch.cuda.device_count()       # local rank
    print(f"Running DDP training on global rank {global_rank}, rank {rank}, gpu {torch.cuda.device_count()}")

    model = vgg11().to(rank)
    model = DDP(model, device_ids=[rank])
    
    criterion = nn.CrossEntropyLoss().to(rank)
    optimizer = optim.SGD(model.parameters(), 
                         lr=0.001,
                         weight_decay=0.0005,
                         momentum=0.9)
    scheduler = StepLR(optimizer, step_size=30, gamma=0.1)          
    train_loader, train_sampler = load_train_data(128)
    """
    This method is used to sync all the processes and wont allow any process to execute beyond this point. 
    This function is crucial because we may need to share some data between different processes for which we need all of them to be executed. 
    As a thumb rule, you can think of as the code between two dist.barrier() are being executed simultaneously between different processes.    
    """
    dist.barrier()
    model.train()

    for epoch in range(2):  

        """
        Based on the docs it’s necessary to use set_epoch to guarantee a different shuffling order:
        In distributed mode, calling the set_epoch() method at the beginning of each epoch 
        before creating the DataLoader iterator is necessary to make shuffling work properly across multiple epochs. 
        Otherwise, the same ordering will be always used.
        """ 
        train_sampler.set_epoch(epoch)                
        start_time = time.time()
        for i, (images, labels) in enumerate(train_loader):
            images = images.to(rank)
            labels = labels.to(rank)
            optimizer.zero_grad()
            outputs = model(images)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()
            if i % 10 == 0:
                print(f"Epoch {epoch}, batch {i}, Loss {loss.item()}")
        end_time = time.time()
        print(f"Epoch {epoch} took {end_time - start_time} seconds")
        scheduler.step()    # https://sanghyu.tistory.com/113 

if __name__ == "__main__":
    setup()
    train()         
    cleanup()

# Multi Gpu example    
# export MASTER_ADDR=localhost
# OMP_NUM_THREADS=4 torchrun --nnodes=2 --nproc_per_node=1 --rdzv_id=100 --rdzv_backend=c10d --rdzv_endpoint=$MASTER_ADDR:29400 cifar10-vgg.py          
#
# Multi Node example    
# MASTER_ADDR=10.0.101.161 torchrun --nproc_per_node=1 --nnodes=2 --node_rank=0 --master_addr=$MASTER_ADDR --master_port=29400 cifar10-vgg.py
# MASTER_ADDR=10.0.101.161 torchrun --nproc_per_node=1 --nnodes=2 --node_rank=1 --master_addr=$MASTER_ADDR --master_port=29400 cifar10-vgg.py
