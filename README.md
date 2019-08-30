# fusion809 Nixpkgs fork
This repository contains the upstream Nixpkgs packages, along with some others created (and I generally modify a little, usually package versions) and with some of my own. 

* The version of Vim is kept at the latest version, with updates within a day of the upstream release.

* RuneScape's NXT Client ([`runescape-launcher`](pkgs/games/runescape-launcher)), based on NixOS/nixpkgs#31075. 
=======
```
% git remote add channels https://github.com/NixOS/nixpkgs-channels.git
```

For stability and maximum binary package support, it is recommended to maintain
custom changes on top of one of the channels, e.g. `nixos-19.03` for the latest
release and `nixos-unstable` for the latest successful build of master:

```
% git remote update channels
% git rebase channels/nixos-19.03
```

