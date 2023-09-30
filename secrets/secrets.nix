let
  Duanin2Laptop = {
    duanin2.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbaTI8e0oVETErlRgEe1WO8FjUxZzfBdBKWGJV3eFx2 duanin2@gmail.com" ];
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBD3h35Dc0/Z8elhuih57P4KSsDuByt5zo2wmDdE/Rbu root@Duanin2Laptop"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrVIuJkiiHRphlVjCVrdaTC5NOXfQV4A5Cqh/qp41bdvC+muYWcZaODRue2XHg38E2Vn547mYRBex8nDPCwMcd4HSVmpeFGx9C6xlxCYeRJx7NBvEt1mMrTPGx2onXH0grnXsEv1/ifXIh24H1sJOujuMHAkR9TShPfy6YSOn3TPYqbAK1TJ27s5zxdnTJ4gANv/XNU/aCT6+Xya0yCEeFVK/aaeB07l6WiouY8CeBNlSKD8YZ/o9EsH3O4X4MhT3mRlr2wyFy78qpE25mXqA06u2yLhecSgVx49oSxCKaBmj98KOAbvNKi48xhkJo2raARPI2hxobr1RGhKT6pIS2JZNKOkA6kbL5BSmgjtYNeE46ZX7lcn3sg6nL1MVJhmxuVDDZmJNjknkrsSh5gO7Are/CHzjemt8zxKbdnV+9PS+ZeKyBE1bGJjJswCvHXcxDouCYq+LoFUoNKyAL7J+suwNB3YKiZ4GW/C1JPWac3RYaUjgiWEVAVCGw+GznSaAVp239+nVUlYuAtZIKb0/t7dVvJys3cFraHzg1d0IJffnBfhZIMAybUzbt+FG27y6sAYrtRmDQ4gQDHMONsGVu4HxeIXZkz2umPbvo+9wDC5EYqE+x9wdDXZcy8bVUY3uAYzYiRWZhGHzdsILNny7Zemnb03snb+w9kEwI8+ZnFQ== root@Duanin2Laptop"
    ];
  };
in {
  "Duanin2Laptop/duanin2/password.age".publicKeys = Duanin2Laptop.keys ++ Duanin2Laptop.duanin2.keys;
  "Duanin2Laptop/cryptkey.age".publicKeys = Duanin2Laptop.keys;
}
