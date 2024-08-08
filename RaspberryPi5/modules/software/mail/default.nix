{ inputs, ... }: {
  imports = [ inputs.simple-nixos-mailserver.nixosModule ];

  mailserver = {
    enable = true;
    fqdn = "mail.duanin2.top";
    domains = [ "duanin2.top" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "duanin2@duanin2.top" = {
        hashedPasswordFile = "/a/file/containing/a/hashed/password";
        aliases = [ "postmaster@duanin2.top" "admin@duanin2.top" ];
      };
    };

    # Use my preexisting wildcard acme certificate.
    certificateScheme = "acme";
    acmeCertificateName = "duanin2.top";
  };
}
