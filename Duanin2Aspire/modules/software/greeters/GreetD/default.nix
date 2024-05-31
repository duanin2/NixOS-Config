{ inputs, config, lib, pkgs, customPkgs, ... }: {
  imports = [
    ./greeter/regreet.nix
  ];

  environment.systemPackages = with pkgs; [
    (customPkgs.catppuccin-hyprcursor.override { inherit (inputs.hyprland.inputs.hyprcursor.packages.${pkgs.system}) hyprcursor; }).frappeGreen
  ];

  services.greetd = {
    enable = true;

    vt = 7;
    settings = {
      default_session = {
        command = "env XKB_DEFAULT_MODEL=acer_laptop XKB_DEFAULT_LAYOUT=cz XCURSOR_PATH=${pkgs.catppuccin-cursors.frappeGreen} ${lib.getExe pkgs.cage} -d -m extend -- ${pkgs.dbus}/bin/dbus-run-session ${lib.getExe config.programs.regreet.package}";
      };
    };
  };
}
