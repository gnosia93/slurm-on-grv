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
* https://slurm.schedmd.com/slurmstepd.html

[solution]

* [linux systemd 서비스 추가하기](https://velog.io/@kshired/linux-systemd-%EC%84%9C%EB%B9%84%EC%8A%A4-%EC%B6%94%EA%B0%80%ED%95%98%EA%B8%B0)
* https://serverfault.com/questions/1003056/why-does-slurm-fail-to-start-with-systemd-but-work-when-starting-manually

systemd service 파일을 만든다.
* `/lib/systemd/system/slurmd.service` 
```
[Unit]
Description=Slurm node daemon
After=network.target munge.service
ConditionPathExists=/usr/local/etc/slurm.conf
Documentation=man:slurmd(8)

[Service]
Type=forking
User=slurm
Group=slurm
ExecStart=/usr/local/sbin/slurmd --systemd
# ExecReload=/bin/kill -HUP $MAINPID
PIDFile=/run/munge/munged.pid
Restart=on-failure 

[Install]
WantedBy=multi-user.target
```

* `/lib/systemd/system/slurmctld.service` 
```
[Unit]
Description=Slurm controller daemon
After=network.target munge.service
ConditionPathExists=/usr/local/etc/slurm.conf
Documentation=man:slurmctld(8)

[Service]
Type=forking
User=slurm
Group=slurm
ExecStart=/usr/local/sbin/slurmctld $SLURMCTLD_OPTIONS
# ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure 

[Install]
WantedBy=multi-user.target
```
아래는 systemctl 이 제공하는 명령어 리스트이다. 
```
sudo systemctl daemon-reload
sudo systemctl reload service-name  
sudo systemctl start service-name         # 등록된 서비스 시작
sudo systemctl status service-name        # 등록된 서비스 상태 확인 
sudo systemctl stop service-name          # 등록된 서비스 종료 
sudo systemctl enable service-name        # 재부팅 후에도 서비스가 실행되도록 설정
sudo journalctl -u service-name           # 서비스와 관련된 로그 확인
```


