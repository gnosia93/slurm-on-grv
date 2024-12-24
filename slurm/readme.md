## [Install /w apt](https://bgreat.tistory.com/185) ##


### 1. append node hostname ###


[/etc/hosts]
```
10.0.101.186 sl-mst
10.0.100.182 sle-w1
10.0.100.20  sle-w2
```

### 2. install munge and slurm ###
```
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

* (optional) check passwd and shadow file
[passwd]
```
munge:x:117:122::/nonexistent:/usr/sbin/nologin               
slurm:x:64030:64030::/nonexistent:/usr/sbin/nologin
```
[shadow]
```
munge:*:20080:0:99999:7:::
slurm:*:20080:0:99999:7:::
```

[/etc/slurm/slurm.conf] 
```
sudo vi /etc/slurm/slurm.conf
```
* must exists in all nodes
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
NodeName=sle-w[1-2] CPUs=8 Boards=1 SocketsPerBoard=1 CoresPerSocket=8 ThreadsPerCore=1 RealMemory=15672     # slurmd -C in worker node
PartitionName=debug Nodes=sle-w[1-2] Default=YES MaxTime=INFINITE State=UP
```

[/etc/slurm/cgroup.conf] 
* must exist in all nodes, for GPU node cgroup_allowed_devices_file.conf is required
```
CgroupAutomount=yes 
CgroupReleaseAgentDir="/etc/slurm/cgroup" 
ConstrainCores=yes 
ConstrainRAMSpace=yes 
ConstrainDevices=yes 
#AllowedDevicesFile="/etc/slurm-llnl/cgroup_allowed_devices_file.conf"           # for GPU node, uncomment this line
```

[/etc/slurm/cgroup_allowed_devices_file.conf] 
* must exist in all nodes in case of using GPU, and not required for CPU
```
/dev/nvidiactl 
/dev/nvidia-uvm 
/dev/nvidia0 
/dev/nvidia1 ...
```

start slurmctld and slurmd daemon.
```
ubuutu$ sudo slurmctld -D -vvvvvv                 # unbutu 로 실행하면 에러가 발생한다. 
ubuntu$ sudo slurmd -D -vvvvvv 
```
```
$ ubuntu ps aux | grep slurmctld
root       46685  0.0  0.0 280808  5668 ?        Sl   17:02   0:00 slurmctld -vvvvvv
```

* Master Node
     ```
     sudo slurmctld -D -vvvvvv
     ```
* Worker Node
     ```
     sudo slurmd -D -vvvvvv
     ```






## Install /w source ##

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


 
## reference ##
* https://slurm.schedmd.com/quickstart_admin.html
* https://github.com/lopentusska/slurm_ubuntu_gpu_cluster
* https://github.com/nateGeorge/slurm_gpu_ubuntu?tab=readme-ov-file
* https://github.com/mknoxnv/ubuntu-slurm
