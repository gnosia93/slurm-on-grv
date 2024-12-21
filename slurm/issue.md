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

[[solution]](https://stackoverflow.com/questions/74038679/slurmd-error-couldnt-find-the-specified-plugin-name-for-cgroup-v2-looking-at)
```
I had the same problem. Slurm has support for both cgroup/v1 and v2, but support for v2 is only compiled in if the dbus development files are present. So first install dbus-devel

sudo apt install -y dnf
dnf install dbus-devel
and then run a clean Slurm build.
```
  * https://askubuntu.com/questions/1438828/dbus-package-installation-is-failing-in-ubuntu22-04-chroot-environment
   sudo apt-get install -y dbus
