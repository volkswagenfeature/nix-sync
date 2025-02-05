{config,lib,nixpkgs,...}:
{
  options.fonts.convertFonts = mkOption {
    type = types.listOf types.str;
    description = "List of paths to font files (.ttf or others) that will be converted to .psf format for use in the virtual terminal.";
    default = [];
  };
  
  config = mkIf ( options.fonts.convertedFonts != []) {
    nixpkgs.stdenvNoCC.mkDerivation {
      name = "TTFtoPSF";
      nativeBuildInputs = [
      ]
      src = 

    };
  };
}

