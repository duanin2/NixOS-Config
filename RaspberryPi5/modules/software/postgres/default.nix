{ lib, ... }: {
  services.postgresql = {
    enable = lib.mkForce true;
  };

  environment.persistence."/persist".directories = [
    "/var/lib/postgresql"
  ];
}