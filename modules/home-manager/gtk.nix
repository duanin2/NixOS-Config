{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gtk;

  toGtkIni = generators.toINI {
    mkKeyValue = key: value: let
      value' = if isBool value then boolToString value else toString value;
    in
      "${escape [ "=" ] key}=${value'}";
  };

  formatGtk2Option = n: v: let
    v' = if isBool v then
      boolToString value
    else if isString v then
      ''"${v}"''
    else
      toString v;
  in
    "${escape [ "=" ] n} = ${v'}";

  themeType = types.submodule {
    options = {
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = literalExpression "pkgs.gnome.gnome-themes-extra";
        description = ''
          Package providing the theme. This package will be installed
          to your profile. If `null` then the theme
          is assumed to already be available in your profile.
        '';
      };

      name = mkOption {
        type = types.str;
        example = "Adwaita";
        description = "The name of the theme within the package.";
      };
    };
  };

  iconThemeType = types.submodule {
    options = {
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = literalExpression "pkgs.gnome.adwaita-icon-theme";
        description = ''
          Package providing the icon theme. This package will be installed
          to your profile. If `null` then the theme
          is assumed to already be available in your profile.
        '';
      };

      name = mkOption {
        type = types.str;
        example = "Adwaita";
        description = "The name of the icon theme within the package.";
      };
    };
  };

  cursorThemeType = types.submodule {
    options = {
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = literalExpression "pkgs.vanilla-dmz";
        description = ''
          Package providing the cursor theme. This package will be installed
          to your profile. If `null` then the theme
          is assumed to already be available in your profile.
        '';
      };

      name = mkOption {
        type = types.str;
        example = "Vanilla-DMZ";
        description = "The name of the cursor theme within the package.";
      };

      size = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 16;
        description = ''
          The size of the cursor.
        '';
      };
    };
  };
in {
  disabledModules = [ "misc/gtk.nix" ];

  options.gtk = {
    enable = mkEnableOption "GTK configuration";

    font = mkOption {
      type = types.nullOr hm.types.fontType;
      default = null;
      description = "The font to use.";
    };

    cursorTheme = mkOption {
      type = types.nullOr cursorThemeType;
      default = null;
      description = "The cursor theme to use.";
    };

    iconTheme = mkOption {
      type = types.nullOr iconThemeType;
      default = null;
      description = "The icon theme to use.";
    };

    theme = mkOption {
      type = types.nullOr themeType;
      default = null;
      description = "The GTK theme to use.";
    };

    preferDarkTheme = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to use a dark theme or not.";
    };
  };

  config = mkIf cfg.enable (let
    gtk4Ini = optionalAttrs (cfg.font != null) {
      gtk-font-name = let
        fontSize = optionalString (cfg.font.size != null) " ${toString cfg.font.size}";
      in "${cfg.font.name}" + fontSize;
    } // optionalAttrs (cfg.theme != null) { gtk-theme-name = cfg.theme.name; }
    // optionalAttrs (cfg.iconTheme != null) {
      gtk-icon-theme-name = cfg.iconTheme.name;
    } // optionalAttrs (cfg.cursorTheme != null) {
      gtk-cursor-theme-name = cfg.cursorTheme.name;
    } // optionalAttrs (cfg.cursorTheme != null && cfg.cursorTheme.size != null) {
      gtk-cursor-theme-size = cfg.cursorTheme.size;
    } // {
      gtk-application-prefer-dark-theme = cfg.preferDarkTheme;
    };

    gtk3Ini = optionalAttrs (cfg.font != null) {
      gtk-font-name = let
        fontSize =
          optionalString (cfg.font.size != null) " ${toString cfg.font.size}";
      in "${cfg.font.name}" + fontSize;
    } // optionalAttrs (cfg.theme != null) { gtk-theme-name = cfg.theme.name; }
    // optionalAttrs (cfg.iconTheme != null) {
      gtk-icon-theme-name = cfg.iconTheme.name;
    } // optionalAttrs (cfg.cursorTheme != null) {
      gtk-cursor-theme-name = cfg.cursorTheme.name;
    } // optionalAttrs (cfg.cursorTheme != null && cfg.cursorTheme.size != null) {
      gtk-cursor-theme-size = cfg.cursorTheme.size;
    } // {
      gtk-application-prefer-dark-theme = cfg.preferDarkTheme;
    };

    gtk2Ini = optionalAttrs (cfg.font != null) {
      gtk-font-name = let
        fontSize = optionalString (cfg.font.size != null) " ${toString cfg.font.size}";
      in "${cfg.font.name}" + fontSize;
    } // optionalAttrs (cfg.theme != null) { gtk-theme-name = cfg.theme.name; }
    // optionalAttrs (cfg.iconTheme != null) {
      gtk-icon-theme-name = cfg.iconTheme.name;
    } // optionalAttrs (cfg.cursorTheme != null) {
      gtk-cursor-theme-name = cfg.cursorTheme.name;
    } // optionalAttrs (cfg.cursorTheme != null && cfg.cursorTheme.size != null) {
      gtk-cursor-theme-size = cfg.cursorTheme.size;
    };

    dconfIni = optionalAttrs (cfg.font != null) {
      font-name = let
        fontSize = optionalString (cfg.font.size != null) " ${toString cfg.font.size}";
      in "${cfg.font.name}" + fontSize;
    } // optionalAttrs (cfg.theme != null) { gtk-theme = cfg.theme.name; }
    // optionalAttrs (cfg.iconTheme != null) {
      icon-theme = cfg.iconTheme.name;
    } // optionalAttrs (cfg.cursorTheme != null) {
      cursor-theme = cfg.cursorTheme.name;
    } // optionalAttrs (cfg.cursorTheme != null && cfg.cursorTheme.size != null) {
      cursor-size = cfg.cursorTheme.size;
    } // {
      color-scheme = if cfg.preferDarkTheme then "prefer-dark" else "prefer-light";
    };

    optionalPackage = opt: optional (opt != null && opt.package != null) opt.package;
  in {
    home.packages = concatMap optionalPackage [
      cfg.font
      cfg.theme
      cfg.iconTheme
      cfg.cursorTheme
    ];

    home.sessionVariables.GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    xdg.configFile."gtk-2.0/gtkrc".text =
      concatMapStrings (l: l + "\n") (mapAttrsToList formatGtk2Option gtk2Ini)
      + "\n";

    xdg.configFile."gtk-3.0/settings.ini".text =
      toGtkIni { Settings = gtk3Ini; };

    xdg.configFile."gtk-4.0/settings.ini".text =
      toGtkIni { Settings = gtk4Ini; };

    dconf.settings."org/gnome/desktop/interface" = dconfIni;

    services.xsettingsd.settings = mkIf config.services.xsettingsd.enable {
      "Gtk/FontName" = "${cfg.font.name},  ${toString cfg.font.size}";
      "Gtk/CursorThemeName" = cfg.cursorTheme.name;
      "Gtk/CursorThemeSize" = cfg.cursorTheme.size;
      "Net/IconThemeName" = (cfg.iconTheme.name or "");
      "Net/ThemeName" = cfg.theme.name;
    };
  });
}
