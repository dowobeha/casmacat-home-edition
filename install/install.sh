#!/bin/sh

if [ $SUDO_USER ]; then user=$SUDO_USER; else user=`whoami`; fi

export LOGDIR=/opt/casmacat/log/install/initial
INSTALL_MOSES=yes
INSTALL_THOT=yes

mkdir -p /opt/casmacat/install
cd /opt/casmacat/install
mkdir -p $LOGDIR


bash ./install-dependencies.sh > $LOGDIR/dependencies.out 2> $LOGDIR/dependencies.err
chown -R $user:$user /opt/casmacat
bash ./setup-admin.sh > $LOGDIR/admin.out 2> $LOGDIR/admin.err &
bash ./install-dependencies2.sh >> $LOGDIR/dependencies.out 2>> $LOGDIR/dependencies.err

if test "$INSTALL_MOSES" = "yes"; then 
  bash ./install-moses.sh > $LOGDIR/moses.out 2> $LOGDIR/moses.err &
  bash ./install-casmacat.sh > $LOGDIR/casmacat.out 2> $LOGDIR/casmacat.err &
  bash ./download-test-model.sh > $LOGDIR/test-model.out 2> $LOGDIR/test-model.err &
fi

if test "$INSTALL_THOT" = "yes"; then 
  bash ./install-casmacat-upvlc.sh > $LOGDIR/casmacat-upvlc.out 2> $LOGDIR/casmacat-upvlc.err 
  bash ./install-thot.sh > $LOGDIR/thot.out 2> $LOGDIR/thot.err 
fi
