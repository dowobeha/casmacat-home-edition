#!/usr/bin/perl -w

use strict;
use Getopt::Long "GetOptions";

my ($F,$E,$RUN,$NAME) = @_;
my %LINE_COUNT;

die unless &GetOptions('run=i' => \$RUN,
		       'f=s' => \$F,
		       'name=s' => \$NAME,
		       'e=s' => \$E);
die unless defined($F) && defined($E) && defined($RUN);
$NAME = "unnamed" unless defined($NAME) && $NAME !~ /^\s*$/;

# directories
my $engine_dir = "/opt/casmacat/engines";
my $exp_dir = "/opt/casmacat/experiment/$F-$E";
my $data_dir = $exp_dir."/data";

# create directory for engine
my $engine = "$F-$E-$RUN";
my $dir = "$engine_dir/$engine";
`mkdir $dir`;

open(INFO,">$dir/info");
print INFO "source = $F\n";
print INFO "target = $E\n";
print INFO "run = $RUN\n";
print INFO "name = $NAME\n";
print INFO "time_started = ".time()."\n";
print INFO "time_done = ".time()."\n";
print INFO "time_built = ".time()."\n";
close(INFO);

# get information about models that were built
my %STEP; # maps steps to run that was used
open(STEP,"ls $exp_dir/steps/$RUN/*INFO|");
while(<STEP>) {
  /\/([^\/]+)\.\d+\.INFO/;
  $STEP{$1} = $RUN;
  #print "from info: $1 -> $RUN\n";
}
close(STEP);

open(RE_USE,"$exp_dir/steps/$RUN/re-use.$RUN");
while(<RE_USE>) {
  chop;
  s/\:/\_/g;
  my($step,$run) = split;
  $STEP{$step} = $run;
  #print "from re-use: $step -> $run\n";
}
close(RE_USE);

# copy phrase table
`cp -r $exp_dir/tuning/thot.tuned.ini.$STEP{"TUNING_thot-tune"}/tm $dir`;

# copy language model
`cp -r $exp_dir/tuning/thot.tuned.ini.$STEP{"TUNING_thot-tune"}/lm $dir`;

# copy truecase model
if (defined($STEP{"TRUECASER_train"})) {
  `cp $exp_dir/truecaser/truecase-model.$STEP{"TRUECASER_train"}.* $dir`;
}


# copy and adjust paths in configuration files
my $tune_dir = "$exp_dir/tuning/thot.tuned.ini.".$STEP{"TUNING_thot-tune"};

my %CONFIG = ("$tune_dir/tuned_for_dev.cfg" => "$dir/thot.tuned.ini",
              "$tune_dir/lm/lm_desc"        => "$dir/lm/lm_desc",
              "$tune_dir/tm/tm_desc"        => "$dir/tm/tm_desc");

foreach my $file (keys %CONFIG) {
  my @FILE = `cat $file` || die($file);
  open(OUT,">".$CONFIG{$file});
  foreach (@FILE) {
    s/$tune_dir/$dir/g;
    print OUT $_;
  }
  close(OUT);
}

# create itp server configuration file
open(OUT,">$dir/itp-server.conf");
print OUT <<"END_OF_FILE";
{
  "server": {
    "port": 4501
  },
  "mt": {
    "id": "PE",
    "ref": "ITP"
  },
  "imt": {
    "id": "ITP",
    "module": "/opt/thot/lib/libthot_casmacat.so", 
    "name": "thot_imt_plugin",
    "parameters": "-c $dir/thot.tuned.ini",
    "online-learning": true
  },
  "aligner": {
    "module": "/opt/thot/lib/libthot_casmacat.so", 
    "name": "thot_align_plugin",
    "parameters": "$dir/tm/main/src_trg_invswm",
    "online-learning": true
  },
  "confidencer": {
    "module": "/opt/thot/lib/libthot_casmacat.so", 
    "name": "thot_cm_plugin",
    "parameters": "$dir/tm/main/src_trg_invswm",
    "thresholds": [3, 30],
    "online-learning": true
  },
  "word-prioritizer": [ ],
  "source-processor": {
    "module": "/opt/casmacat/itp-server/src/lib/.libs/perl-tokenizer.so", 
    "parameters": "/opt/casmacat/itp-server/src/lib/processor.perl -l $F -d /opt/moses/scripts/share -c $dir/truecase-model.$STEP{"TRUECASER_train"}.$F"
  },
  "target-processor": {
    "module": "/opt/casmacat/itp-server/src/lib/.libs/perl-tokenizer.so", 
    "parameters": "/opt/casmacat/itp-server/src/lib/processor.perl -l $E -d /opt/moses/scripts/share  -c $dir/truecase-model.$STEP{"TRUECASER_train"}.$E"
  },
  "sentences": [ ]
}
END_OF_FILE
close(OUT);

# create run file
open(RUN,">$dir/RUN");
print RUN <<"END_OF_FILE";
#!/bin/bash

#! /bin/bash

export ROOTDIR=/opt/casmacat
export LOGDIR=\$ROOTDIR/log/mt

mkdir -p \$LOGDIR

killall -9 mosesserver
killall -9 online-mgiza
killall -9 symal
kill -9 `ps -eo pid,cmd -C python | grep 'python /opt/casmacat/mt-server/python_server/server.py' | grep -v grep | cut -c1-5`

kill -9 `ps -eo pid,cmd -C python | grep 'python /opt/casmacat/itp-server/server/casmacat-server.py' | grep -v grep | cut -c1-5`

if test "\$1" != "stop"; then 
  export PYTHONPATH=/opt/casmacat/itp-server/src/lib:/opt/casmacat/itp-server/src/python:\$PYTHONPATH 
  export LD_LIBRARY_PATH=/opt/casmacat/itp-server/src/lib/.libs 
  /opt/casmacat/itp-server/server/casmacat-server.py -c $dir/itp-server.conf \$2 \\
    >  \$LOGDIR/$engine.thot.stdout \\
    2> \$LOGDIR/$engine.thot.stderr &
fi
END_OF_FILE
close(RUN);
`chmod +x $dir/RUN`;

my $size = `du -hd0 $dir`;
chop($size);
$size =~ s/^(\S+)\s.+$/$1/;
open(INFO,">>$dir/info");
print INFO "size = $size\n";
close(INFO);

