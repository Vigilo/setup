#!/bin/sh

CONF=${CONF:-@SYSCONFDIR@/vigilo/setup/setup.conf}

if [ -f $CONF ]; then
    . $CONF
else
    echo "Can't find $CONF. Abort"
    exit 1
fi

# Tous les scripts doivent être idempotent.
# Ils seront lancés depuis leur répertoire.
vigilo_call_script() {
    script=$1
    pushd `dirname $script` > /dev/null
    . ./`basename $script`
    RETVAL=$?
    if [ $RETVAL != 0 ]; then
        echo "Script $script failed !"
        exit $RETVAL
    fi
    popd > /dev/null
}

# D'abord, les scripts qui n'utilisent pas les données installées localement
for script in `ls $SETUP_MODULES/{0,1,2}*/run.sh 2>/dev/null`; do
    vigilo_call_script $script
done

echo
echo "La suite de ce script va créer les utilisateurs et les bases. C'est le moment de changer les mots de passe par défaut. Pour cela, arrêtez ce script (Ctrl-C), changez les mots de passe dans /etc/vigilo/*/settings.ini et relancez ce script. Appuyez sur Entrée pour continuer avec les mots de passe par défaut." | fmt
read

# Ensuite, les scripts qui utilisent les données de configuration locales
# (notamment les mots de passe)
for script in `ls $SETUP_MODULES/{3,4,5,6,7,8,9}*/run.sh 2>/dev/null`; do
    vigilo_call_script $script
done


echo
echo "Maintenant, vérifiez dans /var/log/messages que tout s'est bien passé. Nagios devrait tourner."
echo "VigiBoard est accessible sur http://`hostname -f`/vigilo/vigiboard/"
echo "VigiMap est accessible sur http://`hostname -f`/vigilo/vigimap/"
echo "VigiGraph est accessible sur http://`hostname -f`/vigilo/vigigraph/"
