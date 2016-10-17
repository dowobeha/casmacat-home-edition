#!/bin/sh

# installation of dependencies
# this has to be run by root
# so it cannot be updated via the web interface

# to download repositories
echo 'STEP 1/9: installing software to manage repositories '`date +%s`
apt-get -yq install git subversion

# web server
echo 'STEP 2/9: installing software for apache '`date +%s`
apt-get -yq install apache2
apt-get -yq install php7.0
apt-get -yq install php7.0-json
apt-get -yq install php7.0-mysql
apt-get -yq install libapache2-mod-php7.0

# needed to fullscreen firefox
apt-get -yq install xdotool
