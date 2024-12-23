* https://bgreat.tistory.com/185


## install with apt ##

```
sudo apt install -y munge libmunge-dev               # all server.
sudo /usr/sbin/mungekey                              # make key in master server and copy /etc/munge/munge.key to all server

sudo chown munge:munge /etc/munge/munge.key          # all server
sudo chmod 400 /etc/munge/munge.key                  # all server
```












## Super Quick Start ##

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
     slurmctld -D -vvvvvv
     ```
   * Worker Node
     ```
     slurmd -D -vvvvvv
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
