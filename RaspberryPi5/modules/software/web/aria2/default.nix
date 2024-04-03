{ config, ... }: let
	cfg = config.services.aria2;
in {
	services.aria2 = {
		enable = true;
	};

	networking.firewall.allowedTCPPortRanges = [ cfg.listenPortRange ];
	services.nginx.virtualHosts."aria2.duanin2.top" = {
		locations."/" = {
			useACMEHost = "duanin2.top";
			proxyPass = "localhost:${cfg.rpcListenPort}";
			proxyWebsockets = true;
		};
	};
}