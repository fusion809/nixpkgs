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
      sha256 = "1qwy18ccih79lrj7vbid3v96lrg1ix8279wpi46jdgdmhgppkms9";
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
    version = "268";
    title = "Dark Reign";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/drogoganor/DarkReign;
    src = fetchFromGitHub {
      owner = "drogoganor";
      repo = "DarkReign";
      rev = "0b37da1fbae0b1fc3b86d57f841c4fbadf7d335b";
      sha256 = "16dwi1vkj31v2a99xq7qqcy4xgp2p4fi9bwwfk70qcdl4vncamm6";
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
    version = "1159";
    title = "Generals Alpha";
    description = "Re-imagination of the original Command & Conquer: Generals game";
    homepage = https://github.com/MustaphaTR/Generals-Alpha;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Generals-Alpha";
      rev = "bd5910b27533520b44f513eb9ca8544be5d11e6e";
      sha256 = "1l72zpkxacid3hji5dpfqx4swkcf61v1l0p9q6f6rq52l3lln30x";
    };
    engine = rec {
      version = "gen-20190129";
      src = fetchFromGitHub {
        owner = "MustaphaTR";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "16mkfxc1k8d68a5ijmrn4cch8vq77kl30h1j5g30f2dswilvz6nw";
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
    version = "260";
    title = "Medieval Warfare";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/CombinE88/Medieval-Warfare;
    src = fetchFromGitHub {
      owner = "CombinE88";
      repo = "Medieval-Warfare";
      rev = "1bbb1da823ea7a1320f1fd4607ac9d4e670b33a4";
      sha256 = "09fp7k95jd6hjqdasbspbd43z5670wkyzbbgqkll9dfsrv0sky0v";
    };
    engine = let commit = "dc57a75f11cc7673bf08433775d4a4e9052d16d7"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "CombinE88";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "0ga3855j6bc7h81q03cw6laiaiz12915zg8aqah1idvxbzicfy7l";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  ra2 = buildOpenRAMod rec {
    version = "881";
    title = "Red Alert 2";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/OpenRA/ra2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "ra2";
      rev = "b37f4f9f07404127062d9061966e9cc89dd86445";
      sha256 = "1jiww66ma3qdk9hzyvhbcaa5h4p2mxxk22kvrw92ckpxy0bqba3h";
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
    version = "1338";
    title = "Romanov's Vengeance";
    description = "Re-imagination of the original Command & Conquer: Red Alert 2 game";
    homepage = https://github.com/MustaphaTR/Romanovs-Vengeance;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Romanovs-Vengeance";
      rev = "669374d2671f1246ef3ac95f2f25e8761c860d04";
      sha256 = "0qn48pphs2v9khl9w5yjz9jfraxzxp340m73564rbx19r86giim4";
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
    version = "181";
    title = "Shattered Paradise";
    description = "Re-imagination of the original Command & Conquer: Tiberian Sun game";
    homepage = https://github.com/ABrandau/OpenRAModSDK;
    src = fetchFromGitHub {
      owner = "ABrandau";
      repo = "OpenRAModSDK";
      rev = "d559692e929099fafab154d734b61efb117d0237";
      sha256 = "0hmh5syp5j3kxjx2xr9g2y472mxwpi4n2jpjw0y826rsvydf31aa";
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
    version = "122";
    homepage = https://github.com/cookgreen/yr;
    title = "Yuri's Revenge";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    src = fetchFromGitHub {
      owner = "cookgreen";
      repo = "yr";
      rev = "70d4b0ec9113380ca17ae05ab130824390cb80de";
      sha256 = "1swif91fx4rzhg91r9yrxifvm0a3d42xksihnf67hq3nawi4g03x";
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
