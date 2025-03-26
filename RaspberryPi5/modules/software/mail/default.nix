{ inputs, config, lib, pkgs, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, ... }: let
  cfg = config.mailserver;
in {
  imports = [ inputs.simple-nixos-mailserver.nixosModule ];

  mailserver = {
    enable = true;
    fqdn = "mail.duanin2.eu";
    # sendingFqdn = "109-80-156-99.rcr.o2.cz"; # Residential ISPs don't allow you to change rDNS.
    domains = [ "duanin2.eu" "duanin2.top" ];

    enableImap = false;
    enablePop3 = false;
    enableSubmission = false;
    enablePop3Ssl = true;

    localDnsResolver = false;
    messageSizeLimit = 512 * 1024 * 1024;
    lmtpSaveToDetailMailbox = "yes";

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "duanin2@duanin2.top" = {
        hashedPasswordFile = "/var/lib/secrets/mailPass/duanin2";
        aliasesRegexp = [
          "/^postmaster(-.+)?@([A-Za-z0-9-]+-\.)*duanin2.(top|eu)$/"
          "/^abuse(-.+)?@([A-Za-z0-9-]+-\.)*duanin2.(top|eu)$/"
          "/^duanin2(-.+)?@([A-Za-z0-9-]+-\.)*duanin2\\.(top|eu)$/"
          "/^dusan.till(-.+)?@([A-Za-z0-9-]+-\.)*duanin2\\.(top|eu)$/"
          "/^admin(-.+)?@([A-Za-z0-9-]+-\.)*duanin2\\.(top|eu)$/"
        ];
        sieveScript = ''
require ["fileinto", "mailbox"];

if address :matches :localpart "to" "abuse" {
    fileinto :create "AbuseReport";
    stop;
}

if address :matches :localpart "to" ["postmaster", "admin", "admin-*"] {
    fileinto :create "Admin";
    stop;
}

if address :matches :localpart "to" "dusan.till" {
    fileinto :create "Personal";
    stop;
}
if address :matches :localpart "to" "dusan.till-*" {
    fileinto :create "MassMail-Personal";
}

if address :matches :localpart "to" "duanin2" {
    fileinto :create "Public";
}
if address :matches :localpart "to" "duanin2-*" {
    fileinto :create "MassMail-Public";
}

# This must be the last rule, it will check if list-id is set, and
# file the message into the Lists folder for further investigation
if header :matches "list-id" "<?*>" {
    fileinto :create "Lists";
    stop;
}
        '';
      };
      "noreply@matrix.duanin2.top" = {
        sendOnly = true;
        hashedPasswordFile = "/var/lib/secrets/mailPass/matrix";

        aliasesRegexp = [
          "^matrix-noreply@duanin2\\.(top|eu)$"
        ];
      };
    };

    useUTF8FolderNames = true;
    useFsLayout = true;

    # Use my preexisting wildcard acme certificate.
    certificateScheme = "acme";
    acmeCertificateName = "duanin2.eu";
  };

  services.postfix.config = {
    smtpd_tls_protocols = lib.mkForce "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
    smtp_tls_protocols = lib.mkForce "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
    smtpd_tls_mandatory_protocols = lib.mkForce "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
    smtp_tls_mandatory_protocols = lib.mkForce "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
  };

  services.nginx.virtualHosts = {
    "rspamd.duanin2.eu" = {
      onlySSL = true;
      useACMEHost = "duanin2.eu";
      basicAuthFile = "/var/lib/secrets/rspamdBasicAuth";
      
      locations."/".proxyPass = "http://unix:/run/rspamd/worker-controller.sock:/";

      extraConfig = (securitySetupNGINX [ "rspamd.duanin2.eu" ]) + securityHeaders + httpsUpgrade + ocspStapling;
    };
    "mta-sts.duanin2.eu" = {
      onlySSL = true;
      useACMEHost = "duanin2.eu";

      locations."= /.well-known/mta-sts.txt" = {
        alias = pkgs.writeText "mta-sts.txt" (builtins.replaceStrings [ "\n" ] [ "\r\n" ] ''
version: STSv1
mode: enforce
max_age: ${toString (3 * 30 * 24 * 60 * 60)}
mx: mail.duanin2.eu
mx: *.duanin2.eu
mx: mail.duanin2.top
mx: *.duanin2.top
        '');
      };

      extraConfig = (securitySetupNGINX [ "mta-sts.duanin2.eu" ]) + securityHeaders + httpsUpgrade + ocspStapling;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      cfg.mailDirectory
      cfg.sieveDirectory
      cfg.dkimKeyDirectory
      "/var/lib/postfix/queue"
      "/var/lib/redis-rspamd"
    ] ++ (if (builtins.typeOf cfg.indexDir == "string") then [ cfg.indexDir ] else [ ]);
  };
}
