{ lib, stdenvNoCC, fetchFromGitHub, format ? "toml" }: let
  variants = [ "latte" "frappe" "macchiato" "mocha" ];
  genFiles = variants: fileExtension: map (variant: "catppuccin-${variant}.${fileExtension}") variants; 
  
  srcRef =
    if format == "toml" then { ref = "main"; sparseCheckout = genFiles variants "toml"; } 
    else if format == "yaml" then { rev = "yaml"; sparseCheckout = genFiles variants "yml"; }
    else throw "format must be either toml or yaml.";
in stdenvNoCC.mkDerivation {
  pname = "catppuccin-alacritty";
  version = format;
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "alacritty";
    hash = "";
  } // srcRef;

  outputs = variants ++ [ "out" ]; # dummy "out" output to prevent breakage

  outputsToInstall = [];

  installPhase = ''
    runHook preInstall

    for output in $(getAllOutputNames); do
      if [ "$output" != "out" ]; then
        local outputDir="''${!output}"

        local ext="${if format == "toml" then "toml" else "yml"}"

        mkdir 

        mv "alacritty/catppuccin-$output.$ext" "$outputDir/alacritty.$ext"
      fi
    done

    # Needed to prevent breakage
    mkdir -p "$out"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel theme for Alacritty.";
    homepage = "https://github.com/catppuccin/alacritty";
    license = licenses.mit;
    platforms = with platforms; openbsd ++ linux ++ windows ++ darwin;
    maintainers = with maintainers; [ duanin2 ];
  };
}