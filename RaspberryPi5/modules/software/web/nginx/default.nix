{ pkgs, lib, ... }: let
  securitySetupNGINX = origins: let
    isoTime = when: accuracy: lib.readFile (pkgs.runCommand "timestamp" { } "echo -n `date -d @${builtins.toString when} --iso-8601=${accuracy} > $out`");
    
    expiration = {
      humanReadable = "30 days";
      seconds = 60 * 60 * 24 * 30;
    };
    paths = [ "/security.txt" "/.well-known/security.txt" ];
    
    finalSecurity = pkgs.writeText "security.txt" ''
${lib.strings.concatMapStrings (path: lib.strings.concatMapStrings (origin: "Canonical: https://${origin}${path}\n") origins) paths}

Contact: mailto:admin@security.duanin2.top

# Always expires ${expiration.humanReadable} after generation
Expires: ${isoTime (builtins.currentTime + expiration.seconds) "seconds"}

Preferred-Languages: cs, en
    '';
  in ''
${lib.strings.concatMapStrings (path: ''
location =${path} {
    alias ${finalSecurity};
    add_header Content-Type "text/plain" always;
    ${securityHeaders}
}
'') paths}
  '';
  securityHeaders = let
    allowedSrc = "'self' $scheme://duanin2.top $scheme://*.duanin2.top";
  in ''
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
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
  ocspStapling = ''
ssl_stapling on;
ssl_stapling_verify on;
  '';

  nginxCacheName = "cache";
in {
  imports = [
    ../acme
  ];

  _module.args = { inherit securitySetupNGINX securityHeaders httpsUpgrade ocspStapling; };

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

        serverAliases = [ "www.duanin2.top" ];

        locations = {
          "/" = {
            root = "/persist/www/duanin2.top";
            index = "index.html index.htm";
          };
          "=/twtxt.txt" = {
            alias = "/persist/duanin2-twtxt.txt";
          };
        };

        extraConfig = (securitySetupNGINX [ "duanin2.top" "www.duanin2.top" ]) + (let
          allowedSrc = "'self' $scheme://duanin2.top $scheme://*.duanin2.top";
        in ''
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Content-Security-Policy "default-src ${allowedSrc}; base-uri ${allowedSrc}; frame-src ${allowedSrc} https://john.citrons.xyz; frame-ancestors ${allowedSrc}; form-action ${allowedSrc}" always;
add_header Referrer-Policy "no-referrer" always;
        '') + httpsUpgrade + ocspStapling;
      };
      /*
      "bohousek10d1979.asuscomm.com" = {
        useACMEHost = "asuscomm.com";
        addSSL = true;

        locations."/".proxyPass = "https://192.168.1.1";

        extraConfig = (securitySetupNGINX [ "bohousek10d1979.asuscomm.com" ]) + securityHeaders + httpsUpgrade;
      };
      */
    };

    commonHttpConfig = ''
log_format custom '$remote_user@$remote_addr:$remote_port [$time_local] - "$request_method $scheme://$host$request_uri" $uri $status - $server_name[$server_protocol $server_addr:$server_port] - $body_bytes_sent "$http_referer" "$http_user_agent"';
log_format csv '$remote_user;$remote_addr;$remote_port;$time_local;$request_method;$scheme://$host$request_uri";$uri;$status;$server_name;$server_protocol;$server_addr;$server_port;$body_bytes_sent;$http_referer;$http_user_agent';
access_log /var/log/nginx/access.log custom;
access_log /var/log/nginx/access.log.csv csv;

proxy_cache ${nginxCacheName};
proxy_cache_background_update on;
proxy_cache_key "$proxy_host$proxy_port$request_uri$args";
proxy_cache_revalidate on;
proxy_cache_lock on;
proxy_cache_use_stale error updating http_500 http_502 http_503 http_504;
    '';
    proxyCachePath.${nginxCacheName} = {
      enable = true;

      inactive = "1w";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/cache/nginx/${nginxCacheName}"
    ];
  };

  users.users.nginx.extraGroups = [ "acme" "searx" ];

  systemd.services.nginx = let
    eraseCache = "${pkgs.coreutils}/bin/rm -rf /var/cache/nginx/${nginxCacheName}/*";
  in {
    preStart = lib.mkBefore eraseCache;
    serviceConfig.ExecReload = lib.mkBefore [ "${lib.getExe pkgs.bash} -c \"${eraseCache}\"" ];
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
