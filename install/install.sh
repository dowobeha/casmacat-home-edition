#!/bin/sh

INSTALL_MOSES=no
INSTALL_THOT=yes

cd /opt/casmacat/install
mkdir -p log/install

sh ./install-dependencies.sh > log/install/dependencies.out 2> log/install/dependencies.err
chown -R www-data:www-data /opt/casmacat
sh ./install-admin.sh > log/install/admin.out 2> log/install/admin.err &

sh ./install-dependencies2.sh >> log/install/dependencies.out 2>> log/install/dependencies.err

if test "$INSTALL_MOSES" = "yes"; then 
  sh ./install-moses.sh > log/install/moses.out 2> log/install/moses.err &
  sh ./install-casmacat.sh > log/install/casmacat.out 2> log/install/casmacat.err &
  sh ./download-test-model.sh > log/install/test-model.out 2> log/install/test-model.err &
fi

if test "$INSTALL_THOT" = "yes"; then 
  sh ./install-casmacat-upvlc.sh > log/install/casmacat-upvlc.out 2> log/install/casmacat-upvlc.err 
  sh ./install-thot.sh > log/install/thot.out 2> log/install/thot.err 
fi
