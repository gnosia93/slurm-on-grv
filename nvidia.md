## Linux Distribution Information ##
```
cat /etc/os-release
uname -m
sudo lshw -C display
```

## Cuda Driver Install ##



## G5g ##
Amazon EC2 G5g instances are powered by AWS Graviton2 processors and feature NVIDIA T4G Tensor Core GPUs to provide the best price performance in Amazon EC2 for graphics workloads such as Android game streaming. They are the first Arm-based instances in a major cloud to feature GPU acceleration.

With G5g instances, game streaming customers can run Android games natively on Arm-based instances, encode the rendered graphics, and stream the game over network to a mobile device. This helps reduce development effort by eliminating the need for cross-compilation or emulation, and lowers the cost-per-stream per hour by up to 30%.

The G5g instances are also a cost-effective platform for machine learning inference. They are ideal for deploying deep learning applications that need access to NVIDIA GPUs and their associated AI libraries.
```
=============================================================================
AMI Name: Deep Learning ARM64 Base OSS Nvidia Driver GPU AMI (Ubuntu 22.04)
Supported EC2 instances: G5g
NVIDIA driver version: 550.127.05
CUDA versions available: cuda-12.1 cuda-12.2 cuda-12.3
Default CUDA version is 12.1

Release notes: https://docs.aws.amazon.com/dlami/latest/devguide/appendix-ami-release-notes.html
AWS Deep Learning AMI Homepage: https://aws.amazon.com/machine-learning/amis/
Developer Guide and Release Notes: https://docs.aws.amazon.com/dlami/latest/devguide/what-is-dlami.html
Support: https://forums.aws.amazon.com/forum.jspa?forumID=263
For a fully managed experience, check out Amazon SageMaker at https://aws.amazon.com/sagemaker
=============================================================================
```



## reference ##

* https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
