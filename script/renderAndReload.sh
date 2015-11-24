#!/bin/bash
chattr +i /srv/pillar/example.sls // immutable write-lock
echo $$ > /var/lock/example.sls.lck //let others know
salt-call --pillar-root=/srv/pillar --local state.highstate ; //use it
rm /var/lock/example.sls.lck && chattr -i /srv/pillar/example.sls /free
