{ inputs, ... }: {
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
  
  catppuccin = {
    enable = true;

    flavour = "frappe";
    accent = "green";
  };
}