{ inputs, ... }: {
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
  # disabledModules = [ ./gtk.nix ];
  
  catppuccin = {
    enable = true;

    flavour = "frappe";
    accent = "green";
  };
}
