RELOAD_CMD() {
  haproxy -f /etc/haproxy/haproxy.conf -sf $(cat /tmp/haproxy.pid)
}

ERROR_HANDLE() { # you can probably do something more creative with this if you put your mind to it
 if [[ -z "$1" ]]; then
  read 1
 fi
 echo $1
}
REQUEST_HOSTNAME() {
  
}
