## 1. [Install using apt](https://bgreat.tistory.com/185) ##


### 1-1. append node hostname ###
FQDN is preferred, but if you are using AWS, you just need to set private IP with hostname.

[/etc/hosts]
```
10.0.101.186 sl-mst
10.0.100.182 sle-w1
10.0.100.20  sle-w2
```

```
sudo hostnamectl set-hostname ${HOST_NAME}
```


### 1-2. install munge and slurm ###
```
sudo systemctl mask packagekit                       # all nodes

sudo apt install -y munge libmunge-dev               # all nodes
sudo /usr/sbin/mungekey                              # make key in master node 
sudo cp /etc/munge/munge.key /mnt/efs                # copy /etc/munge/munge.key to worker nodes
sudo cp /mnt/efs/munge.key /etc/munge/munge.key      

sudo chown munge:munge /etc/munge/munge.key          # all nodes
sudo chmod 400 /etc/munge/munge.key                  # all nodes
sudo systemctl enable munge                          # all nodes
sudo systemctl start munge                           # all nodes

sudo apt install -y slurm-wlm                        # master
sudo apt install -y slurmd                           # worker nodes

sudo mkdir /var/spool/slurm && \                     # all nodes
sudo chown slurm:slurm /var/spool/slurm && \
sudo chmod 777 /var/spool/slurm
```

### 1-3. make configuration at all nodes ###

**[/etc/slurm/slurm.conf]**
```
ControlMachine=sl-mst                      # hostname of master node
AuthType=auth/munge                        # authentification with munge
SlurmdPort=6818                            # slurm daemon port
SlurmctldPort=6817                         # slurm controller daemon port 

StateSaveLocation=/var/spool/slurm/state              # at the install time, not yet created
SlurmdSpoolDir=/var/spool/slurm

# 작업 자격 증명에 사용할 키 설정 
JobCredentialPrivateKey=/var/spool/slurm/cred_priv.pem 
JobCredentialPublicCertificate=/var/spool/slurm/cred_pub.pem 
                      
SlurmdLogFile=/var/log/slurm/slurmd.log                    # at the install time, /var/log/slurm exists, slurm directory mode is 777
SlurmctldLogFile=/var/log/slurm/slurmctld.log 
SlurmctldPidFile=/var/log/slurm/slurmctld.pid
SlurmdPidFile=/var/log/slurm/slurmd.pid

ProctrackType=proctrack/cgroup 
ReturnToService=1 
SchedulerType=sched/backfill 

SlurmdTimeout=300 
SlurmctldTimeout=300 
SelectType=select/cons_tres 
SelectTypeParameters=CR_Core_Memory 
TaskPlugin=task/affinity 

ClusterName=workshop

NodeName=slc-wg[1-2] CPUs=4 Boards=1 SocketsPerBoard=1 CoresPerSocket=4 ThreadsPerCore=1 RealMemory=7763     # slurmd -C in worker node

GresTypes=gpu
NodeName=slc-wn[1-2] Gres=gpu:1 CPUs=4 Boards=1 SocketsPerBoard=1 CoresPerSocket=4 ThreadsPerCore=1 RealMemory=7763     # slurmd -C in worker node

PartitionName=graviton Nodes=sle-wg[1-2] Default=YES MaxTime=INFINITE State=UP
PartitionName=nvidia Nodes=slx-wn[1-2] Default=YES MaxTime=INFINITE State=UP
```
Type slurmd -C at worker node to retrieve hardware spec for `NodeName` in slurm.conf.


**[/etc/slurm/cgroup.conf]** 
* must exist in all worker nodes, for GPU node cgroup_allowed_devices_file.conf is required
```
CgroupAutomount=yes 
CgroupReleaseAgentDir="/etc/slurm/cgroup" 
ConstrainCores=yes 
ConstrainRAMSpace=yes 
ConstrainDevices=yes 
```

