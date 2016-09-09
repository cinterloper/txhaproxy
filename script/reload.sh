#!/bin/bash
CONFIG_PATH=/etc/haproxy/
cd $CONFIG_PATH
source config.sh
diff $CONFIG_PATH"haproxy.cfg.new"  /etc/haproxy/haproxy.conf
#if the new config is diffrent from the old config, test it

if [[ $? -ne 0 ]]; then

 {
   haproxy -f $CONFIG_PATH"haproxy.cfg.new" -c
 } || { # if exit anything other then 0
   echo config has errors
   ERROR_HANDLE $(haproxy -f $CONFIG_PATH"haproxy.cfg.new" -c 2>&1 | xargs echo -n )
   exit -1;
 }
 #this should only be reached if the new config tests clean
 mv $CONFIG_PATH/haproxy.cfg.new /etc/haproxy/haproxy.conf
else
 rm $CONFIG_PATH/haproxy.cfg.new
fi

{
   RELOAD_CMD
} || { # if exit other then 0
   echo reload went wrong, rolling back
   #cd /etc/haproxy; git reset --hard
   /etc/init.d/haproxy reload
   echo "problem with new haproxy config, system has attempted to roll config back to " | ERROR_HANDLE
   exit -1
}
   #git add .
   #git commit -m $(md5sum /etc/haproxy/haproxy.conf)
   #git add/commit here, return the commit tag

#add some option to request roll back to specific commit
