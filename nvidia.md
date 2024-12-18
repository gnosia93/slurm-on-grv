## G5g EC Instance ##
Amazon EC2 G5g instances are powered by AWS Graviton2 processors and feature NVIDIA T4G Tensor Core GPUs to provide the best price performance in Amazon EC2 for graphics workloads such as Android game streaming. They are the first Arm-based instances in a major cloud to feature GPU acceleration.

With G5g instances, game streaming customers can run Android games natively on Arm-based instances, encode the rendered graphics, and stream the game over network to a mobile device. This helps reduce development effort by eliminating the need for cross-compilation or emulation, and lowers the cost-per-stream per hour by up to 30%.

The G5g instances are also a cost-effective platform for machine learning inference. They are ideal for deploying deep learning applications that need access to NVIDIA GPUs and their associated AI libraries.


## Linux Distribution Information ##
```
cat /etc/os-release

uname -m

sudo lshw -C display
```

## cuda driver install instruction ##
### dnf ###
* The new GPG public key for the CUDA repository
  https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/3bf863cc.pub

### apt-get ##

```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/sbsa/cuda-keyring_1.1-1_all.deb && \
sudo dpkg -i cuda-keyring_1.1-1_all.deb

sudo apt-get update && \
sudo apt-get install -y cuda-toolkit && \
sudo apt-get install -y nvidia-gds

sudo reboot
```

```
sudo dpkg --install cuda-repo-<distro>-<version>.<architecture>.deb
sudo apt-key del 7fa2af80
wget https://developer.download.nvidia.com/compute/cuda/repos/<distro>/<arch>/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo add-apt-repository contrib
sudo apt-get update
sudo apt-get -y install cuda
```

```
sudo dpkg --install cuda-repo-ubuntu-20.04.1.sbsa.deb
sudo apt-key del 7fa2af80
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/sbsa/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo add-apt-repository contrib
sudo apt-get update
sudo apt-get -y install cuda
```


* https://hostkey.com/documentation/technical/gpu/nvidia_gpu_linux/#system-preparation
```

sudo apt install -y gcc


wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/arm64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update
sudo apt install cuda -y


echo 'export PATH="/sbin:/bin:/usr/sbin:/usr/bin:${PATH}:/usr/local/cuda/bin"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}' >> ~/.bashrc
source ~/.bashrc

sudo nvidia-smi
```

*** https://www.nvidia.com/en-us/drivers/
```
https://us.download.nvidia.com/tesla/565.57.01/nvidia-driver-local-repo-ubuntu2404-565.57.01_1.0-1_arm64.deb
```



## reference ##

* https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
