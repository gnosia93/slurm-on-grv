* slurmd - cgroup namespace 'freezer' not mounted. aborting

[problem]
```
slurmd: debug3: Trying to load plugin /usr/local/lib/slurm/proctrack_cgroup.so
slurmd: debug3: plugin_load_from_file->_verify_syms: found Slurm plugin name:Process tracking via linux cgroup freezer subsystem type:proctrack/cgroup version:0x180b00
slurmd: error: unable to open '/sys/fs/cgroup/freezer//tasks' for reading : No such file or directory
slurmd: error: cgroup namespace 'freezer' not mounted. aborting
slurmd: error: unable to create freezer cgroup namespace
slurmd: error: Couldn't load specified plugin name for proctrack/cgroup: Plugin init() callback failed
slurmd: error: cannot create proctrack context for proctrack/cgroup
slurmd: error: slurmd initialization failed
```

[[solution]](https://stackoverflow.com/questions/62641323/error-cgroup-namespace-freezer-not-mounted-aborting)
```
A simple /etc/slurm/cgroup.conf with:

CgroupAutomount=yes
ConstrainCores=no
ConstrainRAMSpace=no
```

* /usr/local/lib/slurm/cgroup_v2.so: Does not exist or not a regular file.
[problem]
```
slurmd: error: The option "CgroupAutomount" is defunct, please remove it from cgroup.conf.
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
```
아래 stackoverflow에서 해답을 찾을 수 있었다.
https://stackoverflow.com/questions/14263390/how-to-compile-a-basic-d-bus-glib-example
 
sudo apt-get -y install dbus libdbus-1-dev libdbus-glib-1-2 libdbus-glib-1-dev
slurm recompile with configure
```


