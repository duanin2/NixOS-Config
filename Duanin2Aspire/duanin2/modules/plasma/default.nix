{ inputs, config, pkgs, persistDirectory, lib, wallpaper, ... }: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ./konsole.nix
  ];
  
  programs.plasma = {
    enable = true;

    overrideConfig = true;
    
    startup.desktopScript = {
      "setup_panels" = let
        windowTitleList = list: lib.concatMapStringsSep "," (value: toString value) list;
        windowButtonsList = list: lib.concatMapStringsSep "|" (value: ''${toString value}'') list;
        panels = [
          {
            height = 50;
            floating = true;
            alignment = "center";
            hiding = "dodgewindows";
            location = "bottom";
            lengthMode = "fit";
            widgets = [
              {
                type = "org.kde.plasma.kickoff";
                config = {
                  General = {
                    icon = "distributor-logo-nixos";
                    systemFavorites = "suspend\\,hibernate\\,reboot\\,shutdown";
                  };
                };
                globalConfig = { };
              }
              {
                type = "org.kde.plasma.icontasks";
                config = {
                  General = {
                    groupedTaskVisualization = 1;
                    iconSpacing = 0;
                  };
                };
                globalConfig = { };
              }
            ];
          }
          {
            height = 32;
            floating = false;
            alignment = "center";
            hiding = "none";
            location = "top";
            lengthMode = "fill";
            widgets = [
              {
                type = "org.kde.windowbuttons";
                config = {
                  General = {
                    inactiveStateEnabled = true;
                    perScreenActive = true;
                    useCurrentDecoration = true;
                    visibility = "ActiveMaximizedWindow";
                    buttons = windowButtonsList [ 2 10 3 4 5 9 ];
                  };
                };
                globalConfig = { };
              }
              {
                type = "org.kde.windowtitle";
                config = {
                  General = {
                    filterActivityInfo = false;
                    lengthFirstMargin = 2;
                    lengthLastMargin = 2;
                    spacing = 2;
                    placeHolder = "NixOS";
                    subsMatch = windowTitleList [
                      "Plasma-Interactiveconsole"
                      "Mpv Přehrávač"
                      "VSCodium - URL Handler"
                    ];
                    subsReplace = windowTitleList [
                      "Interactive Plasma Console"
                      "MPV"
                      "VSCodium"
                    ];
                  };
                };
                globalConfig = { };
              }
              {
                type = "org.kde.plasma.appmenu";
                config = { };
                globalConfig = { };
              }
              {
                type = "org.kde.plasma.panelspacer";
                config = { };
                globalConfig = { };
              }
              {
                type = "org.kde.plasma.systemtray";
                config = { };
                globalConfig = { };
              }
              {
                type = "org.kde.plasma.digitalclock";
                config = {
                  Appearance = {
                    displayTimezoneFormat = "FullText";
                    showDate = false;
                    showSeconds = "Always";
                    showWeekNumbers = true;
                  };
                };
                globalConfig = { };
              }
              {
                type = "org.kde.windowbuttons";
                config = {
                  General = {
                    inactiveStateEnabled = true;
                    perScreenActive = true;
                    useCurrentDecoration = true;
                    visibility = "ActiveMaximizedWindow";
                    buttons = windowButtonsList [ 3 4 5 10 2 9 ];
                  };
                };
                globalConfig = { };
              }
              {
                type = "org.kde.plasma.showdesktop";
                config = { };
                globalConfig = { };
              }
            ];
          }
        ];
      in {
        text = ''
panels().forEach((panel) => panel.remove());

${lib.concatMapStringsSep "\n" (panel: ''
{
  const panel = new Panel();
  panel.height = ${toString panel.height};
  panel.floating = ${lib.boolToString panel.floating};
  panel.alignment = "${toString panel.alignment}";
  panel.hiding = "${toString panel.hiding}";
  panel.location = "${toString panel.location}";
	panel.lengthMode = "${toString panel.lengthMode}";

  ${lib.concatMapStringsSep "\n" (widget: let
    recurseIntoConfig = groups: config: lib.mapAttrsToList (name: value: if
      builtins.isAttrs value
      then
        recurseIntoConfig (groups ++ [ name ]) value
      else 
        { inherit groups; name = (toString name); value = (if builtins.isBool value then (lib.boolToString value) else toString value); })
      config;
  in ''
  {
    const widget = panel.addWidget("${toString widget.type}");

    ${lib.concatMapStringsSep "\n" (config: ''
    widget.currentConfigGroup = [ ${lib.concatMapStringsSep " " (group: "'${builtins.replaceStrings [ "'" ] [ "\'" ] group}'") config.groups} ];
    widget.writeConfig('${builtins.replaceStrings [ ''"'' ] [ ''\"'' ] config.name}', '${builtins.replaceStrings [ "'" ] [ "\'" ] config.value}');
    '') (lib.lists.flatten (recurseIntoConfig [ ] widget.config))}
    widget.currentConfigGroup = [ ];

    ${lib.concatMapStringsSep "\n" (config: ''
    widget.currentGlobalConfigGroup = [ ${lib.concatMapStringsSep " " (group: "'${builtins.replaceStrings [ "'" ] [ "\'" ] group}'") config.groups} ];
    widget.writeGlobalConfig('${builtins.replaceStrings [ "'" ] [ "\'" ] config.name}', '${builtins.replaceStrings [ "'" ] [ "\'" ] config.value}');
    '') (lib.lists.flatten (recurseIntoConfig [ ] widget.globalConfig))}
    widget.currentGlobalConfigGroup = [ ];
  }
  '') panel.widgets}
}
'') panels}
        '';
        priority = 3;
      };
    };
    
    powerdevil = {
      AC = {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 60 * 20;
        };
        dimDisplay = {
          enable = true;
          idleTimeout = 60 * 9;
        };
        powerButtonAction = "lockScreen";
        turnOffDisplay = {
          idleTimeout = 60 * 10;
          idleTimeoutWhenLocked = 60 * 10;
        };
        whenLaptopLidClosed = "sleep";
        whenSleepingEnter = "standby";
      };
      battery = {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 60 * 10;
        };
        dimDisplay = {
          enable = true;
          idleTimeout = 60 * 4;
        };
        powerButtonAction = "sleep";
        turnOffDisplay = {
          idleTimeout = 60 * 5;
          idleTimeoutWhenLocked = 60 * 5;
        };
        whenLaptopLidClosed = "sleep";
        whenSleepingEnter = "standby";
      };
      lowBattery = {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 60 * 2;
        };
        dimDisplay = {
          enable = true;
          idleTimeout = 30;
        };
        powerButtonAction = "sleep";
        turnOffDisplay = {
          idleTimeout = 60 * 1;
          idleTimeoutWhenLocked = "immediately";
        };
        whenLaptopLidClosed = "sleep";
        whenSleepingEnter = "standby";
      };
    };
    window-rules = [
      {
        description = "Center the About Mozilla Firefox window";
        match = {
          title = {
            value = "About Mozilla Firefox";
            type = "exact";
          };
          window-class = {
            value = "firefox firefox";
            match-whole = true;
            type = "exact";
          };
        };
      }
    ];
    windows = {
      allowWindowsToRememberPositions = true;
    };
    workspace = {
      colorScheme = "CatppuccinFrappeGreen";
      cursor = let
        cfg = config.home.pointerCursor;
      in {
        theme = "catppuccin-frappe-green-cursors";
        size = cfg.size;
      };
      iconTheme = "Papirus-Dark";
      lookAndFeel = "Catppuccin-Frappe-Green";
      splashScreen = {
        theme = "catppuccin-frappe-green-cursors";
      };
      inherit wallpaper;
      windowDecorations = {
        library = "org.kde.kwin.aurorae";
        theme = "__aurorae__svg__CatppuccinFrappe-Modern";
      };
    };
    desktop = {
      icons = {
        alignment = "left";
        arrangement = "topToBottom";
        lockInPlace = false;
        previewPlugins = [
          "audiothumbnail"
          "fontthumbnail"
        ];
        sorting = {
          foldersFirst = true;
          mode = "name";
        };
      };
    };
    input = {
      keyboard = {
        layouts = [
          {
            layout = "cz";
          }
        ];
        model = "acer_laptop";
        numlockOnStartup = "on";
      };
      touchpads = [
        {
          enable = true;
          
          name = "ELAN0501:00 04F3:3019 Touchpad";
          vendorId = "04f3";
          productId = "3019";

          disableWhileTyping = true;
          leftHanded = false;
          middleButtonEmulation = false;
          naturalScroll = false;
          pointerSpeed = 0;
          rightClickMethod = "twoFingers";
          scrollMethod = "twoFingers";
          tapAndDrag = true;
          tapDragLock = true;
          tapToClick = true;
          twoFingerTap = "rightClick";
        }
      ];
    };
    kscreenlocker = {
      appearance = {
        alwaysShowClock = true;
        showMediaControls = true;
        inherit wallpaper;
      };
      autoLock = true;
      lockOnResume = true;
      passwordRequired = true;
      passwordRequiredDelay = 10;
      timeout = 2;
    };
    kwin = {
      borderlessMaximizedWindows = true;
      cornerBarrier = false;
      edgeBarrier = 0;
      effects = {
        blur = { enable = true; };
        cube = { enable = false; };
        desktopSwitching = { animation = "slide"; };
        dimAdminMode = { enable = true; };
        dimInactive = { enable = false; };
        fallApart = { enable = false; };
        fps = { enable = false; };
        minimization = { animation = "squash"; };
        shakeCursor = { enable = false; };
        slideBack = { enable = false; };
        snapHelper = { enable = true; };
        translucency = { enable = false; };
        windowOpenClose = { animation = "scale"; };
      };
      nightLight = {
        enable = true;
        mode = "times";
        temperature = { day = 6500; night = 4500; };
        time = {
          evening = "20:00";
          morning = "06:00";
        };
        transitionTime = 60;
      };
      titlebarButtons = {
        left = [
          "on-all-desktops"
          "more-window-actions"
        ];
        right = [
          "help"
          "minimize"
          "maximize"
          "close"
        ];
      };
      virtualDesktops = {
        names = [
          "Plocha 1"
          "Plocha 2"
          "Plocha 3"
          "Plocha 4"
          "Plocha 5"
          "Plocha 6"
          "Plocha 7"
          "Plocha 8"
          "Plocha 9"
          "Plocha 10"
        ];
        rows = 2;
      };
    };
    fonts = {
      fixedWidth = {
        family = "Fira Code Nerd Font Mono";
        pointSize = 11;
      };
      general = {
        family = "Fira Code Nerd Font";
        pointSize = 11;
      };
      menu = {
        family = "Fira Code Nerd Font";
        pointSize = 11;
      };
      small = {
        family = "Fira Code Nerd Font";
        pointSize = 9;
      };
      toolbar = {
        family = "Fira Code Nerd Font";
        pointSize = 11;
      };
      windowTitle = {
        family = "Fira Code Nerd Font";
        pointSize = 11;
      };
    };
    
    shortcuts = {
      "ActivityManager"."switch-to-activity-717a174e-b3dc-4181-bdbb-4bef9ea50e5b" = [ ];
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
      "kaccess"."Toggle Screen Reader On and Off" = "Meta+Alt+S";
      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = ["Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku,Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku"];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = ["Microphone Mute" "Meta+Volume Mute,Microphone Mute" "Meta+Volume Mute,Ztlumit mikrofon"];
      "kmix"."mute" = "Volume Mute";
      "ksmserver"."Halt Without Confirmation" = [ ];
      "ksmserver"."Lock Session" = ["Meta+L" "Screensaver,Meta+L" "Screensaver,Lock Session"];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "ksmserver"."Log Out Without Confirmation" = [ ];
      "ksmserver"."LogOut" = [ ];
      "ksmserver"."Reboot" = [ ];
      "ksmserver"."Reboot Without Confirmation" = [ ];
      "ksmserver"."Shut Down" = [ ];
      "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      "kwin"."Cycle Overview" = [ ];
      "kwin"."Cycle Overview Opposite" = [ ];
      "kwin"."Decrease Opacity" = [ ];
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Expose" = "Ctrl+F9";
      "kwin"."ExposeAll" = ["Ctrl+F10" "Launch (C),Ctrl+F10" "Launch (C),Zapnout současná okna (na všech plochách)"];
      "kwin"."ExposeClass" = "Ctrl+F7";
      "kwin"."ExposeClassCurrentDesktop" = [ ];
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Increase Opacity" = [ ];
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      "kwin"."Move Tablet to Next Output" = [ ];
      "kwin"."MoveMouseToCenter" = "Meta+F6";
      "kwin"."MoveMouseToFocus" = "Meta+F5";
      "kwin"."MoveZoomDown" = [ ];
      "kwin"."MoveZoomLeft" = [ ];
      "kwin"."MoveZoomRight" = [ ];
      "kwin"."MoveZoomUp" = [ ];
      "kwin"."Overview" = "Meta+W";
      "kwin"."Setup Window Shortcut" = [ ];
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."Switch One Desktop Down" = "Meta+Ctrl+Down";
      "kwin"."Switch One Desktop Up" = "Meta+Ctrl+Up";
      "kwin"."Switch One Desktop to the Left" = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      "kwin"."Switch Window Down" = "Meta+Alt+Down";
      "kwin"."Switch Window Left" = "Meta+Alt+Left";
      "kwin"."Switch Window Right" = "Meta+Alt+Right";
      "kwin"."Switch Window Up" = "Meta+Alt+Up";
      "kwin"."Switch to Desktop 1" = "Meta++";
      "kwin"."Switch to Desktop 2" = "Meta+ě";
      "kwin"."Switch to Desktop 3" = "Meta+š";
      "kwin"."Switch to Desktop 4" = "Meta+č";
      "kwin"."Switch to Desktop 5" = "Meta+ř";
      "kwin"."Switch to Desktop 6" = "Meta+ž";
      "kwin"."Switch to Desktop 7" = "Meta+ý";
      "kwin"."Switch to Desktop 8" = "Meta+á";
      "kwin"."Switch to Desktop 9" = "Meta+í";
      "kwin"."Switch to Desktop 10" = "Meta+é";
      "kwin"."Switch to Desktop 11" = [ ];
      "kwin"."Switch to Desktop 12" = [ ];
      "kwin"."Switch to Desktop 13" = [ ];
      "kwin"."Switch to Desktop 14" = [ ];
      "kwin"."Switch to Desktop 15" = [ ];
      "kwin"."Switch to Desktop 16" = [ ];
      "kwin"."Switch to Desktop 17" = [ ];
      "kwin"."Switch to Desktop 18" = [ ];
      "kwin"."Switch to Desktop 19" = [ ];
      "kwin"."Switch to Desktop 20" = [ ];
      "kwin"."Switch to Next Desktop" = "Meta+Right";
      "kwin"."Switch to Next Screen" = "Meta+Left";
      "kwin"."Switch to Previous Desktop" = [ ];
      "kwin"."Switch to Previous Screen" = [ ];
      "kwin"."Switch to Screen 0" = [ ];
      "kwin"."Switch to Screen 1" = [ ];
      "kwin"."Switch to Screen 2" = [ ];
      "kwin"."Switch to Screen 3" = [ ];
      "kwin"."Switch to Screen 4" = [ ];
      "kwin"."Switch to Screen 5" = [ ];
      "kwin"."Switch to Screen 6" = [ ];
      "kwin"."Switch to Screen 7" = [ ];
      "kwin"."Switch to Screen Above" = [ ];
      "kwin"."Switch to Screen Below" = [ ];
      "kwin"."Switch to Screen to the Left" = [ ];
      "kwin"."Switch to Screen to the Right" = [ ];
      "kwin"."Toggle Night Color" = [ ];
      "kwin"."Toggle Window Raise/Lower" = [ ];
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Walk Through Windows Alternative" = [ ];
      "kwin"."Walk Through Windows Alternative (Reverse)" = [ ];
      "kwin"."Walk Through Windows of Current Application" = "Alt+`";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";
      "kwin"."Walk Through Windows of Current Application Alternative" = [ ];
      "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" = [ ];
      "kwin"."Window Above Other Windows" = [ ];
      "kwin"."Window Below Other Windows" = [ ];
      "kwin"."Window Close" = "Alt+F4";
      "kwin"."Window Fullscreen" = [ ];
      "kwin"."Window Grow Horizontal" = [ ];
      "kwin"."Window Grow Vertical" = [ ];
      "kwin"."Window Lower" = [ ];
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Maximize Horizontal" = [ ];
      "kwin"."Window Maximize Vertical" = [ ];
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window Move" = [ ];
      "kwin"."Window Move Center" = [ ];
      "kwin"."Window No Border" = [ ];
      "kwin"."Window On All Desktops" = [ ];
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window One Screen Down" = [ ];
      "kwin"."Window One Screen Up" = [ ];
      "kwin"."Window One Screen to the Left" = [ ];
      "kwin"."Window One Screen to the Right" = [ ];
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window Pack Down" = [ ];
      "kwin"."Window Pack Left" = [ ];
      "kwin"."Window Pack Right" = [ ];
      "kwin"."Window Pack Up" = [ ];
      "kwin"."Window Quick Tile Bottom" = [ ];
      "kwin"."Window Quick Tile Bottom Left" = [ ];
      "kwin"."Window Quick Tile Bottom Right" = [ ];
      "kwin"."Window Quick Tile Left" = [ ];
      "kwin"."Window Quick Tile Right" = [ ];
      "kwin"."Window Quick Tile Top" = [ ];
      "kwin"."Window Quick Tile Top Left" = [ ];
      "kwin"."Window Quick Tile Top Right" = [ ];
      "kwin"."Window Raise" = [ ];
      "kwin"."Window Resize" = [ ];
      "kwin"."Window Shade" = [ ];
      "kwin"."Window Shrink Horizontal" = [ ];
      "kwin"."Window Shrink Vertical" = [ ];
      "kwin"."Window to Desktop 1" = "Meta+1";
      "kwin"."Window to Desktop 2" = "Meta+2";
      "kwin"."Window to Desktop 3" = "Meta+3";
      "kwin"."Window to Desktop 4" = "Meta+4";
      "kwin"."Window to Desktop 5" = "Meta+5";
      "kwin"."Window to Desktop 6" = "Meta+6";
      "kwin"."Window to Desktop 7" = "Meta+7";
      "kwin"."Window to Desktop 8" = "Meta+8";
      "kwin"."Window to Desktop 9" = "Meta+9";
      "kwin"."Window to Desktop 10" = "Meta+0";
      "kwin"."Window to Desktop 11" = [ ];
      "kwin"."Window to Desktop 12" = [ ];
      "kwin"."Window to Desktop 13" = [ ];
      "kwin"."Window to Desktop 14" = [ ];
      "kwin"."Window to Desktop 15" = [ ];
      "kwin"."Window to Desktop 16" = [ ];
      "kwin"."Window to Desktop 17" = [ ];
      "kwin"."Window to Desktop 18" = [ ];
      "kwin"."Window to Desktop 19" = [ ];
      "kwin"."Window to Desktop 20" = [ ];
      "kwin"."Window to Next Desktop" = "Meta+Shift+Right";
      "kwin"."Window to Next Screen" = [ ];
      "kwin"."Window to Previous Desktop" = "Meta+Shift+Left";
      "kwin"."Window to Previous Screen" = [ ];
      "kwin"."view_actual_size" = [ ];
      "kwin"."view_zoom_in" = [ "Meta+=,Meta++" "Meta+=,Přiblížit" ];
      "kwin"."view_zoom_out" = "Meta+-";
      "mediacontrol"."mediavolumedown" = [ ];
      "mediacontrol"."mediavolumeup" = [ ];
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = [ ];
      "mediacontrol"."playmedia" = [ ];
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";
      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [ ];
      "org_kde_powerdevil"."powerProfile" = ["Battery" "Meta+B,Battery" "Meta+B,Přepnout profil napájení"];
      "plasmashell"."activate application launcher" = "Meta";
      "plasmashell"."activate task manager entry 1" = [ ];
      "plasmashell"."activate task manager entry 10" = [ ];
      "plasmashell"."activate task manager entry 2" = [ ];
      "plasmashell"."activate task manager entry 3" = [ ];
      "plasmashell"."activate task manager entry 4" = [ ];
      "plasmashell"."activate task manager entry 5" = [ ];
      "plasmashell"."activate task manager entry 6" = [ ];
      "plasmashell"."activate task manager entry 7" = [ ];
      "plasmashell"."activate task manager entry 8" = [ ];
      "plasmashell"."activate task manager entry 9" = [ ];
      "plasmashell"."clear-history" = [ ];
      "plasmashell"."clipboard_action" = "Meta+Ctrl+X";
      "plasmashell"."cycle-panels" = "Meta+Alt+P";
      "plasmashell"."cycleNextAction" = [ ];
      "plasmashell"."cyclePrevAction" = [ ];
      "plasmashell"."manage activities" = "Meta+Q";
      "plasmashell"."next activity" = "Meta+A,none,Procházet aktivity";
      "plasmashell"."previous activity" = "Meta+Shift+A,none,Procházet aktivity (pozpátku)";
      "plasmashell"."repeat_action" = ",Meta+Ctrl+R,Ručně vyvolat činnost nad současným obsahem schránky";
      "plasmashell"."show dashboard" = "Ctrl+F12";
      "plasmashell"."show-barcode" = [ ];
      "plasmashell"."show-on-mouse-pos" = "Meta+V";
      "plasmashell"."stop current activity" = "Meta+S";
      "plasmashell"."switch to next activity" = [ ];
      "plasmashell"."switch to previous activity" = [ ];
      "plasmashell"."toggle do not disturb" = [ ];
    };
    configFile = {
      "baloofilerc" = {
        "General" = {
          "dbVersion" = 2;
          "exclude filters" = "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.tfstate*,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.terraform,.venv,venv,core-dumps,lost+found";
          "exclude filters version" = 9;
        };
      };
      "dolphinrc" = {
        "General" = {
          "ViewPropsTimestamp" = "2024,8,19,23,1,30.028";
        };
        "KFileDialog Settings" = {
          "Places Icons Auto-resize" = false;
          "Places Icons Static Size" = 22;
        };
      };
      "kactivitymanagerdrc" = {
        "activities" = {
          "717a174e-b3dc-4181-bdbb-4bef9ea50e5b" = "Výchozí";
        };
        "main" = {
          "currentActivity" = "717a174e-b3dc-4181-bdbb-4bef9ea50e5b";
        };
      };
      "kded5rc" = {
        "Module-device_automounter" = {
          "autoload" = false;
        };
      };
      "kdeglobals" = {
        "DirSelect Dialog" = {
          "DirSelectDialog Size" = "828,560";
        };
        "KFileDialog Settings" = {
          "Allow Expansion" = false;
          "Automatically select filename extension" = true;
          "Breadcrumb Navigation" = true;
          "Decoration position" = 2;
          "LocationCombo Completionmode" = 5;
          "PathCombo Completionmode" = 5;
          "Show Bookmarks" = false;
          "Show Full Path" = false;
          "Show Inline Previews" = true;
          "Show Speedbar" = true;
          "Show hidden files" = false;
          "Sort by" = "Name";
          "Sort directories first" = true;
          "Sort hidden files last" = false;
          "Sort reversed" = false;
          "Speedbar Width" = 138;
          "View Style" = "DetailTree";
        };
        "WM" = {
          "activeBackground" = "227,229,231";
          "activeBlend" = "227,229,231";
          "activeForeground" = "35,38,41";
          "inactiveBackground" = "239,240,241";
          "inactiveBlend" = "239,240,241";
          "inactiveForeground" = "112,125,138";
        };
        "KScreen" = {
          "ScreenScaleFactors" = "eDP-1=1;";
          "XwaylandClientsScale" = false;
        };
      };
      "kwinrc" = {
        "Tiling" = {
          "padding" = 4;
        };
        "Tiling/1c624b6b-fbd3-5af5-93a9-4a7d55ba7893" = {
          "tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
        };
      };
      "plasma-localerc" = {
        "Formats" = {
          "LANG" = "cs_CZ.UTF-8";
        };
      };
    };
  };

  home.persistence.${persistDirectory} = {
    directories = [
      ".local/share/RecentDocuments"
      ".local/share/krdpserver"
      ".local/share/klipper"
    ];
  };
}
