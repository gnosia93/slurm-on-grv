# slurm-on-grv

![](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/images/slurm-ws-arch.png)

**This workshop explains about how to use AWS graviton EC2 instances for pytorch distributed training with slurm.** 
AWS Graviton processors are custom-built by AWS to deliver the best price performance for cloud workloads. Graviton-based instance is upto 20% more cheaper than X86-based and provide better performance in same generation. AWS Graviton3 optimized for ML workloads and provide the `Single Instruction Multiple Data (SIMD)` while also supporting `bfloat16`. 

Slurm is an open source, fault-tolerant, and highly scalable cluster management and job scheduling system for large and small Linux clusters. 

## Get Started ##

* [1. slurm cluster provison](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/1.provison.md)


* [3. distributed training](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/3.distributed-training.md)

* [5. graviton performance] 


* [6. slurm command fundamentals](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/5.slurm-basic.md)

* [7. slurm cluster monitoring]
   - https://github.com/vpenso/prometheus-slurm-exporter
   - https://grafana.com/grafana/dashboards/4323-slurm-dashboard/

* [8. training with Amazon EC2 Trn2]

* [3. attach jupyter notebook](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/2.attach-jupyter.md)


* [install pytorch with cuda toolkit](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/2.cuda-toolkit.md)



