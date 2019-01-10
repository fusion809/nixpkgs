# fusion809 Nixpkgs fork
This repository contains the upstream Nixpkgs packages, along with some others created (and I generally modify a little, usually package versions) and with some of my own. 

## Changes

* The version of Vim is kept at the latest version, with updates within a day of the upstream release.

* RuneScape's NXT Client ([`runescape-launcher`](pkgs/games/runescape-launcher)), based on NixOS/nixpkgs#31075. 

* The version of OpenRA is bleeding-edge, with me keeping it at the latest commit and updating within a day of the upstream release. I also added the experimental Tiberian Sun mod to it.

* Adding unofficial mods at bleeding-edge (built from latest commit) versions such as:

    - [openra-ca](pkgs/games/openra-ca): OpenRA [Combined Arms mod](https://github.com/Inq8/CAmod). It combines units from the official Tiberian Dawn and Red Alert mods.

    - [openra-d2](pkgs/games/openra-d2): OpenRA [Dune II mod](https://github.com/OpenRA/d2). Recreates the [*Dune II*](https://en.wikipedia.org/wiki/Dune_II) game by Westwood Studios. 

    - [openra-gen](pkgs/games/openra-gen): OpenRA [Generals Alpha mod](https://github.com/MustaphaTR/Generals-Alpha). Recreates the [*Command & Conquer: Generals*](https://en.wikipedia.org/wiki/Command_&_Conquer:_Generals) game.

    - [openra-kknd](pkgs/games/openra-kknd): OpenRA [Krush Kill n' Destroy mod](https://github.com/IceReaper/KKnD). Recreates the original [*Krush Kill n' Destroy*](http://kknd.wikia.com/wiki/Krush_Kill_%27n%27_Destroy) game by Beam Software. This mod even has its own official website: https://kknd-game.com. 

    - [openra-ra2](pkgs/games/openra-ra2): OpenRA [Red Alert 2 mod](https://github.com/OpenRA/ra2). It recreates the original [*Command & Conquer: Red Alert 2*](https://en.wikipedia.org/wiki/Command_&_Conquer:_Red_Alert_2).

    - [openra-raclassic](pkgs/games/openra-raclassic): OpenRA [Red Alert Classic mod](https://github.com/OpenRA/raclassic). It recreates the original [*Command & Conquer: Red Alert*](https://github.com/OpenRA/raclassic) more accurately than the official RA mod.

    - [openra-rv](pkgs/games/openra-rv): OpenRA [Romanov's Vengeance mod](https://github.com/MustaphaTR/Romanovs-Vengeance). It recreates and expands on the [*Command & Conquer: Red Alert 2*](https://en.wikipedia.org/wiki/Command_&_Conquer:_Red_Alert_2) game, much like openra-ra2. 

    - [openra-sp](pkgs/games/openra-sp): OpenRA [Shattered Paradise mod](https://github.com/ABrandau/OpenRAModSDK). It expands on the experimental Tiberian Sun mod that comes bundled with the OpenRA game engine.

    - [openra-ss](pkgs/games/openra-ss): OpenRA [Sole Survivor mod](https://github.com/MustaphaTR/sole-survivor). It recreates the [*Command_&_Conquer: Sole_Survivor*](https://en.wikipedia.org/wiki/Command_&_Conquer:_Sole_Survivor) game.

    - [openra-ura](pkgs/games/openra-ura): OpenRA [Red Alert Unplugged mod](https://github.com/RAUnplugged/uRA). It expands on the Red Alert mod that comes bundled with the OpenRA game engine. Personally, this is my favourite mod. I got the code for this, which I used to create these other mod packages (with a bit of tweaking, but relatively easy after I had the openra-ura package), from https://github.com/NixOS/nixpkgs/pull/51530.

    - [openra-yr](pkgs/games/openra-yr): OpenRA [Yuri's Revenge mod](https://github.com/cookgreen/yr). It attempts to recreate the original [*Command & Conquer: Yuri's Revenge*](https://en.wikipedia.org/wiki/Command_%26_Conquer:_Yuri%27s_Revenge) game. Be fair warned this game is very experimental, I frequently find bugs in it when I use it.

I have also attempted to package the [Dark Reign](https://github.com/drogoganor/DarkReign) and [Medieval Warfare](https://github.com/CombinE88/Medieval-Warfare) mods, but sadly that failed with the errors documented in their directories', [openra-dr](pkgs/games/openra-dr) and [openra-mw](pkgs/games/openra-mw), `broken` files.

It is worthwhile noting that these mods do not work on non-NixOS systems, due to [OpenGL issues](https://gist.github.com/fusion809/34b68465463e9cdc58deed127420365d).

There is a pull request upstream that will soon make all packages I have added to this repo redundant, it is [#53300](https://github.com/NixOS/nixpkgs/pull/53300).

## Installing packages

Building and installing packages in this repository should be as simple as running:

```bash
nix-env -f /path/to/nixpkgs -iA package
```

where `/path/to/nixpkgs` is, of course, the path to where this fork of nixpkgs is located on your local system. 
