#!/usr/bin/env bash
set -x

/bin/systemctl stop rsyslog.service
/sbin/service auditd stop
/usr/sbin/logrotate -f /etc/logrotate.conf

# Remove traces of MAC address and UUID from network configuration
sed -E -i '/^(HWADDR|UUID)/d' /etc/sysconfig/network-scripts/ifcfg-e*

# Disable udev network rules
rm -f /etc/udev/rules.d/70-persistent-net.rules;

# Clean up zypper
zypper --non-interactive rm --clean-deps gcc kernel-default-devel
zypper clean -all

# Remove ssh host keys
rm -rf /etc/ssh/ssh_host*_key*

# Clean up /root
rm -f /root/anaconda-ks.cfg
rm -f /root/install.log
rm -f /root/install.log.syslog
rm -rf /root/.pki
/bin/rm -rf ~root/.ssh/
rm -f /root/original-ks.cfg

# Clean up /var/log
find /var/log -type f -exec truncate --size=0 {} \;

# Clean /tmp
rm -rf /tmp/* /var/tmp/*

# Blank netplan machine-id (DUID) so machines get unique ID generated on boot
truncate -s 0 /etc/machine-id

# Force a new random seed to be generated
if [ -f /var/lib/misc/random-seed ]; then
  rm /var/lib/misc/random-seed
fi
if [ -f /var/lib/systemd/random-seed ]; then
  rm /var/lib/systemd/random-seed
fi

#cleanup current ssh keys
sudo rm -f /etc/ssh/ssh_host_*

# Zero out the free space to save space in the final image
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Clear history
rm -f /root/.wget-hsts
export HISTSIZE=0
