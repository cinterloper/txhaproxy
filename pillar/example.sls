haproxy:
  resolvers:
    local_dns:
      options:
        - 'nameserver resolvconf 8.8.8.8:53'
        - resolve_retries 3
        - timeout retry 1s
        - hold valid 10s
  global:
    daemon: true
    chroot:
      path: /var/lib/haproxy
      enable: true
    group: haproxy
    user: haproxy
  enabled: true
  userlists:
    userlist1:
      users:
        john: insecure-password doe
        sam: insecure-password frodo
  backends:
    backend1:
      balance: roundrobin
      name: www-backend
      servers:
        server1:
          port: 8983
          host: 172.17.42.1
          check: check
          name: net
  defaults:
    retries: 3
    logformat: "%ci:%cp\\ [%t]\\ %ft\\ %b/%s\\ %Tq/%Tw/%Tc/%Tr/%Tt\\ %ST\\ %B\\ %CC\\ %CS\\ %tsc\\ %ac/%fc/%bc/%sc/%rc\\ %sq/%bq\\ %hr\\ %hs\\ %{+Q}r"
    stats:
      - enable
      - uri: /admin?stats
      - realm: "Haproxy\\ Statistics"
      - auth: 'admin1:AdMiN123'
    log: global
    timeouts:
      - http-request    10s
      - queue           10m
      - connect         10s
      - client          1m
      - server          1m
      - http-keep-alive 10s
      - check           10s
    options:
      - httplog
      - dontlognull
      - forwardfor
      - http-server-close
    mode: http
  frontends:
    frontend1:
      bind: '*:9955'
      reqadds:
        - "X-Forwarded-Proto:\\ http"
      name: www-http
      default_backend: www-backend
  config_file_path: /etc/haproxy/haproxy.cfg
