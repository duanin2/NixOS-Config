{ ... }: {
  networking.nftables = {
    enable = true;

    flushRuleset = true;
    ruleset = ''
table ip nat {
  chain PREROUTING {
    type nat hook prerouting priority dstnat; policy accept;
    iifname "tornet" meta l4proto tcp dnat to 127.0.0.1:9040
    iifname "tornet" udp dport 53 dnat to 127.0.0.1:53
    iifname "tornet" tcp dport 9050 dnat to 127.0.0.1:9050
  }
}
    '';
  };
}
