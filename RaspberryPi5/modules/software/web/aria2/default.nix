{ config, ... }: let
	cfg = config.services.aria2;
in {
	services.aria2 = {
		enable = true;

		openPorts = true;
		rpcSecretFile = "/run/secrets/aria2RpcToken";
	};
	services.nginx.virtualHosts."aria2.duanin2.top" = {
		useACMEHost = "duanin2.top";
		locations."/" = {
			proxyPass = "localhost:${toString cfg.rpcListenPort}";
			proxyWebsockets = true;
		};
	};
}