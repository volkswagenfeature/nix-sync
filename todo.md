- get better sway titles
- (better) Screenshot system
- lock screen
- Try to fix hibernation again
- Rolling backup system
- Add a check for firmware when updating, or at least when committing to git
- Fingerprint logon?
- Set up a script that updates the flake and nixos overnight
- Set up a script that pulls down any flakes in my projects directories overnight so that they run without downloading anything.
- Add locate (nixpkgs#mlocate), and write a job that runs updatedb alongside it. 
- Add a system that sets envars for the hook scripts in Nix, ensures they have the dependencies they need, and then copies them to the nix store and symlinks them to the right spot in the .git folder

- Re-factor my modules to use CallPackage

- Firefox
    - Add keyboard shortcut using the [firefox autoconfig](https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig) feature to open ai chat sidebar.
    - Set [Firefox File Chooser](https://superuser.com/questions/1740620/firefox-file-chooser-choose-another) to something like ranger, also see if you can switch out the file selection dialog that other apps use by default.
- Add Lorri and configure to auto-update when on battery power.
- VIM:
    - Add auto mark, so whenever I search, jump to top or bottom, or otherwise move, vim adds a mark where I was before so I can go back.
- Set enviroment variables: Prioritize coreutils over toybox/busybox. Set $EDITOR, others.
- Editor:
    - Change the color scheme so args aren't incandescent red. The contents of sets and lists in nix count under that category, so it makes package lists look like they're on fire.
    - add ANSI escape code support to treesitter: https://git.sr.ht/~rockorager/tree-sitter-ansi
    - figure out what "snippets" are as compared to standard completion in my completion setup, and why they get to use "tab". I sel-next and sel-prev more than I use snippets. 

- System bugs:
    - Firefox is slow on making some requests (AJAX???). Might be due to something related to Adblock Origin.
    - Devtools is missing everything except HTML 
