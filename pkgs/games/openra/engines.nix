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
    version = "20190314";
    rev = "release-${version}";
    sha256 = "15pvn5cx3g0nzbrgpsfz8dngad5wkzp5dz25ydzn8bmxafiijvcr";
  };

  playtest = buildUpstreamOpenRAEngine rec {
    version = "20190302";
    rev = "playtest-${version}";
    sha256 = "1vqvfk2p2lpk3m0d3rpvj34i8cmk3mfc7w4cn4llqd9zp4kk9pya";
  };

  bleed = let commit = "aed6098eaa63bede2aa742f753cef1bc70999c8e"; in buildUpstreamOpenRAEngine {
    version = "26071.git.aed6098";
    rev = commit;
    sha256 = "1s6z60s1pd5ag09bd9gc85z5ir36xk5mv5zj92fj6vssq7nvgnx4";
  };
}
