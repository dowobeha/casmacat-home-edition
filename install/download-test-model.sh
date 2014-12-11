#!/bin/sh

mkdir -p /opt/casmacat/engines

echo 'STEP 1/1: downloading '`date +%s`
if [ -d /opt/casmacat/engines/fr-en-upload-1 ]
then
  echo 'already downloaded'
  # delete and re-download?
else
  cd /opt/casmacat/engines

  # moses toy model
  wget http://www.casmacat.eu/uploads/toy-fr-en.tgz
  tar xzf toy-fr-en.tgz
  rm toy-fr-en.tgz

  # thot toy model
  wget http://www.casmacat.eu/uploads/thot-toy-fr-en.tgz
  tar xzf thot-toy-fr-en.tgz
  rm thot-toy-fr-en.tgz

  mkdir -p /opt/casmacat/engines/log
  echo "fr-en-upload-1" > /opt/casmacat/engines/deployed
  chown -R www-data:www-data /opt/casmacat/engines
fi
echo 'DONE '`date +%s`
