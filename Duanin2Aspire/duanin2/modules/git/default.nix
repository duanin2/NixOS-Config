{ ... }: {
  programs.git = {
    enable = true;

    userEmail = "duanin2-git@duanin2.eu";
    userName = "Duanin2";

    extraConfig = {
      sendemail = {
        smtpserver = "duanin2.eu";
        smtpuser = "duanin2@duanin2.top";
        smtpencryption = "ssl";
      };
    };
  };
}
