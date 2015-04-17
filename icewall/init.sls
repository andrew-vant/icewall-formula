icewall:
  pkg.installed:
    - pkgs:
      - iptables
      - iptables-persistent
  file.managed:
    - name: /etc/iptables/rules.v4
    - source: salt://icewall/files/rules.v4.jinja
    - template: jinja
    - context:
        '__sls__': icewall # Bug workaround, salt issue #19856
  cmd.wait:
    - name: iptables-restore rules.v4
    - cwd: /etc/iptables
    - order: last
    - watch: 
      - file: icewall

# For some reason, this state disconnects the minion from the master and it 
# won't rediscover it automatically. Restarting the minion should force it
# to reconnect. This is a horrible kludge, unfortunately.

  service.running:
    - name: salt-minion
    - order: last
    - watch:
      - cmd: icewall
