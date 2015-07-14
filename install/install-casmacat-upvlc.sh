#!/bin/bash -x

if [ $SUDO_USER ]; then user=$SUDO_USER; else user=`whoami`; fi

# Install UPVLC CAT Server
echo 'STEP 1/2: downloading and installing cat server '`date +%s`
if [ -d /opt/casmacat/itp-server ]
then
  cd /opt/casmacat/itp-server
  git pull
else
  cd /opt/casmacat
  git clone git://github.com/casmacat/casmacat-thot-server.git itp-server
fi

echo 'STEP 2/2: downloading and installing cat server '`date +%s`
cd /opt/casmacat/itp-server
bash autogen.sh
./configure
make
ln -sf /opt/casmacat/itp-server/src/lib/.libs/_casmacat.so /opt/casmacat/itp-server/server/_casmacat.so
echo 'PYTHONPATH=/opt/casmacat/itp-server/src/lib:/opt/casmacat/itp-server/src/python:$PYTHONPATH LD_LIBRARY_PATH=/opt/casmacat/itp-server/src/lib/.libs /opt/casmacat/itp-server/server/casmacat-server.py -c $1 $2' > /opt/casmacat/admin/scripts/itp-server.sh

#echo 'STEP 3/3: downloading example models '`date +%s`
#if [ ! -d /opt/casmacat/engines/eutt2-demo ]; then
#  cd /opt/casmacat/engines
#  wget http://casmacat.prhlt.upv.es/mail-demo/eutt2-demo.tbz2 -O eutt2-demo.tbz2
#  tar -xjvf eutt2-demo.tbz2
#  sed -i -re 's#<MODELS>#/opt/casmacat/engines/eutt2-demo#g' /opt/casmacat/engines/eutt2-demo/eutt2-es-en{,-thot}.cfg
#  sed -i -re 's#<PLUGINS>#/opt/casmacat/itp-server/src/lib/.libs#g' /opt/casmacat/engines/eutt2-demo/eutt2-es-en{,-thot}.cfg
#  sed -i -re 's#<THOT>#/opt/thot#g' /opt/casmacat/engines/eutt2-demo/eutt2-es-en{,-thot}.cfg
#fi

chown -R $user:$user /opt/casmacat/itp-server

echo 'DONE '`date +%s`

