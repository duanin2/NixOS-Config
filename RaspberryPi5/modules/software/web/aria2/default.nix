{ config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, ... }: let
	cfg = config.services.aria2;
  dir = "/var/lib/aria2";

  host = "aria2.duanin2.top";
in {
	services.aria2 = {
		enable = true;

		openPorts = true;
		rpcSecretFile = "/var/lib/secrets/aria2RpcToken";
    settings = {
      dir = "${dir}/Downloads";
      max-concurrent-downloads = 5;
      check-integrity = true;
      continue = true;
      lowest-speed-limit = "8K";
      max-connection-per-server = 10;
      min-split-size = "5M";
      remote-time = true;
      retry-wait = 5;
      server-stat-of = "${dir}/serverPerf";
      server-stat-if = "${dir}/serverPerf";
      split = 50;
      uri-selector = "adaptive";
      http-accept-gzip = true;
      http-auth-challenge = true;
      use-head = true;
      bt-detach-seed-only = true;
      bt-enable-lpd = true;
      bt-external-ip = "109.80.156.99";
      bt-force-encryption = true;
      bt-load-saved-metadata = true;
      bt-max-peers = 50;
      bt-request-peer-speed-limit = "128K";
      bt-save-metadata = true;
      dht-listen-addr6 = "2001:0:d911:c0d9:104d:1a96:92af:639c";
      dht-message-timeout = 60;
      enable-dht6 = true;
      seed-ratio = 2.0;
      seed-time = 360;
      metalink-enable-unique-protocol = false;
      allow-overwrite = true;
      allow-piece-length-change = true;
      always-resume = false;
      disk-cache = "128M";
      enable-mmap = true;
      file-allocation = "trunc";
      force-save = true;
      keep-unfinished-download-result = true;
      optimize-concurrent-downloads = true;
      parameterized-uri = true;
      save-session = "${dir}/session";
      save-session-interval = 120;
    };
	};
  
	services.nginx.virtualHosts.${host} = {
		useACMEHost = "duanin2.top";
    onlySSL = true;
    
		locations."/" = {
			proxyPass = "http://localhost:${toString cfg.settings.rpc-listen-port}";
			proxyWebsockets = true;
		};

    extraConfig = (securitySetupNGINX [ host ]) + securityHeaders + httpsUpgrade + ocspStapling;
	};

  environment.persistence."/persist" = {
    directories = [ dir ];
  };
}
