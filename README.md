# icewall-formula
An alternate iptables formula for Salt.

*Note: Works on 2015.5.3 and earlier, will be updated soon for
post-2015.8.0. See issue #6.*

This is intended to do basic firewall management for an endpoint. It
will not do complex NATing or similar. It does handle both ipv4 and
ipv6.

Rules define which source IP addresses can reach which ports. Source
addresses can be defined as an explicit list of IP subnets, a named
set of same, or a salt-minion glob. Ports can be defined as an explicit
list or a named set. Any of these options can be mixed and matched
within the same rule.

A few ICMP types are allowed by default. Anything else not matching
a rule is dropped. The available options for icmp and default policy
are in defaults.yaml. Options for which the default is empty are
shown below.

```yaml
icewall:
  ipsets: # Named IP sets can be defined and reused in multiple rules.
    public:
      - 0.0.0.0/0 # All IPv4 sources.
      - "::/0"    # all IPv6 sources.
    internal:
      - 10.0.0.0/8

  portsets: # The same goes for named port sets.
    web:
      - 80
      - 443

  rules:
    # This simple rule allows the world access to 80 and 443, suitable
    # for a public webserver.
    publicweb:
      ipset: public
      portset: web

    # This more-complex rule allows access to 22, 80, and 443 to internal
    # networks, minions matching 'bastion-*' and a single IP literal.
    # This is just an example showing that you can mix and match different
    # specifications in the same rule.
    management:
      ipset: internal
      minions: 'bastion-*'
      ips:
        - 192.168.1.0/24
      portset: web
      ports:
        - 22
```
