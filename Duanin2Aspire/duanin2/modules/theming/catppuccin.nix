{ inputs, ... }: {
  imports = [ inputs.catppuccin.homeModules.catppuccin ];
  # disabledModules = [ ./gtk.nix ];
  
  catppuccin = {
    enable = true;

    flavor = "frappe";
    accent = "green";
  };
}
