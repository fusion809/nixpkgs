{ buildOpenRAEngine, fetchFromGitHub, abbrevCommit, extraPostFetch }:

let
  buildUpstreamOpenRAEngine = { version, rev, sha256 }: name: (buildOpenRAEngine {
    inherit version;
    description = "Open-source re-implementation of Westwood Studios' 2D Command and Conquer games";
    homepage = https://www.openra.net/;
    mods = [ "cnc" "d2k" "ra" "ts" ];
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "OpenRA" ;
      inherit rev sha256 extraPostFetch;
    };
  } name).overrideAttrs (oldAttrs: {
    postInstall = ''
      ${oldAttrs.postInstall}
      cp -r mods/ts $out/lib/openra/mods/
      cp mods/ts/icon.png $(mkdirp $out/share/pixmaps)/openra-ts.png
      ( cd $out/share/applications; sed -e 's/Dawn/Sun/g' -e 's/cnc/ts/g' openra-cnc.desktop > openra-ts.desktop )
    '';
  });

in {
  release = buildUpstreamOpenRAEngine rec {
    version = "20181215";
    rev = "release-${version}";
    sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";
  };

  playtest = buildUpstreamOpenRAEngine rec {
    version = "20190209";
    rev = "playtest-${version}";
    sha256 = "1mciv08l5pl36gni5b005pswrvyjgwfhs9lvbh7sxnj2s875mkqd";
  };

  bleed = let commit = "a3325277d919a27e65c63f1a580458931e8004f5"; in buildUpstreamOpenRAEngine {
    version = "25814.git.a332527";
    rev = commit;
    sha256 = "04wigkmhd2i2pph3smp5v0h0rbzwq4qf093zv8ws07jka69hn3bl";
  };
}
