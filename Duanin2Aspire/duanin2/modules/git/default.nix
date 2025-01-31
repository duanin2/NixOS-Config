{ ... }: {
  programs.git = {
    enable = true;

    userEmail = "duanin2-git@duanin2.top";
    userName = "Duanin2";

    extraConfig = {
      sendemail = {
        smtpserver = "duanin2.top";
        smtpuser = "duanin2@duanin2.top";
        smtpencryption = "ssl";
      };
    };
  };
}
