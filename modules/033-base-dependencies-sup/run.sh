#!/bin/sh

urpmi   nagios \
        nagios-www \
        nagios-check_nrpe \
        nagios-check_ntp \
        net-snmp \
        patch \
        nrpe \
        vigilo-nagios-plugins-cpu \
        vigilo-nagios-plugins-raid \
        glibc-devel
# glibc-devel : pour eviter un choix interactif après



