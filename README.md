# fusion809 Nixpkgs fork
This repository contains the upstream Nixpkgs packages, along with some others created (and I generally modify a little, usually package versions) and with some of my own. 

## Changes

* The version of Vim is kept at the latest version, with updates within a day of the upstream release.

* RuneScape's NXT Client ([`runescape-launcher`](pkgs/games/runescape-launcher)), based on NixOS/nixpkgs#31075. 

* Includes OpenRA-related packages mentioned added in https://github.com/NixOS/nixpkgs/pull/53300, but at more bleeding-edge versions.

## Installing packages

Building and installing packages in this repository should be as simple as running:

```bash
nix-env -f /path/to/nixpkgs -iA package
```

where `/path/to/nixpkgs` is, of course, the path to where this fork of nixpkgs is located on your local system. 
