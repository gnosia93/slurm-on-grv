


## slurm install ##

* Download source from https://www.schedmd.com/download-slurm/

* As of Dec 20 2024, version 24.11.0 is the lastest version, and download url is https://download.schedmd.com/slurm/slurm-24.11.0.tar.bz2  

* execute following commands in each node
  ```
  apt-get install build-essential fakeroot devscripts equivs
  tar -xaf slurm-24.11.0.tar.bz2
  cd slurm-24.11.0
  mk-build-deps -i debian/control
  debuild -b -uc -us
  ```

