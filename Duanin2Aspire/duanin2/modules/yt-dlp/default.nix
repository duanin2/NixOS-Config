{ ... }: {
  programs.yt-dlp = {
    enable = true;

    settings = {
      update = false;

      write-thumbnail = true;
      
      format-sort = "width:1920,height:1080,fps:60,hdr:sdr,+vcodec:h265,vext,channels:2,aext,quality,+size";
      prefer-free-formats = true;

      write-subs = true;
      sub-langs = "all";

      embed-chapters = true;

      sponsorblock-mark = "all";
      sponsorblock-remove = "all";
    };
  };
}
