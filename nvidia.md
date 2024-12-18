## G5g EC Instance ##
Amazon EC2 G5g instances are powered by AWS Graviton2 processors and feature NVIDIA T4G Tensor Core GPUs to provide the best price performance in Amazon EC2 for graphics workloads such as Android game streaming. They are the first Arm-based instances in a major cloud to feature GPU acceleration.

With G5g instances, game streaming customers can run Android games natively on Arm-based instances, encode the rendered graphics, and stream the game over network to a mobile device. This helps reduce development effort by eliminating the need for cross-compilation or emulation, and lowers the cost-per-stream per hour by up to 30%.

The G5g instances are also a cost-effective platform for machine learning inference. They are ideal for deploying deep learning applications that need access to NVIDIA GPUs and their associated AI libraries.


## Linux Distribution Information ##
```
cat /etc/os-release

uname -m
```

## cuda driver install instruction ##

The GPG public key for the CUDA repository is currently listed as "d42d0685". This key is used to verify the authenticity of CUDA packages when installing them on Linux systems using package managers like "dnf". 
Key points about the CUDA GPG key:
Purpose:
It ensures that the CUDA packages you download are not tampered with and come from a trusted source. 
How to use:
When installing CUDA on a fresh Linux system, the package manager will usually prompt you to accept the new GPG key. 
Where to find it:
You can find the latest information about the CUDA GPG key in the NVIDIA CUDA installation guide for Linux

* The new GPG public key for the CUDA repository
  https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/3bf863cc.pub


```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/sbsa/cuda-keyring_1.1-1_all.deb

sudo dpkg -i cuda-keyring_1.1-1_all.deb
```

```
sudo apt-get update && \
sudo apt-get install -y cuda-toolkit && \
sudo apt-get install -y nvidia-gds

sudo reboot
```

## reference ##

* https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
