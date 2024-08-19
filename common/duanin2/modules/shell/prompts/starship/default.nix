{ lib, ... }: {
  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;
      
      scan_timeout = 50;
      command_timeout = 1000;

      format = lib.concatStrings [
        "$shell at $os $username@$hostname$nix_shell$line_break"
        "$directory $direnv $git_branch$git_status $character"
      ];
      right_format = lib.concatStrings [
        "$all"
      ];

      directory = {
        truncation_length = 5;
        truncate_to_repo = true;
        truncation_symbol = ".../";

        substitutions = {
          # nix store
          "/persist/nix" = "/nix";
          "/nix/store" = "nix store";

          # disks
          "/persist" = "internal";
          "/mnt" = "mounted";
          "/boot" = "ESP";
          "/tmp" = "TMP";

          "~/dev" = "Dev";
          "~/KeePass" = "KeePassXC";
          "~/Dokumenty" = "Docs";
          "~/Hudba" = "Music";
          "~/Obrazky" = "Img";
          "~/Plocha" = "Desktop";
          "~/Stažené" = "Downloads";
          "~/Veřejné" = "Public";
          "~/Videa" = "Vids";
          "~/Šablony" = "Templates";
          "~/Hry" = "Games";
        };
      };

      git_branch = {
        symbol = "";
        style = "bold purple";
        format = "on [$symbol$branch(:$remote_branch)]($style)";

        only_attached = true;
        ignore_branches = [
          "master"
          "main"
        ];
      };
      git_status = { };

      os = {
        disabled = false;

        format = "[$symbol]($style) ";

        symbols = {
          AIX = "➿";
          Alpaquita = "🔔";
          AlmaLinux = "";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "";
          CentOS = "";
          Debian = "";
          DragonFly = "🐉";
          Emscripten = "🔗";
          EndeavourOS = "";
          Fedora = "";
          FreeBSD = "";
          Garuda = "";
          Gentoo = "";
          Hardened = "🛡️";
          Illumos = "";
          Kali = "";
          Linux = "";
          Mabox = "📦";
          Macos = "";
          Manjaro = "";
          Mariner = "🌊";
          MidnightBSD = "🌘";
          Mint = "󰣭";
          NetBSD = "🚩";
          NixOS = "";
          OpenBSD = "";
          OpenCloudOS = "☁️";
          openEuler = "🦉";
          openSUSE = "";
          OracleLinux = "🦴";
          Pop = "";
          Raspbian = "";
          Redhat = "";
          RedHatEnterprise = "";
          RockyLinux = "";
          Redox = "🧪";
          Solus = "";
          SUSE = "";
          Ubuntu = "";
          Ultramarine = "🔷";
          Unknown = "?";
          Void = "";
          Windows = "";
        };
      };
      shell = {
        disabled = false;

        format = "[$indicator]($style)";

        bash_indicator = "󱆃";
        fish_indicator = "";
        zsh_indicator = "zsh";
        powershell_indicator = "󰨊";
        pwsh_indicator = "󰨊";
        ion_indicator = "ion";
        elvish_indicator = "elvish";
        tcsh_indicator = "tcsh";
        xonsh_indicator = "xonsh";
        cmd_indicator = "";
        nu_indicator = "nu";
        unknown_indicator = "?";
      };
      username = {
        show_always = true;

        format = "[$user]($style)";
      };
      hostname = {
        ssh_only = false;
        ssh_symbol = "🌐";

        trim_at = "";

        format = "[$hostname$ssh_symbol]($style)";
      };

      direnv = {
        disabled = false;

        format = "[$symbol is $loadedloaded & $allowedallowed]($style)";
        symbol = "";

        allowed_msg = "()[green bold]";
        not_allowed_msg = "()[red bold]";

        loaded_msg = "()[green bold]";
        unloaded_msg = "()[red bold]";
      };
      nix_shell = {
        heurisitc = true;

        format = " via [$symbol$state(\($name\))]($style)";
        symbol = "";

        pure_msg = " pure ";
        impure_msg = " impure ";
        unknown_msg = " ";
      };
    };
  };
}
