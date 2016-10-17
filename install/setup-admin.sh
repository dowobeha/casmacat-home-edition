#!/bin/bash

if [ $SUDO_USER ]; then user=$SUDO_USER; else user=`whoami`; fi

echo 'STEP 1/2: installing apache '`date +%s`
cp apache-setup/casmacat-admin.conf /etc/apache2/sites-available
cd /etc/apache2/sites-enabled
if [ -e 000-default.conf ]
then
  ln -s ../sites-available/casmacat-admin.conf .
  rm 000-default.conf
fi
echo "export APACHE_RUN_USER=$user" >> /etc/apache2/envvars
echo "export APACHE_RUN_GROUP=$user" >> /etc/apache2/envvars
mkdir /opt/casmacat/data
mkdir /opt/casmacat/experiment
mkdir -p /opt/casmacat/log/web
chown -R $user:$user /opt/casmacat

echo 'STEP 2/2: restarting apache '`date +%s`
service apache2 restart

if [[ "$USER" != "$user" && "$DISPLAY" != "" && "$(which firefox)" != "" ]];
then
  killall -9 firefox
  firefox http://localhost/ &
fi

echo 'DONE '`date +%s`
