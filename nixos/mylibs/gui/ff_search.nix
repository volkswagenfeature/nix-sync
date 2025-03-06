{config, ...}:
let 
  ver = config.system.nixos.release;
in
{
  Remove = [
    "Bing"
    "Amazon.com"
    "eBay"
  ];
  Add = [
    { 
      Name = "Github Nix Code"; 
      URLTemplate = "https://github.com/search?type=code&q=lang:nix+NOT+is:fork+{searchTerms}"; 
      Method = "GET"; 
      IconURL = "https://github.com/favicon.ico"; 
      Alias = "@gitn"; 
    }

    { 
      Name = "Github Search Code"; 
      URLTemplate = "https://github.com/search?type=code&q=NOT+is:fork+{searchTerms}"; 
      Method = "GET"; 
      IconURL = "https://github.com/favicon.ico"; 
      Alias = "@git"; 
    }

    { 
      Name = "Noogle"; 
      URLTemplate = "https://noogle.dev/q?term={searchTerms}"; 
      Method = "GET"; 
      IconURL = "https://noogle.dev/favicon.png"; 
      Alias = "@ng"; 
    }

    { 
      Name = "Nixpkgs"; 
      URLTemplate = "https://github.com/search?type=code&q=repo:NixOS/nixpkgs+lang:nix+{searchTerms}"; 
      Method = "GET"; 
IconURL = "https://github.com/favicon.ico";
      Alias = "@gitpkgs"; 
    }

    { 
      Name = "Home Manager"; 
      URLTemplate = "https://github.com/search?type=code&q=repo:nix-community/home-manager+lang:nix+{searchTerms}"; 
      Method = "GET"; 
      Alias = "@hm"; 
    }

    { 
      Name = "Home Manager Options"; 
      URLTemplate = "https://home-manager-options.extranix.com/?release=release-${ver}&query={searchTerms}"; 
      Method = "GET"; 
      IconURL = "https://home-manager-options.extranix.com/images/favicon.png"; 
      Alias = "@hmo"; 
    }

    { 
      Name = "NixOS Options"; 
      URLTemplate = "https://search.nixos.org/options?channel=${ver}&query={searchTerms}"; 
      Method = "GET"; 
      Alias = "@nops"; 
    }

    {
      Name = "NixOS Packages";
      URLTemplate = "https://search.nixos.org/packages?channel=${ver}&query={searchTerms}";
      Method = "GET";
      Alias = "@npkg";
    }
  ];
}
