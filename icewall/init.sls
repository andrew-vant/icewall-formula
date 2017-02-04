icewall-ipv4:
  pkg.installed:
    - pkgs:
      - iptables
      - iptables-persistent
  file.managed:
    - name: /etc/iptables/rules.v4
    - source: salt://icewall/files/rules.jinja
    - template: jinja
    - context:
        slspath: {{ slspath }}
        family: ipv4
  cmd.wait:
    - name: iptables-restore rules.v4
    - cwd: /etc/iptables
    - order: last
    - watch: 
      - file: icewall-ipv4

icewall-ipv6:
  pkg.installed:
    - pkgs:
      - iptables
      - iptables-persistent
  file.managed:
    - name: /etc/iptables/rules.v6
    - source: salt://icewall/files/rules.jinja
    - template: jinja
    - context:
        slspath: {{ slspath }}
        family: ipv6
  cmd.wait:
    - name: ip6tables-restore rules.v6
    - cwd: /etc/iptables
    - order: last
    - watch:
      - file: icewall-ipv6

# For some reason, this state disconnects the minion from the master and it 
# won't rediscover it automatically. Restarting the minion should force it
# to reconnect. This is a horrible kludge, unfortunately.

  service.running:
    - name: salt-minion
    - order: last
    - watch:
      - cmd: icewall-ipv4
      - cmd: icewall-ipv6
