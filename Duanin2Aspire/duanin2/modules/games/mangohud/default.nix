{ pkgs, ... }: {
  programs.mangohud = {
    enable = true;
    package = mangohud_git;

    settings = {
      # Performance
      "fps_limit" = 0;
      "vsync" = 3;
      "gl_vsync" = 1;

      # Header
      "custom_text_center" = "MangoHud";

      # General
      "time" = true;
      "time_format" = "%X";

      # GPU
      "gpu_core_clock" = true;
      "gpu_mem_clock" = true;
      "gpu_text" = "NVidia GeForce 940MX";
      "gpu_load_change" = true;
      "throttling_status" = true;
      "pci_dev" = "0:01:0.0";

      # CPU
      "cpu_stats" = true;
      "cpu_temp" = true;
      "cpu_text" = "Intel Core i7-6500U";
      "cpu_mhz" = true;
      "cpu_load_change" = true;
      "core_load" = true;
      "core_load_change" = true;

      # IO
      "io_read" = true;
      "io_write" = true;

      # RAMs
      "vram" = true;
      "ram" = true;
      "swap" = true;
      "procmem" = true;

      # Battery
      "battery" = true;
      "battery_icon" = true;
      "device_battery" = "gamepad,mouse";
      "device_battery_icon" = true;
      "battery_time" = true;

      # FPS
      "fps" = true;
      "fps_color_change" = true;
      "frametime" = true;
      "fps_metrics" = "avg,0.01";

      # Integrations
      "gamemode" = true;
      "vkbasalt" = true;
      "fsr" = true;
      "mangoapp_steam" = true;

      # Network
      "network" = "enp4s0f1,wlp3s0";

      # Style
      ## Font
      "font_size" = 10;
      "font_size_text" = 10;
      "font_file" = "${pkgs.fira-code-nerdfont}/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Light.ttf";
      "font_file_text" = "${pkgs.fira-code-nerdfont}/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Light.ttf";
      ## Position
      "position" = "top-left";
      "round_corners" = 8;
      "horizontal" = true;
      ## Color
      "background_alpha" = 0.2;
      "alpha" = 0.6;
    };
  };
}
