# Collect rancheros info
I wrote a tool to collect diagnostic information for rancheros.
Mainly includes some ranchero logs and important configuration, and filtered out the ssh key.

| Collect items | 
| :------ |
|ros c export|
|ros -v|
|uname -r|
|dmesg|
|system-docker info|
|docker info|
|/proc/mounts|
|/proc/1/mounts|
|/proc/cmdline|
|/var/lib/rancher/conf|
|/usr/share/ros/os-config.yml|
|/var/log/boot|

## How to use
1. Login to your rancheros and switch to root
> Use this tool requires root privileges
```
$ sudo su - root
```
2. Collecting rancheros information
```
# curl https://raw.githubusercontent.com/kingsd041/rancheros/master/collect-rancheros-info.sh | sh
```

