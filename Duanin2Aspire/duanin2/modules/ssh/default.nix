{ persistDirectory, ... }: {
  imports = [
    ./rpi5.nix
    ./github.nix
  ];

  programs.ssh = {
    enable = true;

    compression = true;
    addKeysToAgent = "yes";

    extraConfig = ''
VerifyHostKeyDNS yes
    '';
  };

  home.persistence.${persistDirectory} = {
    directories = [ ".ssh" ];
  };
}
