{ inputs, ... }: {
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
  # disabledModules = [ ./gtk.nix ];
  
  catppuccin = {
    enable = true;

    flavor = "frappe";
    accent = "green";
  };
}
