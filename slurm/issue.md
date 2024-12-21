* slurmd - cgroup namespace 'freezer' not mounted. aborting
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
