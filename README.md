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
