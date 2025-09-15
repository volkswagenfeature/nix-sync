{
  pkgs,
  ...
}:
{
  fileToStore = filepath : name : (derivation {
    inherit name;
    system = "x86_64-linux";
    builder = pkgs.writeScript "simpleBuilder.sh" "cp $src $out";
    src = filepath;
  });
}
