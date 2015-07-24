#!/bin/sh

if [ $SUDO_USER ]; then user=$SUDO_USER; else user=`whoami`; fi

echo 'STEP 1/7: downloading moses '`date +%s`
if [ -d /opt/moses ]
then
  cd /opt/moses
  git pull
else
  git clone git://github.com/moses-smt/mosesdecoder.git /opt/moses
fi

# mGIZA -- should be removed soon
echo 'STEP 2/7: installing mgiza '`date +%s`
if [ -e /opt/moses/external/bin/mgiza ]
then
  echo 'mgiza already installed'
  cd /opt/moses/external/mgiza
  git pull
else
  cd /opt/moses/external
  git clone git://github.com/moses-smt/mgiza.git
fi
cd /opt/moses/external/mgiza/mgizapp
cmake .
make
mkdir -p /opt/moses/external/bin
cp bin/mkcls bin/snt2cooc /opt/moses/external/bin
cp bin/mgiza /opt/moses/external/bin
cp scripts/merge_alignment.py /opt/moses/external/bin

# online mGIZA -- should be removed soon
echo 'STEP 3/7: installing online mgiza '`date +%s`
if [ -e /opt/moses/external/bin/online-mgiza ]
then
  echo 'online mgiza already installed'
else
  cd /opt/moses/external
  wget http://www.casmacat.eu/uploads/mgiza-online.v0.7.3c.tgz 
  tar xzf mgiza-online.v0.7.3c.tgz
  cd mgiza-online.v0.7.3c
  cmake .
  make
  cp bin/mgiza /opt/moses/external/bin/online-mgiza
fi

# Fast Align
echo 'STEP 4/7: installing fast-align '`date +%s`
if [ -d /opt/moses/external/fast-align ]
then
  cd /opt/moses/external/fast-align
  git pull
  rm -rf /opt/moses/external/fast-align/build/*
else
  git clone git://github.com/clab/fast_align.git /opt/moses/external/fast-align
  mkdir /opt/moses/external/fast-align/build
fi
cd /opt/moses/external/fast-align/build
cmake ..
make
cp fast_align atools force_align.py /opt/moses/external/bin

# incremental Fast Align
#echo 'STEP 5/7: installing incremental fast-align (may take a while) '`date +%s`
#if [ -d /opt/moses/external/cdec ]
#then
#  cd /opt/moses/external/cdec
#  git pull
#else
#  git clone git://github.com/redpony/cdec.git /opt/moses/external/cdec
#fi
#cd /opt/moses/external/cdec
#cmake CMakeLists.txt
#make
#cp /opt/moses/external/cdec/word-aligner/fast_align /opt/moses/external/bin

# Moses
echo 'STEP 6/7: compiling moses (may take a while) '`date +%s`
cd /opt/moses
./bjam -j4 --with-xmlrpc-c=/usr --with-cmph=/usr --toolset=gcc --with-giza=/opt/moses/external/bin --with-tcmalloc=/usr --with-mm
chown -R $user:$user /opt/moses

# Experiment Web Interface
echo 'STEP 7/7: setting up experiment inspection '`date +%s`
if [ -e /opt/casmacat/admin/inspect/setup ]
then
  mv /opt/casmacat/admin/inspect/setup /tmp/save-setup
  cp -rp /opt/moses/scripts/ems/web /opt/casmacat/admin/inspect/inspect
  mv /tmp/save-setup /opt/casmacat/admin/inspect/setup
else
  cp -rp /opt/moses/scripts/ems/web /opt/casmacat/admin/inspect
  rm /opt/casmacat/admin/inspect/setup
  touch /opt/casmacat/admin/inspect/setup
fi
cp -p /opt/moses/bin/biconcor /opt/casmacat/admin/inspect
chown -R $user:$user /opt/casmacat/admin/inspect
echo 'DONE '`date +%s`

