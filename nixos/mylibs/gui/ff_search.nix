{...}:
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
		Alias = "@gn"; 
	}
	{ 
		Name = "Github Search Code"; 
		URLTemplate = "https://github.com/search?type=code&q=NOT+is:fork+{searchTerms}"; 
		Method = "GET"; 
		IconURL = "https://github.com/favicon.ico"; 
		Alias = "@gs"; 
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
		Alias = "@npkgs"; 
	}

	{ 
		Name = "Home Manager"; 
		URLTemplate = "https://github.com/search?type=code&q=repo:nix-community/home-manager+lang:nix+{searchTerms}"; 
		Method = "GET"; 
		Alias = "@hmgr"; 
	}

	{ 
		Name = "Home Manager Options"; 
		URLTemplate = "https://home-manager-options.extranix.com/?release=release-24.11&query={searchTerms}"; 
		Method = "GET"; 
		IconURL = "https://home-manager-options.extranix.com/images/favicon.png"; 
		Alias = "@oh"; 
	}

	{ 
		Name = "NixOS Options"; 
		URLTemplate = "https://search.nixos.org/options?channel=24.11&from=0&size=100&sort=alpha_asc&query={searchTerms}"; 
		Method = "GET"; 
		Alias = "@on"; 
	}
  ];
}
