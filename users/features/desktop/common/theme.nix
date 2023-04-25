{ config, inputs, pkgs, ...}: {
  home.pointerCursor = {
    name = "Catppuccin-Frappe-Green-Cursors";
    size = 24;
    package = pkgs.catppuccin-cursors.frappeGreen;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Green-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["green"];
        variant = "frappe";
      };
    };
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "frappe";
        accent = "green";
      };
      name = "Papirus";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = if config.gtk.theme.name == null then "" else config.gtk.theme.name;
      icon-theme = if config.gtk.iconTheme.name == null then "" else config.gtk.iconTheme.name;
      cursor-theme = if config.home.pointerCursor.name == null then "" else config.home.pointerCursor.name;
      cursor-size = if config.home.pointerCursor.size == null then "" else config.home.pointerCursor.size;
      /*font-name = "${if config.gtk.font.name == null then "" else config.gtk.font.name} ${if config.gtk.font.size == null then "" else toString config.gtk.font.size}";*/
    };
  };

  home.activation = {
    flatpakThemingGTK = ''
      echo Adding paths from XCURSOR_PATH to flatpak filesystem
      XCURSOR_PATH=/home/duanin2/.icons:/home/duanin2/.local/share/icons:/home/duanin2/.local/share/flatpak/exports/share/icons:/home/duanin2/.local/share/flatpak/exports/share/pixmaps:/var/lib/flatpak/exports/share/icons:/var/lib/flatpak/exports/share/pixmaps:/home/duanin2/.nix-profile/share/icons:/home/duanin2/.nix-profile/share/pixmaps:/etc/profiles/per-user/duanin2/share/icons:/etc/profiles/per-user/duanin2/share/pixmaps:/nix/var/nix/profiles/default/share/icons:/nix/var/nix/profiles/default/share/pixmaps:/run/current-system/sw/share/icons:/run/current-system/sw/share/pixmaps:/home/duanin2/.nix-profile/share/icons
      IFS=:
      for path in $XCURSOR_PATH;
      do
        ${pkgs.flatpak}/bin/flatpak override -u --filesystem="$path"
      done
      IFS=$' \t\n'

      echo Setting XCURSOR_PATH
      ${pkgs.flatpak}/bin/flatpak override -u --env=XCURSOR_PATH="$XCURSOR_PATH"

      echo

      echo Adding paths from GTK_PATH to flatpak filesystem
      GTK_PATH=/home/duanin2/.local/share/flatpak/exports/lib/gtk-2.0:/home/duanin2/.local/share/flatpak/exports/lib/gtk-3.0:/home/duanin2/.local/share/flatpak/exports/lib/gtk-4.0:/var/lib/flatpak/exports/lib/gtk-2.0:/var/lib/flatpak/exports/lib/gtk-3.0:/var/lib/flatpak/exports/lib/gtk-4.0:/home/duanin2/.nix-profile/lib/gtk-2.0:/home/duanin2/.nix-profile/lib/gtk-3.0:/home/duanin2/.nix-profile/lib/gtk-4.0:/etc/profiles/per-user/duanin2/lib/gtk-2.0:/etc/profiles/per-user/duanin2/lib/gtk-3.0:/etc/profiles/per-user/duanin2/lib/gtk-4.0:/nix/var/nix/profiles/default/lib/gtk-2.0:/nix/var/nix/profiles/default/lib/gtk-3.0:/nix/var/nix/profiles/default/lib/gtk-4.0:/run/current-system/sw/lib/gtk-2.0:/run/current-system/sw/lib/gtk-3.0:/run/current-system/sw/lib/gtk-4.0
      IFS=:
      for path in $GTK_PATH;
      do
        ${pkgs.flatpak}/bin/flatpak override -u --filesystem="$path"
      done
      IFS=$' \t\n'

      echo Setting GTK_PATH
      ${pkgs.flatpak}/bin/flatpak override -u --env=GTK_PATH="$GTK_PATH"

      echo

      echo Setting GTK_THEME
      ${pkgs.flatpak}/bin/flatpak override -u --env=GTK_THEME="${config.gtk.theme.name}"

      echo Setting XCURSOR_THEME
      ${pkgs.flatpak}/bin/flatpak override -u --env=XCURSOR_THEME="${config.home.pointerCursor.name}"

      echo Setting XCURSOR_SIZE
      ${pkgs.flatpak}/bin/flatpak override -u --env=XCURSOR_SIZE="${toString config.home.pointerCursor.size}"

      echo 

      echo Setting up individual Flatpak packages
      IFS=$'\n'
      for pkg_branch in $(${pkgs.flatpak}/bin/flatpak list | ${pkgs.gawk}/bin/awk -F$'\t' '{print $2" "$4}');
      do
        pkg=$(echo $pkg_branch | ${pkgs.gawk}/bin/awk '{print $1}')
        branch=$(echo $pkg_branch | ${pkgs.gawk}/bin/awk '{print $2}')

        echo Flatpak branch $branch of package $pkg

        echo -n "Setting gtk-theme in org.gnome.desktop.interface - "
        ${pkgs.flatpak}/bin/flatpak run --branch=$branch --command=gsettings $pkg set org.gnome.desktop.interface gtk-theme '${config.gtk.theme.name}' &> /dev/null && echo success || echo failure

        echo -n "Setting icon-theme in org.gnome.desktop.interface - "
        ${pkgs.flatpak}/bin/flatpak run --branch=$branch --command=gsettings $pkg set org.gnome.desktop.interface icon-theme '${config.gtk.iconTheme.name}' &> /dev/null && echo success || echo failure

        echo -n "Setting cursor-theme in org.gnome.desktop.interface - "
        ${pkgs.flatpak}/bin/flatpak run --branch=$branch --command=gsettings $pkg set org.gnome.desktop.interface cursor-theme '${config.home.pointerCursor.name}' &> /dev/null && echo success|| echo failure

        echo -n "Setting cursor-size in org.gnome.desktop.interface - "
        ${pkgs.flatpak}/bin/flatpak run --branch=$branch --command=gsettings $pkg set org.gnome.desktop.interface cursor-size '${toString config.home.pointerCursor.size}' &> /dev/null && echo success || echo failure

        echo
      done
      IFS=$' \t\n'
    '';
    flatpakThemingQT = ''
      echo Setting QT Style
      ${pkgs.flatpak}/bin/flatpak override -u --env=QT_STYLE_OVERRIDE=kvantum --filesystem=xdg-config/Kvantum:ro
    '';
  };

  /*home.file = {
    "nix-black" = {
      enable = true;
      source = builtins.fetchurl "https://github.com/catppuccin/wallpapers/raw/main/os/nix-black-4k.png";
      target = "Wallpapers/nix-black.png";
    };
    "nix-magenta-blue" = {
      enable = true;
      source = builtins.fetchurl "https://github.com/catppuccin/wallpapers/raw/main/os/nix-magenta-blue-1920x1080.png";
      target = "Wallpapers/nix-magenta-blue.png";
    };
    "nix-magenta-pink" = {
      enable = true;
      source = builtins.fetchurl "https://github.com/catppuccin/wallpapers/raw/main/os/nix-magenta-pink-1920x1080.png";
      target = "Wallpapers/nix-magenta-pink.png";
    };
  };*/

  xdg.configFile.hyprpaper = if builtins.elem inputs.hyprpaper.packages.x86_64-linux.hyprpaper config.home.packages then {
    enable = true;
    text = ''
preload = ~/Wallpapers/nix-black.png
preload = ~/Wallpapers/nix-magenta-blue.png
preload = ~/Wallpapers/nix-magenta-pink.png

wallpaper = eDP-1,~/Wallpapers/nix-black-4k.png
    '';
    target = "hypr/hyprpaper.conf";
  } else {
    enable = false;
  };
}