**[/etc/slurm/gres.conf]** 
* must exist in worker nodes having GPU
```
#AutoDetect=nvml
NodeName=slx-w1 Name=gpu File=/dev/nvidia0
NodeName=slx-w2 Name=gpu File=/dev/nvidia0
```
In the Linux /dev directory, an Nvidia device will typically be named something like /dev/nvidia0, /dev/nvidia1, or similar, depending on the number of Nvidia GPUs present in the system; essentially, any file starting with "nvidia" within the /dev directory indicates an Nvidia device


### 1-4. start slurm ###

start slurmctld at master and slurmd daemon at worker nodes.

* master node
```
sudo slurmctld -D -vvvvvv                  
```
* worker node
```
sudo slurmd -D -vvvvvv 
```

### 1-5. slurm client node ###
```
sudo apt install slurm-client
```


### 1-6. Add Nvidia GPU Node ###
#### 1-6-1. add ppa repository ####
```
sudo add-apt-repository ppa:graphics-drivers/ppa --yes
sudo apt update
apt search nvidia-driver
```

```
...

nvidia-driver-565/jammy 565.77-0ubuntu0~gpu22.04.1 arm64
  NVIDIA driver metapackage

nvidia-driver-565-open/jammy 565.77-0ubuntu0~gpu22.04.1 arm64
  NVIDIA driver (open kernel) metapackage

nvidia-driver-565-server/jammy-updates 565.57.01-0ubuntu0.22.04.4 arm64
  NVIDIA Server Driver metapackage

nvidia-driver-565-server-open/jammy-updates 565.57.01-0ubuntu0.22.04.4 arm64
  NVIDIA driver (open kernel) metapackage
```
The main differences that I can identify (from the Ubuntu package lists) are the following:

* NVIDIA drivers have the full set of packages, and is supported for up to 1 year (oldest version right now is 470 - previous versions point to this release).
* NVIDIA server drivers have the full set of packages as well, and is supported up to 2 years (oldest version right now is 450 - previous versions point to this release).
* NVIDIA headless drivers are a small subset, meant only for GPU computational tasks (but not graphics display). This package is also supported for up to 1 year (oldest version is 470).


#### 1-6-2 install nvidia driver with latest version ####
```
sudo apt install -y nvidia-driver-565
sudo apt install -y nvidia-cuda-toolkit
sudo apt install -y nvidia-utils-565
```

