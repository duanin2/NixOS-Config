let
  Duanin2Laptop = {
    duanin2.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbaTI8e0oVETErlRgEe1WO8FjUxZzfBdBKWGJV3eFx2 duanin2@gmail.com" ];
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpQIixZD9N3rJZAyyG0WhluFYqzuRTyUaVOv4rzVMkC root@Duanin2Laptop"
    ];
  };
in {
  "users/duanin2/password.age".publicKeys = Duanin2Laptop.keys;
  "Duanin2Laptop/cryptkey.age".publicKeys = Duanin2Laptop.keys;
}
