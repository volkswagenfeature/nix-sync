{...}:
let
    install = extID:{
      ${extID} = {
        installation_mode = "force_installed"; 
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${extID}/latest.xpi";
      };
    };
    block = extID:{
      installation_mode = "blocked";
    };
in
{
  ExtensionSettings = {}  
  
     // install "addon@darkreader.org" 
     // install "keepassxc-browser@keepassxc.org"
     // install "firefox@ghostery.com"
     // install "simple-tab-groups@drive4ik" 
    # Violentmonkey
     // install "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}"
     // install "uBlock0@raymondhill.net" # ????
     # "Autumn Twining" theme
     // install "{d470e2a3-6538-4b76-938e-252ce9d8c058}"
/*
     # Themes
     // install "firefox-compact-dark@mozilla.org" #404s
     // install "default-theme@mozilla.org" #404's
     // block "addons-search-detection@mozilla.com"
     // block "amazondotcom@search.mozilla.org"
     // block "bing@search.mozilla.org"
     #// block "google@search.mozilla.org"
     */
     ;
}
