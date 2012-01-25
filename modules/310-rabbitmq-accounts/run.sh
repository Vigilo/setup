#!/bin/sh

[ -f /etc/init.d/rabbitmq-server ] || exit 0

echo "Création des comptes sur le bus"
chkconfig rabbitmq-server on
service rabbitmq-server status &> /dev/null || service rabbitmq-server start || exit $?
sleep 5
rabbitmqctl add_user vigilo-admin vigilo-admin || :

CONNECTORS="connector-diode connector-nagios connector-metro connector-syncevents connector-script correlator vigiconf vigiconf-hls"

for connector in $CONNECTORS; do
    settings_files=`fgrep -l '[bus]' /etc/vigilo/$connector/*.ini`
    if [ -z "$settings_files" ]; then
        rabbitmqctl add_user $connector $connector || :
    else
        for settings_file in $settings_files; do
            username=`vigilo-config -s bus -g user $settings_file 2>/dev/null || :`
            password=`vigilo-config -s bus -g password $settings_file 2>/dev/null || :`
            rabbitmqctl add_user $username $password || :
        done
    fi
done
