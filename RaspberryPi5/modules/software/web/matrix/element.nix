{ clientConfig }: { pkgs, ... }: {
  services.nginx.virtualHosts = {
    "element.duanin2.top" = {
      useACMEHost = "duanin2.top";
      onlySSL = true;
      root = pkgs.element-web.override {
        conf = {
          default_server_config = clientConfig; # see `clientConfig` from the snippet above.
        };
      };
    };
  };
}
