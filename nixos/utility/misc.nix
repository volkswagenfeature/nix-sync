{
  pkgs,
  ...
}:
{
  fileToStore = filepath : name : (derivation {
    inherit name;
    system = builtins.currentSystem;
    builder = pkgs.writeScript "simpleBuilder.sh" "cp $src $out";
    src = filepath;
  });
}
