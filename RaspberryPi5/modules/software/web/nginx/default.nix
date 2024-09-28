{ pkgs, lib, ... }: let
  securitySetupNGINX = origin: let
    isoTime = when: accuracy: lib.readFile (pkgs.runCommand "timestamp" { } "echo -n `date -d @${builtins.toString when} --iso-8601=${accuracy} > $out`");
    
    expiration = {
      humanReadable = "30 days";
      seconds = 60 * 60 * 24 * 30;
    };
    paths = [ "/security.txt" "/.well-known/security.txt" ];
    
    finalSecurity = pkgs.writeText "security.txt" ''
${lib.strings.concatMapStrings (path: ''Canonical: http://${origin}${path}
Canonical: https://${origin}${path}'') paths}

Contact: mailto:admin-security@duanin2.top

# Always expires ${expiration.humanReadable} after generation
Expires: ${isoTime (builtins.currentTime + expiration.seconds) "seconds"}

Preferred-Languages: cs, en
    '';
  in ''
${lib.strings.concatMapStrings (path: "location =${path} { alias ${finalSecurity}; }\n") paths}
  '';
  securityHeaders = let
    allowedSrc = "'self' $scheme://duanin2.top $scheme://*.duanin2.top";
  in ''
add_header Strict-Transport-Security "max-age=300" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Content-Security-Policy "default-src ${allowedSrc}; base-uri ${allowedSrc}; frame-src ${allowedSrc}; frame-ancestors ${allowedSrc}; form-action ${allowedSrc}" always;
add_header Referrer-Policy "no-referrer" always;
  '';
  httpsUpgrade = ''
set $do_http_upgrade "$https$http_upgrade_insecure_requests";
if ($do_http_upgrade = "1") {
    return 307 https://$host$request_uri;
    }
  '';
in {
  imports = [
    ../acme
  ];

  _module.args = { inherit securitySetupNGINX securityHeaders httpsUpgrade; };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "duanin2.top" = {
        useACMEHost = "duanin2.top";
        addSSL = true;

        extraConfig = (securitySetupNGINX "duanin2.top") + securityHeaders + httpsUpgrade;
      };
      /*
      "bohousek10d1979.asuscomm.com" = {
        useACMEHost = "asuscomm.com";
        addSSL = true;

        locations."/".proxyPass = "https://192.168.1.1";

        extraConfig = (securitySetupNGINX "bohousek10d1979.asuscomm.com") + securityHeaders + httpsUpgrade;
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
