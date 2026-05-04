{lib,pkgs,config,...}:
with lib;
let
  secrets = (import ../../secrets.nix {});
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
  {
    programs.firefox = {
      package = pkgs.firefox-bin;
      enable = true;
      languagePacks = ["en-US"];
      # Check about:policies#documentation for options.
      policies = {
        # Copied from https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
          Locked = true;
        }; 
        DisablePocket = true;

        # My additions:
        FirefoxSuggest = {
          WebSuggestions = true; # But I'm keeping an eye on you >:(
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };

        ExtensionSettings = (import ./ff_extensions.nix {}).ExtensionSettings;

        SearchEngines = (import ./ff_search.nix {inherit config;});

        Preferences = {
          # Ad mitigation
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.topsites.contile.endpoint" = {Value = ""; Status = "locked";};
          "browser.newtabpage.activity-stream.discoverystream.sponsored-collections.enabled" = lock-false;
          "browser.newtabpage.activity-stream.discoverystream.newSponsoredLabel.enabled" = lock-false;
          "browser.urlbar.quicksuggest.impressionCaps.sponsoredEnabled" = lock-false;
          "browser.urlbar.sponsoredTopSites" = lock-false;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;



          # Additional settings from https://www.reddit.com/r/privacytoolsIO/comments/mqy5u1/firefox_privacy_tweaks/
          # Blocked web apis
          "geo.enabled" = {Value = true;}; # Leaving this on.
          "beacon" = lock-false; # API used to send requests after a page unloads. Mostly used by trackers.
          "dom.battery.enabled" = lock-false;
          "dom.event.clipboardevents.enabled" = lock-false;

          "browser.send_pings" = lock-false; # http://kb.mozillazine.org/Browser.send_pings
          "browser.urlbar.speculativeConnect.enabled" = lock-true; # pre-loads pages. Seems like a solid improvment to me.

          "webgl.disabled" = lock-false; # As a stateful API it allows tracking via GPU fingerprinting. 
          "dom.webgpu.enabled" = lock-true; # Supposed to be better.
          # Forward-looking privacy and security functionality
          #"browser.sessionstore.privacy_level" = {Value = 2; Status = "locked"} ; # Disables session restoration. I don't actually want this. 
          "network.dns.echconfig.enable" = lock-true; #https://wiki.mozilla.org/Security/Encrypted_Client_Hello
          "network.dns.use_https_rr_as_altsvc" = lock-true; # related to above.
          "network.trr.mode" = {Value = 2; Status = "locked";}; #https://wiki.mozilla.org/Trusted_Recursive_Resolver
          "dom.private-attribution.submission.enabled" = lock-false;

          # Google Safe Browsing disable
          # Apparently, I've been sending google all my pages for "security"
          # Screw that.
          # They seem to offer a pseudo anonymized service that I might be able to configure
          # https://developers.google.com/safe-browsing/ohttp/reference 
          "browser.safebrowsing.phishing.enabled" = lock-false;
          "browser.safebrowsing.malware.enabled:" = lock-false;


          # Activity stream?
          "browser.newtabpage.activity-stream.enabled" = lock-true;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;

          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;

          # Other features
          #"network.IDN_show_punycode" = lock-true;

          # Turn off built-in password management
          # This also includes a tool that is supposed to notify me if a site has
          # a breach. I should track down the data source it's pulling from and
          # make a manual solution.
          "signon.passwordEditCapture.enabled" = lock-false;
          "signon.privateBrowsingCapture.enabled" = lock-false;
          "signon.rememberSignons" = lock-false;
          "signon.rememberSignons.visibilityToggle" = lock-false;
        };
      };
    };
  }
