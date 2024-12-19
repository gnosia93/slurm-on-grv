# slurm-on-grv

![](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/images/slurm-ws-arch.png)

This workshop explains about how to use AWS graviton EC2 instnaces for pytorch distributed training with slurm.  
AWS Graviton processors are custom-built by AWS to deliver the best price performance for cloud workloads. The Graviton processor is one of three processor options and powers Amazon EC2 instance types for general purpose, compute-optimized, memory-optimized, and storage-optimized use cases.  
Launched in 2019, Graviton2 is the second generation of AWS Graviton processors. Graviton2-based instance types offer up to 40% better price performance compared to fifth generation instances.

Slurm is an open source, fault-tolerant, and highly scalable cluster management and job scheduling system for large and small Linux clusters. Slurm requires no kernel modifications for its operation and is relatively self-contained. As a cluster workload manager, Slurm has three key functions. First, it allocates exclusive and/or non-exclusive access to resources (compute nodes) to users for some duration of time so they can perform work. Second, it provides a framework for starting, executing, and monitoring work (normally a parallel job) on the set of allocated nodes. Finally, it arbitrates contention for resources by managing a queue of pending work.

## Get Started ##

* [1. slurm cluster provison](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/1.provison.md)

* [2. slurm cluster monitoring setup]
   - https://github.com/vpenso/prometheus-slurm-exporter
   - https://grafana.com/grafana/dashboards/4323-slurm-dashboard/

* [3. slurm command basic](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/3.slurm-basic.md)

* [4. distributed training]
  * [Multi-node-training on slurm with PyTorch](https://gist.github.com/TengdaHan/1dd10d335c7ca6f13810fff41e809904)




## Reference ##

* https://daringfireball.net/projects/markdown/syntax#img





