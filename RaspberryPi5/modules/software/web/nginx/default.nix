{ ... }: let
  httpsUpgrade = ''
set $do_http_upgrade "$https$http_upgrade_insecure_requests";
if ($do_http_upgrade = "1") {
    add_header Vary Upgrade-Insecure-Requests;
    return 307 https://$host$request_uri;
}
  '';
in {
  imports = [
    ../acme
  ];

  _module.args = { inherit httpsUpgrade; };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "acmechallenge.duanin2.top" = {
        # Catchall vhost, will redirect users to HTTPS for all vhosts
        serverAliases = [ "*.duanin2.top" "bohousek10d1979.asuscomm.com" ];
        default = true;
        useACMEHost = "duanin2.top";
        addSSL = true;
        
        locations."/.well-known/acme-challenge" = {
          root = "/var/lib/acme/.challenges";
          priority = 0;
        };
        extraConfig = httpsUpgrade;
      };
      "duanin2.top" = {
        useACMEHost = "duanin2.top";
        addSSL = true;
        extraConfig = httpsUpgrade;
      };
      /*
      "bohousek10d1979.asuscomm.com" = {
        useACMEHost = "asuscomm.com";

        locations."/".proxyPass = "https://192.168.1.1";

        addSSL = true;
      };
      */
    };

    commonHttpConfig = ''
log_format custom '$remote_user@$remote_addr:$remote_port [$time_local] - "$request_method $scheme://$host$request_uri" $uri $status - $server_name[$server_protocol $server_addr:$server_port] - $body_bytes_sent "$http_referer" "$http_user_agent"';
access_log /var/log/nginx/access.log custom;
    '';
  };

  users.users.nginx.extraGroups = [ "acme" "searx" ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
