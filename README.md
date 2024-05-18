# nix-sync
---
My nixos system configuration

## Setup:
Be sure to enable the hooks with
`git config --local core.hooksPath $(git rev-parse --show-toplevel)/hooks/`

## Features:

### Secrets management:
- [secret_management.sh](secret_management.sh)
- [pre-commit hook](hooks/pre-commit)

I protect some variables I want to keep private using a file that is not in this repo named `secrets.nix` These two files help me avoid accidentally committing it, or any of its contents.

The hook is just a pair of simple checks: that you're not committing any files you shouldn't be, and that you're not committing any strings that are present in your secrets.nix file. The secrets_management.sh is a setup for preventing secrets.nix from appearing where it might get accidentally committed, while still working with the flake features that require all files to be added to the git repo index. `--intent-to-add` and `--assume-unchanged` let you have a file in the git index, while ensuring that git won't try to track its contents.

`secret_management.sh` can be run as `secret_management.sh set`, which adds `secrets.nix` to the index withoug adding its contents, or `secret_management.sh unset` which removes it from the index.

The hook is designed to be automatically run by git when you have `core.hooksPath` configured, but also can be run as `pre_commit all` in order to check every file in your git repo (except excluded ones like secrets.nix) for the forbidden strings.
