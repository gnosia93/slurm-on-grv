# slurm-on-grv

![](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/images/slurm-ws-arch.png)

**This workshop is about how to use AWS graviton EC2 instances for pytorch distributed training with slurm.** 
AWS Graviton processors are custom-built by AWS to deliver the best price performance for cloud workloads. 
Launched in 2019, Graviton2 is the second generation of AWS Graviton processors. Graviton2-based instance types offer up to 40% better price performance compared to fifth generation instances.
**AWS Graviton3 processors are optimized for ML workloads and provide twice the Single Instruction Multiple Data (SIMD) bandwidth while also supporting bfloat16.** 

Slurm is an open source, fault-tolerant, and highly scalable cluster management and job scheduling system for large and small Linux clusters. Slurm requires no kernel modifications for its operation and is relatively self-contained.

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





