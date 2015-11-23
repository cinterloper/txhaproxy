/etc/haproxy/haproxy.cfg.new:
  file.managed:
    - source: salt://haproxy/haproxy.conf.jinja
    - template: jinja
    - context:
        mode: local
/etc/haproxy/reload.sh:
  cmd.run
