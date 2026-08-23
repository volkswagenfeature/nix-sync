{
  pkgs,
  inputs,
  system,
  defaults,
  ...
}:let
  secrets = (import ../../secrets.nix {});


in {
  environment.systemPackages = with pkgs; [
    llm 
    ( pi-coding-agent.overrideAttrs ( oldAttrs: {
      postFixup = "wrapProgram $out/bin/pi --prefix PATH : ${
        lib.makeBinPath [
          ripgrep
          fd
          git
          ctx7
          (
           # Gets the same node that was used to build
           # defaults to pkgs node if can't find.
           # Makes npm available
           lib.lists.findFirst 
            (pkg: pkg.pname == "nodejs") 
            nodejs
            oldAttrs.buildInputs
          )
        ]
      }";
    }))
    #inputs.pidev2.packages.${inputs.defaults.system}.pi 
  ];
}
