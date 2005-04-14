#!/bin/bash
# $Id$

echo
echo "+-------------------------------------+"
echo "|    MoniWiki configuration script    |"
echo "+-------------------------------------+"
echo

RETVAL=1
while [ ! $RETVAL -eq 0 ]; do
  echo -n " Please enter the permission 777 or 2777(default 2777): "
  read PERM
  if [ x$PERM = x ]; then
    PERM=2777
  fi

  if [ ! -f config.php ]; then
    echo "*** chmod $PERM . data"
    chmod $PERM . data
    RETVAL=$?
  else
    RETVAL=0
  fi
done

if [ ! -f config.php ]; then
  echo 'Please open monisetup.php on your browser'
  exit;
else
  echo "*** chmod 777 config.php"
  chmod 777 config.php 2>/dev/null
  RETVAL=$?
  [ ! $RETVAL -eq 0 ] && cp config.php config.php.$$ && mv config.php.$$ config.php && chmod 777 config.php

  DATA_DIR=`cat config.php |grep '$data_dir='|cut -d\' -f2`

  echo "*** chmod $PERM . $DATA_DIR"
  chmod $PERM . $DATA_DIR

  ID=`id -u`
  if [ $ID -eq 0 ]; then
    echo "*** You are the root user ***"
    PERM=755
  else
    echo -n " Did you really want to make directories with permission '$PERM'(N/y): "
    read say
    if [ x$say = x ]; then
      say='n'
    fi
    if [ x$say = x'n' ]; then
      echo ""
      echo "Please open monisetup.php again"
      echo ""
      exit
    fi
  fi  
fi


if [ ! -d $DATA_DIR/text ]; then
  echo " *** mkdir $DATA_DIR/{text,text/RCS,user,cache}"
  mkdir $DATA_DIR/{text,text/RCS,user,cache}
fi

if [ ! -d pds ]; then
  echo "*** mkdir pds"
  mkdir pds
fi

echo "*** chmod $PERM $DATA_DIR/{text,text/RCS,user,cache}"
chmod $PERM $DATA_DIR/{text,text/RCS,user,cache}
chmod $PERM pds
RETVAL=$?
if [ ! $RETVAL -eq 0 ]; then
  echo ""
  echo "---------------------------------------------------------"
  echo "You can not change some directories permission with $PERM"
  echo "since you make it with the monisetup with sgid enabled"
  echo "simply ignore above error messages :)"
  echo "---------------------------------------------------------"
  echo ""
fi

echo "*** chmod $PERM config.php"
chmod $PERM config.php 2>/dev/null
RETVAL=$?
[ ! $RETVAL -eq 0 ] && cp config.php config.php.$$ && mv config.php.$$ config.php
chmod $PERM config.php

if [ $ID -eq 0 ]; then
  RETVAL=1
  while [ ! $RETVAL -eq 0 ]; do
    echo -n " Please enter the Apache user ID (e.g. nobody): "
    read owner
    if [ x$owner = x ]; then
      owner=nobody
    fi
    chown $owner $DATA_DIR/{text,text/RCS,cache,user} &&
    chown $owner {$DATA_DIR,pds}
    RETVAL=$?
  done

  RETVAL=1

  while [ ! $RETVAL -eq 0 ]; do
    echo -n " Please enter the Apache group ID (e.g. nobody): "
    read group
    if [ x$group = x ]; then
      group=nobody
    fi
    chgrp $group $DATA_DIR/{text,text/RCS,cache,user} &&
    chgrp $group {$DATA_DIR,pds}
    RETVAL=$?
  done
fi

echo
echo 'Your wiki is cofiguared now.'
echo 'Please open monisetup.php in a browser'
echo ' to change some basic options for your wiki'
echo
echo

