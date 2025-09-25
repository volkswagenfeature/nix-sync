{
  pkgs,
  ...
}:
{
  fileToStore = filepath : name : (derivation {
    inherit name;
    system = "x86_64-linux";
    builder = pkgs.writeScript "simpleBuilder.sh" 
    ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.coreutils}/bin/cp $src $out
    '';
    src = filepath;
  });
}
