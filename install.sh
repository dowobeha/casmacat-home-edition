#!/bin/sh

apt-get -yq update
apt-get -yq install git
git clone https://github.com/casmacat/casmacat-home-edition.git /opt/casmacat
cd /opt/casmacat/install
sh install.sh
