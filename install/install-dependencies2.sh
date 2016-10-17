#!/bin/bash

# installation of dependencies
# this has to be run by root
# so it cannot be updated via the web interface

# mysql
echo 'STEP 3/9: installing software for database '`date +%s`
export DEBIAN_FRONTEND=noninteractive
apt-get -yq install mysql-client-core-5.7
apt-get -yq install mysql-server

# needed for cat server
echo 'STEP 4/9: installing software for cat server '`date +%s`
apt-get -yq install python-tornado

# needed for mt server
echo 'STEP 5/9: installing software for mt server '`date +%s`
apt-get -yq install python-pip
apt-get -yq install python-levenshtein
pip install -U CherryPy socketIO-client

# needed to compile
echo 'STEP 6/9: installing c++ compiler '`date +%s`
apt-get -yq install g++
apt-get -yq install libboost-all-dev automake xmlrpc-api-utils libtool libzip-dev libbz2-dev libxmlrpc-c++8v5 libxmlrpc-c++8-dev libgoogle-perftools-dev libcmph-dev cmake

# dependencies of moses tools
echo 'STEP 7/9: installing software for moses tools '`date +%s`
apt-get -yq install imagemagick graphviz
# Perl library needed for NIST BLEU
/opt/casmacat/install/cpanm XML::Twig

# dependecies for fast_align
apt-get -yq install libeigen3-dev liblzma-dev flex

# needed for thot / itp server
echo 'STEP 8/9: installing software for thot '`date +%s`
apt-get -yq install libtool pkg-config autoconf-archive swig python-dev libperl-dev

# not really needed, but handy
echo 'STEP 9/9: installing additional optional software '`date +%s`
apt-get -yq install ssh

echo 'DONE '`date +%s`
