{ buildOpenRAMod, fetchFromGitHub, abbrevCommit, extraPostFetch }:

let
  unsafeBuildOpenRAMod = attrs: name: (buildOpenRAMod attrs name).overrideAttrs (_: {
    doCheck = false;
  });

in {
  ca = buildOpenRAMod {
    version = "96";
    title = "Combined Arms";
    description = "A game that combines units from the official OpenRA Red Alert and Tiberian Dawn mods";
    homepage = https://github.com/Inq8/CAmod;
    src = fetchFromGitHub {
      owner = "Inq8";
      repo = "CAmod";
      rev = "fc3cf0baf2b827650eaae9e1d2335a3eed24bac9";
      sha256 = "15w91xs253gyrlzsgid6ixxjazx0fbzick6vlkiay0znb58n883m";
    };
    engine = let commit = "b8a7dd5"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "Inq8";
        repo = "CAengine" ;
        rev = commit;
        sha256 = "0dyk861qagibx8ldshz7d2nrki9q550f6f0wy8pvayvf1gv1dbxj";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  d2 = unsafeBuildOpenRAMod rec {
    version = "134";
    title = "Dune II";
    description = "A modernization of the original ${title} game";
    homepage = https://github.com/OpenRA/d2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "d2";
      rev = "69a4aa708e2c26376469c0048fac13592aa452ca";
      sha256 = "1mfch4s6c05slyqvxllklbxpqq8dqcbx3515n3gyylyq43gq481r";
    };
    engine = rec {
      version = "release-20181215";
      mods = [ "cnc" "d2k" "ra" ];
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "${version}";
        sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the original ${title} game assets in place:
      https://github.com/OpenRA/d2/wiki
    '';
  };

  dr = unsafeBuildOpenRAMod rec {
    version = "272";
    title = "Dark Reign";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/drogoganor/DarkReign;
    src = fetchFromGitHub {
      owner = "drogoganor";
      repo = "DarkReign";
      rev = "f3f75952a444b13072f2e98109f98ba7f4399556";
      sha256 = "0vn6zbbrq8pfhpx6smjpmga5c4vaj3r9y7dr8dsyyhqya0970zp1";
    };
    engine = let commit = "e08b75c2add30439228ea3dd61d6be60d1800329"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "drogoganor";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "125vf962p69ajrh5pxgfwsi0ksczqwvlw5kn2fvffiwvh8d5in23";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  gen = buildOpenRAMod {
    version = "1160";
    title = "Generals Alpha";
    description = "Re-imagination of the original Command & Conquer: Generals game";
    homepage = https://github.com/MustaphaTR/Generals-Alpha;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Generals-Alpha";
      rev = "e44824192eeb4c6527585550ca0b89d2d7045bf5";
      sha256 = "0x2wlnzria1zbaim9npz8sh3yd2r83i95v8c0n0xih0y8qr0g4lh";
    };
    engine = rec {
      version = "gen-20190202";
      src = fetchFromGitHub {
        owner = "MustaphaTR";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "16fvsv0b0mz96rf3hr1srysxs6xnh5bybwk543al5g0zd87wisdr";
        name = "generals-alpha-engine";
        inherit extraPostFetch;
      };
    };
  };

  kknd = buildOpenRAMod rec {
    version = "147";
    title = "Krush, Kill 'n' Destroy";
    description = "Re-imagination of the original ${title} game";
    homepage = https://kknd-game.com/;
    src = fetchFromGitHub {
      owner = "IceReaper";
      repo = "KKnD";
      rev = "5852fbc86d5abeb2ca214a6a325acd9dd3906060";
      sha256 = "17rc7brgwwx8lc4xky6b4n226063ik83kv5p7i3362idpxdc5y9w";
    };
    engine = let commit = "818d6c0b642f50a11b1d0a2fa48aa9cc2c7152c7"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "06il4k8hcwdynh7k7fjdpz9afg313d3im173yfbarylb0lpjm65l";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  mw = unsafeBuildOpenRAMod rec {
    version = "261";
    title = "Medieval Warfare";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/CombinE88/Medieval-Warfare;
    src = fetchFromGitHub {
      owner = "CombinE88";
      repo = "Medieval-Warfare";
      rev = "5eec246ca59e73c6bb3de862411a01fc44f1b11c";
      sha256 = "09vq8a1avfffqazlxn9hf05l9kdwm3wra48id0xwvx4h6n9cm2xr";
    };
    engine = let commit = "dc57a75f11cc7673bf08433775d4a4e9052d16d7"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "CombinE88";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "1qwy18ccih79lrj7vbid3v96lrg1ix8279wpi46jdgdmhgppkms9";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  ra2 = buildOpenRAMod rec {
    version = "883";
    title = "Red Alert 2";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/OpenRA/ra2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "ra2";
      rev = "96d2d14986a70b69c7b0df4433b3ffd2de19e922";
      sha256 = "1ifdnn6rsvhgffq108p3fjral4kvvl3vmqm7ix8hjycncjb0zl09";
    };
    engine = rec {
      version = "release-20180923";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "${version}";
        sha256 = "1pgi3zaq9fwwdq6yh19bwxscslqgabjxkvl9bcn1a5agy4bfbqk5";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the original ${title} game assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };

  raclassic = buildOpenRAMod {
    version = "181";
    title = "Red Alert Classic";
    description = "A modernization of the original Command & Conquer: Red Alert game";
    homepage = https://github.com/OpenRA/raclassic;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "raclassic";
      rev = "8240890b32191ce34241c22158b8a79e8c380879";
      sha256 = "0dznyb6qa4n3ab87g1c4bihfc2nx53k6z0kajc7ynjdnwzvx69ww";
    };
    engine = rec {
      version = "playtest-20190106";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "${version}";
        sha256 = "0ps9x379plrrj1hnj4fpr26lc46mzgxknv5imxi0bmrh5y4781ql";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  rv = unsafeBuildOpenRAMod {
    version = "1364";
    title = "Romanov's Vengeance";
    description = "Re-imagination of the original Command & Conquer: Red Alert 2 game";
    homepage = https://github.com/MustaphaTR/Romanovs-Vengeance;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Romanovs-Vengeance";
      rev = "e788383b78f412a28580bfadff7b491d07691197";
      sha256 = "02vzcq250163fl3151zp0hpi5h9phnxf42d1xs1wk5qdy4sqlgsx";
    };
    engine = let commit = "f3873ae"; in {
      version = abbrevCommit commit;
      mods = [ "as" ];
      src = fetchFromGitHub {
        owner = "GraionDilach";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "02rv29wja0p5d083pd087daz7x7pp5b9ym7sci2fhg3mrnaqgwkp";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the Command & Conquer: The Ultimate Collection assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };

  sp = unsafeBuildOpenRAMod {
    version = "187";
    title = "Shattered Paradise";
    description = "Re-imagination of the original Command & Conquer: Tiberian Sun game";
    homepage = https://github.com/ABrandau/OpenRAModSDK;
    src = fetchFromGitHub {
      owner = "ABrandau";
      repo = "OpenRAModSDK";
      rev = "1599f46031f8164c13a09fdb8f6d0ce601a1c91a";
      sha256 = "17iqqmzz1ky09qr9f0yxxgpgbcr11v95qjbkainzc584iyg56h2j";
    };
    engine = let commit = "d3545c0b751aea2105748eddaab5919313e35314"; in {
      version = abbrevCommit commit;
      mods = [ "as" "ts" ];
      src = fetchFromGitHub {
        owner = "ABrandau";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "1jsldl6vnf3r9dzppdm4z7kqbrzkidda5k74wc809i8c4jjnq9rq";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  ss = buildOpenRAMod rec {
    version = "77";
    title = "Sole Survivor";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/MustaphaTR/sole-survivor;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "sole-survivor";
      rev = "23e1f3e5d8b98c936797b6680d95d56a69a9e2ab";
      sha256 = "104clmxphchs7r8y7hpmw103bychayz80bqj98bp89i64nv9d89x";
    };
    engine = let commit = "6de92de"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "0ps9x379plrrj1hnj4fpr26lc46mzgxknv5imxi0bmrh5y4781ql";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  ura = buildOpenRAMod {
    version = "431";
    title = "Red Alert Unplugged";
    description = "Re-imagination of the original Command & Conquer: Red Alert game";
    homepage = http://redalertunplugged.com/;
    src = fetchFromGitHub {
      owner = "RAunplugged";
      repo = "uRA";
      rev = "128dc53741fae923f4af556f2293ceaa0cf571f0";
      sha256 = "1mhr8kyh313z52gdrqv31d6z7jvdldiajalca5mcr8gzg6mph66p";
    };
    engine = rec {
      version = "unplugged-cd82382";
      src = fetchFromGitHub {
        owner = "RAunplugged";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "1p5hgxxvxlz8480vj0qkmnxjh7zj3hahk312m0zljxfdb40652w1";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  yr = unsafeBuildOpenRAMod rec {
    version = "127";
    homepage = https://github.com/cookgreen/yr;
    title = "Yuri's Revenge";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    src = fetchFromGitHub {
      owner = "cookgreen";
      repo = "yr";
      rev = "f245ffaafaa0963c060722f8d5f08e5fe71457f1";
      sha256 = "0gb5djxis0p3s08px667jd5q5rkh79vn2fwq9bhgdhn1gmn7glck";
    };
    engine = rec {
      version = "release-20180923";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "${version}";
        sha256 = "1pgi3zaq9fwwdq6yh19bwxscslqgabjxkvl9bcn1a5agy4bfbqk5";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the Command & Conquer: The Ultimate Collection assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };
}
