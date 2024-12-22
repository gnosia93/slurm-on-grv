## slurmd: error: Couldn't find the specified plugin name for cgroup/v2 looking at all files ##
[problem]
```
slurmd: debug:  Log file re-opened
slurmd: debug3: Trying to load plugin /usr/local/lib/slurm/cgroup_v2.so
slurmd: debug4: /usr/local/lib/slurm/cgroup_v2.so: Does not exist or not a regular file.
slurmd: error: Couldn't find the specified plugin name for cgroup/v2 looking at all files
slurmd: debug3: plugin_peek->_verify_syms: found Slurm plugin name:Cgroup v1 plugin type:cgroup/v1 version:0x180b00
slurmd: error: cannot find cgroup plugin for cgroup/v2
slurmd: error: cannot create cgroup context for cgroup/v2
slurmd: error: Unable to initialize cgroup plugin
slurmd: error: slurmd initialization failed
```

[solution]
아래 stackoverflow에서 해답을 찾을 수 있었다.   
https://stackoverflow.com/questions/14263390/how-to-compile-a-basic-d-bus-glib-example

```
sudo apt-get -y install dbus libdbus-1-dev libdbus-glib-1-2 libdbus-glib-1-dev
cd slurm-24.11.0
./configure --enable-cgroupv2
sudo make install
ls /usr/local/lib/slurm/cgroup_v2.so
```
/usr/local/lib/slurm/cgroup_v2.so


## slurmd: fatal: systemd scope for slurmstepd could not be set. ##
[problem]
```
slurmd: debug:  Log file re-opened
slurmd: debug3: Trying to load plugin /usr/local/lib/slurm/cgroup_v2.so
slurmd: debug3: plugin_load_from_file->_verify_syms: found Slurm plugin name:Cgroup v2 plugin type:cgroup/v2 version:0x180b00
slurmd: debug:  cgroup/v2: init: Cgroup v2 plugin loaded
slurmd: debug3: Success.
slurmd: fatal: systemd scope for slurmstepd could not be set.
```
[solution]

https://serverfault.com/questions/1003056/why-does-slurm-fail-to-start-with-systemd-but-work-when-starting-manually 


