#!/usr/bin/env bash
set -x

#Dirty trick to cheat vmWare
# More details: https://cstan.io/?p=12416&lang=en
(echo "SUSE Linux Enterprise Server 15") > /etc/issue.d/00-vmware_fix
