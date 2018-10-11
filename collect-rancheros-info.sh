#!/bin/sh

set -e
# Boot log directory
boot_log_src_dir=/var/log/boot
# Rancher config file directory
conf_file_src_dir=/var/lib/rancher/conf
# Os-config directory
os_config_dir=/usr/share/ros/os-config.yml
# Export directory
dest_dir=/tmp/ros
# Exported log directory
dest_log_dir=$dest_dir/roslogs
# Exported config directory
dest_conf_dir=$dest_dir/rosconf

DATE=`date +%Y_%m_%d_%H`
ARCHIVE=$DATE.tar

# Create destination directory
for i in $dest_conf_dir $dest_log_dir;
do
  if [ ! -d $i ]; then
    mkdir -p  $i
  fi
done


# Hidden ssh-rsa
hiddenSshRsa(){
     sed -i 's/ssh-rsa.*$/ssh-rsa .../g' $1
}

# Export boot log
cp -arf $boot_log_src_dir $dest_log_dir
# Export rancheros config
ros c export -o $dest_conf_dir/ros-config-export.conf
ros -v > $dest_conf_dir/ros-version
uname -r > $dest_conf_dir/kernel-version
system-docker info > $dest_conf_dir/system-docker-info
docker info > $dest_conf_dir/docker-info
cat /proc/mounts > $dest_conf_dir/proc-mounts
cat /proc/1/mounts > $dest_conf_dir/proc-1-mounts
cat /proc/cmdline > $dest_conf_dir/cmdline
dmesg > $dest_conf_dir/dmesg.log
#ls $conf_file_src_dir | \
#        grep -v "pem" | \
#        xargs -i cp -r $conf_file_src_dir/{} $dest_conf_dir
cd $conf_file_src_dir && cp -rf `ls  | grep -E -v "^(pem)$"` $dest_conf_dir
cp -arf $os_config_dir $dest_conf_dir

hiddenSshRsa $dest_conf_dir/ros-config-export.conf
if [ -f  $dest_conf_dir/metadata ]; then
    hiddenSshRsa $dest_conf_dir/metadata
fi

tar -c -f /tmp/rancheros_export_$ARCHIVE -C $dest_dir  . >/dev/null 2>&1

/bin/echo -e "\n"
/bin/echo -e "The RancherOS config and log are successfully exported. \
\nPlease check the /tmp/rancheros_export_$ARCHIVE."

