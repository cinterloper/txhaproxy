FROM nfnty/arch-mini
RUN pacman -Syu --noconfirm
RUN pacman -S salt-zmq haproxy core/util-linux supervisor haproxy nodejs npm nano grep jq psmisc procps-ng diffutils git --noconfirm
RUN mkdir /etc/haproxy/errors/; chown haproxy:haproxy /etc/haproxy/errors
RUN mkdir /var/lib/haproxy; chown haproxy:haproxy /var/lib/haproxy
ADD script/reload.sh /etc/haproxy/reload.sh
ADD script/config.sh /etc/haproxy/config.sh
ADD script/json2yaml.py /opt/json2yaml.py
ADD salt /srv/salt
ADD pillar /srv/pillar
ADD web /opt/web
RUN salt-call --local state.highstate #render the haproxy config from jinja teplate
ADD supervisord.conf /etc/supervisord.conf
CMD /usr/bin/supervisord -n
RUN cd /opt/web; npm install -g 
RUN cd /opt/web; npm install 
RUN cd /etc/haproxy; git init; git add .;  git config --global user.email "root@system.loc";  git config --global user.name "haproxy"; git commit -m 'start'
