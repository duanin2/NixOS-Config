{ config, ... }: let
	cfg = config.services.aria2;
  dir = "/var/lib/aria2";
in {
	services.aria2 = {
		enable = true;

		openPorts = true;
		rpcSecretFile = "/var/lib/secrets/aria2RpcToken";
    settings = {
      save-session = "${dir}/session";
      dir = "${dir}/Downloads";
    };
	};
  
	services.nginx.virtualHosts."aria2.duanin2.top" = {
		useACMEHost = "duanin2.top";
    forceSSL = true;
		locations."/" = {
			proxyPass = "http://localhost:${toString cfg.settings.rpc-listen-port}";
			proxyWebsockets = true;
		};
	};

  environment.persistence."/persist" = {
    directories = [ dir ];
  };
}
