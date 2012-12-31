# Copyright (C) 2011-2012 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

# Démarrage par supervisor plutôt qu'autonome.
service=supervisord
cp -a memcached.ini /etc/supervisord.d/
change_svc memcached off
change_svc $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    :
else
    service $service start || exit $?
fi
