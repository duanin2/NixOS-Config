{ pkgs, ... }: {
  enable = true;
  package = pkgs.mangohud_git;

  settings = {
    # Display
    vsync = 1;
    gl_vsync = 0;

    # Basic info
    custom_text_center = "MangoHUD";
    time = true;
    time_format = "%X";

    # GPU
    gpu_temp = true;
    gpu_core_clock = true;
    gpu_mem_clock = true;
    gpu_load_change = true;
    gpu_load_value = "25,50,75";
    gpu_load_color = "41FC02,ADFC02,FC9002,FC1302";
    throttling_status = true;
    gpu_name = true;

    # CPU
    cpu_temp = true;
    cpu_mhz = true;
    cpu_load_change = true;
    cpu_load_value = "25,50,75";
    cpu_load_color = "41FC02,ADFC02,FC9002,FC1302";

    # IO
    io_read = true;
    io_write = true;

    # Memory
    vram = true;
    ram = true;
    swap = true;

    # Battery info
    battery = true;
    battery_icon = true;
    battery_time = true;
    
    # FPS
    fps = true;
    fps_color_change = true;
    fps_value = "30,60";
    fps_color = "FC0202,FCFC02,23FC02";
    frametime = true;
    frame_timing = true;
    dynamic_frame_timing = true;

    # External programs
    gamemode = true;
    vkbasalt = true;
    fsr = true;
    
    # Layout
    position = "top-left";
    round_corners = 6;
  };
}
