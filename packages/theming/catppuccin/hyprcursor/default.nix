/*
Copyright (c) 2003-2024 Eelco Dolstra and the Nixpkgs/NixOS contributors

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

{ lib, stdenvNoCC, fetchFromGitHub, hyprcursor, unzip, xcur2png }:

let
  dimensions = {
    palette = [ "Frappe" "Latte" "Macchiato" "Mocha" ];
    color = [ "Blue" "Dark" "Flamingo" "Green" "Lavender" "Light" "Maroon" "Mauve" "Peach" "Pink" "Red" "Rosewater" "Sapphire" "Sky" "Teal" "Yellow" ];
  };
  product = lib.attrsets.cartesianProductOfSets dimensions;
  variantName = { palette, color }: (lib.strings.toLower palette) + color;
  variants = map variantName product;
in
stdenvNoCC.mkDerivation rec {
  pname = "catppuccin-hyprcursors";
  version = "0.2.0";
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "cursors";
    rev = "v${version}";
    sha256 = "sha256-TgV5f8+YWR+h61m6WiBMg3aBFnhqShocZBdzZHSyU2c=";
    sparseCheckout = [ "cursors" ];
  };

  nativeBuildInputs = [
    hyprcursor
    unzip
    xcur2png
  ];

  outputs = variants ++ [ "out" ]; # dummy "out" output to prevent breakage

  outputsToInstall = [];

  installPhase = ''
    runHook preInstall

    for output in $(getAllOutputNames); do
      if [ "$output" != "out" ]; then
        local outputDir="''${!output}"
        local iconsDir="$outputDir"/share/icons

        mkdir -p "$iconsDir"

        # Convert to kebab case with the first letter of each word capitalized
        local variant=$(sed 's/\([A-Z]\)/-\1/g' <<< "$output")
        local variant=''${variant^}

        unzip "cursors/Catppuccin-$variant-Cursors.zip" -d "$outputDir/tmp"

        hyprcursor-util -x "$outputDir/tmp/Catppuccin-$variant-Cursors" -o "$outputDir/tmp"

        sed -Ei -e "s/^name = .*$/name = $output/" -e "s/^description = .*$/description = ${meta.description}/" "$outputDir/tmp/extracted_Catppuccin-$variant-Cursors/manifest.hl"

        hyprcursor-util -c "$outputDir/tmp/extracted_Catppuccin-$variant-Cursors" -o "$iconsDir"

        mv "$iconsDir/theme_$output" "$iconsDir/Catppuccin-$variant-Hyprcursors"

        rm -rf "$outputDir/tmp"
      fi
    done

    # Needed to prevent breakage
    mkdir -p "$out"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Catppuccin cursor theme based on Volantes";
    homepage = "https://github.com/catppuccin/cursors";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dixslyf ];
  };
}