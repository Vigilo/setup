#!/bin/sh
# Copyright (C) 2011-2012 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

echo "Configuration de SNMPd"

cfgpatch=snmpd.$DISTRO.patch

[ -f /etc/snmp/snmpd.conf.orig ] || patch -N -b /etc/snmp/snmpd.conf < $cfgpatch

