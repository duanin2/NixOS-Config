{ inputs, config, ... }: let
  cfg = config.mailserver;
in {
  imports = [ inputs.simple-nixos-mailserver.nixosModule ];

  mailserver = {
    enable = true;
    fqdn = "mail.duanin2.top";
    sendingFqdn = "109-80-156-99.rcr.o2.cz"; # Residential ISPs don't allow you to change rDNS.
    domains = [ "duanin2.top" ];

    enableImap = false;
    enablePop3 = false;
    enableSubmission = false;
    enablePop3Ssl = true;

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "duanin2@duanin2.top" = {
        hashedPasswordFile = "/var/lib/secrets/mailPass/duanin2";
        aliases = [
          "postmaster@duanin2.top"
          "admin@duanin2.top"
          "matrix-admin@duanin2.top"
          "abuse@duanin2.top"
          "dusan.till@duanin2.top"
        ];
        aliasesRegexp = [
          "/^duanin2-.*@duanin2\\.top$/"
          "/^dusan.till-.*@duanin2\\.top$/"
        ];
        sieveScript = ''
require ["fileinto", "mailbox"];

if address :matches :localpart ["to", "Deliver-To"] "abuse" {
    fileinfo :create "AbuseReport";
    stop;
}
if address :matches :localpart ["to", "Deliver-To"] ["postmaster", "*admin"] {
    fileinfo :create "Admin";
    stop;
}
if address :matches :localpart ["to", "Deliver-To"] "dusan.till" {
    fileinfo :create "Personal";
    stop;
}
if address :matches :localpart ["to", "Deliver-To"] "dusan.till-*" {
    fileinfo :create "MassMail-Personal";
}
if address :matches :localpart ["to", "Deliver-To"] "duanin2-*" {
    fileinfo :create "MassMail";
}

# This must be the last rule, it will check if list-id is set, and
# file the message into the Lists folder for further investigation
if header :matches "list-id" "<?*>" {
    fileinto :create "Lists";
    stop;
}
        '';
      };
      "matrix-noreply@duanin2.top" = {
        sendOnly = true;
        hashedPasswordFile = "/var/lib/secrets/mailPass/matrix";
      };
    };

    useUTF8FolderNames = true;
    useFsLayout = true;

    # Use my preexisting wildcard acme certificate.
    certificateScheme = "acme";
    acmeCertificateName = "duanin2.top";
  };

  services.nginx.virtualHosts."rspamd.duanin2.top" = {
    onlySSL = true;
    basicAuthFile = "/var/lib/secrets/rspamdBasicAuth";
    locations."/".proxyPass = "http://unix:/run/rspamd/worker-controller.sock:/";
  };

  environment.persistence."/persist" = {
    directories = [
      cfg.indexDir
      cfg.mailDirectory
      cfg.sieveDirectory
      cfg.dkimKeyDirectory
    ];
  };
}