![](https://github.com/gnosia93/slurm-on-grv/blob/main/slurm/images/nvidia-smi.png)

![](https://github.com/gnosia93/slurm-on-grv/blob/main/slurm/images/nvidia-lshw.png)

#### [1-6-3 add gpu information](https://slurm.schedmd.com/gres.html) ####

* https://stackoverflow.com/questions/76492996/how-to-add-nvidia-gpu-on-slurm-conf-and-gres-conf

* check if nvml library is installed.
```
ldconfig -p | grep libnvidia-ml.so
```

```
sinfo -o "%20N  %10c  %10m  %25f  %10G "
NODELIST              CPUS        MEMORY      AVAIL_FEATURES             GRES
slx-w[1-2]            4           7763        (null)                     (null)
```
```
scontrol show nodes 

```







## 2. Install From Source ##

* Make sure the clocks, users and groups (UIDs and GIDs) are synchronized across the cluster.
    * clocks (time) synchronization is fullfilled usually by NTP, but when you are using public cloud service such as AWS, you don't need to setup clocks synchronization.
    * The SlurmUser must exist prior to starting Slurm and must exist on all nodes of the cluster.
        ```
        sudo addgroup -gid 1111 munge
        sudo addgroup -gid 1121 slurm
        sudo adduser -u 1111 munge --disabled-password --gecos "" -gid 1111
        sudo adduser -u 1121 slurm --disabled-password --gecos "" -gid 1121
        ```  

* Install MUNGE for authentication. Make sure that all nodes in your cluster have the same munge.key. Make sure the MUNGE daemon, munged, is started before you start the Slurm daemons.
    * Install munge on the master:
        ```
        sudo apt-get install libmunge-dev libmunge2 munge -y
        sudo systemctl enable munge
        sudo systemctl start munge
        
        sudo cp /etc/munge/munge.key /storage/            # /storage is nfs mount path
        sudo chown munge /storage/munge.key
        sudo chmod 400 /storage/munge.key
        ```
    * Install munge on worker nodes:
        ```
        sudo apt-get install libmunge-dev libmunge2 munge
        sudo cp /storage/munge.key /etc/munge/munge.key
        sudo systemctl enable munge
        sudo systemctl start munge
        ```
  
* Build Manually from source (for developers or advanced users)
  * NOTE: The parent directories for Slurm's log files, process ID files, state save directories, etc. are not created by Slurm. They must be created and made writable by SlurmUser as needed prior to starting Slurm daemons.
  * Download source from https://www.schedmd.com/download-slurm/
  * As of Dec 20 2024, version 24.11.0 is the lastest version, and download url is https://download.schedmd.com/slurm/slurm-24.11.0.tar.bz2  

      ```
      sudo apt-get -y install dbus libdbus-1-dev libdbus-glib-1-2 libdbus-glib-1-dev

      curl https://download.schedmd.com/slurm/slurm-24.11.0.tar.bz2 -o slurm-24.11.0.tar.bz2
      tar -xaf slurm-24.11.0.tar.bz2
      cd slurm-24.11.0
      ./configure --enable-cgroupv2
      sudo make install
      ```

* Visit [Slurm Configuration Tool](https://slurm.schedmd.com/configurator.html) and make slurm.conf as you wish

* Install the configuration file in
   * `<sysconfdir>`/slurm.conf
     * NOTE: You will need to install this configuration file on all nodes of the cluster.
     * `<sysconfdir>` is /usr/local when you compile source code unless you set prefix during compile
     * see https://slurm.schedmd.com/slurm.conf.html
       
   * `<sysconfdir>`/gres.conf
     * NOTE: You will need to install this configuration file on all nodes of the cluster.
     * gres.conf is located in same directory with slurm.conf
     * see https://slurm.schedmd.com/gres.conf.html
     * gres.conf
        ```
        AutoDetect=nvml
        ```
   * `<sysconfdir>`/cgroup.conf
      * cgroup.conf is located in same directory with slurm.conf
      * see https://slurm.schedmd.com/cgroup.conf.html
      * Check the installed version of cgroup
        ```
        $ mount | grep cgrou
        cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,nsdelegate,memory_recursiveprot)
        ```
         

* Make logfile and spool directory.
    * Master Node 
      * /var/log/slurmctld.log (owner - slurm, mode - 0664)
      * /var/run/slrumctld.pid (owner - slurm, mode - 0664)
      * /var/spool/slurmctld (owner - slurm, mode - 0777)
    * Worer Node
      * /var/log/slurmd.log (owner - slurm, mode - 0664)
      * /var/run/slurmd.pid (owner - slurm, mode - 0664)
      * /var/spool/slurmd (owner - slurm, mode - 0777)

* [Starting the Daemons (optional and for debug)](https://slurm.schedmd.com/quickstart_admin.html#starting_daemons)
   * Master Node
     ```
     sudo slurmctld -D -vvvvvv
     ```
   * Worker Node
     ```
     sudo slurmd -D -vvvvvv
     ```
  
* systemd (optional): enable the appropriate services on each system:
  * Controller: sudo systemctl enable slurmctld
  * Database: sudo systemctl enable slurmdbd
  * Compute Nodes: sudo systemctl enable slurmd

* Start the slurmctld and slurmd daemons.
  * eg. sudo systemctl start slurmctld


## 레퍼런스 ##

* https://blog.liam.kim/posts/2024/05/Slurm-Setup-Guide/

