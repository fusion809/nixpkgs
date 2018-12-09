# fusion809 Nixpkgs fork
This repository contains the upstream Nixpkgs packages, along with some of my own. 

## Changes

* The version of Vim is kept at the latest version, with updates within a day of the upstream release.

* The version of OpenRA is bleeding-edge, with me keeping it at the latest commit and updating within a day of the upstream release. I also added the experimental Tiberian Sun mod to it and implement upstream [PR #51404](https://github.com/NixOS/nixpkgs/pull/51404).

* Adding unofficial mods at bleeding-edge (built from latest commit) versions such as:

    - [openra-ca](pkgs/games/openra-ca): OpenRA [Combined Arms mod](https://github.com/Inq8/CAmod). It combines units from the official Tiberian Dawn and Red Alert mods.

    - [openra-d2](pkgs/games/openra-d2): OpenRA [Dune II mod](https://github.com/OpenRA/d2). Recreates the [*Dune II*](https://en.wikipedia.org/wiki/Dune_II) game by Westwood Studios. 

	- [openra-gen](pkgs/games/openra-gen): OpenRA [Generals Alpha mod](https://github.com/MustaphaTR/Generals-Alpha). Recreates the [*Command & Conquer: Generals*](https://en.wikipedia.org/wiki/Command_&_Conquer:_Generals) game.

    - [openra-ra2](pkgs/games/openra-ra2): OpenRA [Red Alert 2 mod](https://github.com/OpenRA/ra2). It recreates the original [*Command & Conquer: Red Alert 2*](https://github.com/OpenRA/ra2).

    - [openra-raclassic](pkgs/games/openra-raclassic): OpenRA [Red Alert Classic mod](https://github.com/OpenRA/ra2). It recreates the original [*Command & Conquer: Red Alert*](https://github.com/OpenRA/raclassic) more accurately than the official RA mod.

    - [openra-sp](pkgs/games/openra-sp): OpenRA [Shattered Paradise mod](https://github.com/ABrandau/OpenRAModSDK). It expands on the experimental Tiberian Sun mod that comes bundled with the OpenRA game engine.

    - [openra-ura](pkgs/games/openra-ura): OpenRA [Red Alert Unplugged mod](https://github.com/RAUnplugged/uRA). It expands on the Red Alert mod that comes bundled with the OpenRA game engine. Personally, this is my favourite mod.

    - [openra-yr](pkgs/games/openra-yr): OpenRA [Yuri's Revenge mod](https://github.com/cookgreen/yr). It attempts to recreate the original [*Command & Conquer: Yuri's Revenge*](https://en.wikipedia.org/wiki/Command_%26_Conquer:_Yuri%27s_Revenge) game. Be fair warned this game is very experimental.

I have also attempted to package the [Dark Reign](https://github.com/drogoganor/DarkReign) and [Medieval Warfare](https://github.com/CombinE88/Medieval-Warfare) mods, but sadly that failed with the errors documented in their directories', [openra-dr](pkgs/games/openra-dr) and [openra-mw](pkgs/games/openra-mw), `broken` files.

## Installing packages

Building and installing packages in this repository should be as simple as running:

```bash
nix-env -f /path/to/nixpkgs -iA package
```

where `/path/to/nixpkgs` is, of course, the path to where this fork of nixpkgs is located on your local system. 