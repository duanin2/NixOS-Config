{ ... }: {
  programs.fuse = {
    userAllowOther = true;
    mountMax = 32767;
  };
}
