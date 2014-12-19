#!/bin/sh

cd /opt/casmacat
git pull

cd install
export TIMESTAMP=`date +%s`;
export LOGDIR=/opt/casmacat/log/install/$TIMESTAMP
mkdir $LOGDIR

sh ./install-moses.sh > $LOGDIR/moses.out 2> $LOGDIR/moses.err &
sh ./install-casmacat.sh > $LOGDIR/casmacat.out 2> $LOGDIR/casmacat.err &
sh ./install-thot.sh > $LOGDIR/thot.out 2> $LOGDIR/thor.err &
sh ./install-casmacat-upvlc.sh > $LOGDIR/casmacat-upvlc.out 2> $LOGDIR/casmacat-upvlc.err &
