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
    version = "166";
    title = "Dune II";
    description = "A modernization of the original ${title} game";
    homepage = https://github.com/OpenRA/d2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "d2";
      rev = "0a74333011044263084f9e714035200fbb676fd7";
      sha256 = "1i9m9ikdvs0bcxm011kpsdim9m05may304hyakgwsh42banrqm2n";
    };
    engine = rec {
      version = "babab49";
      mods = [ "cnc" "d2k" "ra" ];
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "${version}";
        sha256 = "0ydbpxfd45d3cxjk4sh3z3lxaajpdddzkxrnvx8294w2wr5l1iqm";
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
    version = "324";
    title = "Dark Reign";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/drogoganor/DarkReign;
    src = fetchFromGitHub {
      owner = "drogoganor";
      repo = "DarkReign";
      rev = "ffcd6ba72979e5f77508136ed7b0efc13e4b100e";
      sha256 = "07g4qw909649s3i1yhw75613mpwfka05jana5mpp5smhnf0pkack";
    };
    engine = let commit = "f91d3f2603bbf51afaa89357e4defcdc36138102"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "drogoganor";
        repo = "OpenRA" ;
        rev = commit;
        name = "engine";
        sha256 = "05g900ri6q0zrkrk8rmjaz576vjggmi2y6jm0xz3cwli54prn11w";
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
    version = "148";
    title = "Krush, Kill 'n' Destroy";
    description = "Re-imagination of the original ${title} game";
    homepage = https://kknd-game.com/;
    src = fetchFromGitHub {
      owner = "IceReaper";
      repo = "KKnD";
      rev = "5fc5d83ac2ccdb640a1d773e7eaa998f2fff5069";
      sha256 = "0fcvf07hjw8n2f9hzqyx76aywbjy87kysq468rwz30p7357ldjrk";
    };
    engine = let commit = "06e1a35d48c9af32ae43da7693519bd32ddf758a"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "0i1bhwlyrd22znkifi60zvqz09g5z1xpqnk7rm45iq5lj1fyhsg3";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  mw = buildOpenRAMod rec {
    version = "272";
    title = "Medieval Warfare";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/CombinE88/Medieval-Warfare;
    src = fetchFromGitHub {
      owner = "CombinE88";
      repo = "Medieval-Warfare";
      rev = "fe6af861169665bdadb851bbfce0a44434036157";
      sha256 = "0nkql0l9c6y105rgli8k6v0dxy5l6a6ch35pc2048jjczjm9fda3";
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
    version = "906";
    title = "Red Alert 2";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/OpenRA/ra2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "ra2";
      rev = "b9668d9c9b1c64767feaff7fd916ba902e2e1e13";
      sha256 = "1hf928z7i01ny6fqy5lmqgh27l7y0spazz1dp2sbaswsg29w8big";
    };
    engine = rec {
      version = "release-20190314";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "${version}";
        sha256 = "15pvn5cx3g0nzbrgpsfz8dngad5wkzp5dz25ydzn8bmxafiijvcr";
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
    version = "183";
    title = "Red Alert Classic";
    description = "A modernization of the original Command & Conquer: Red Alert game";
    homepage = https://github.com/OpenRA/raclassic;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "raclassic";
      rev = "c76c13e9f0912a66ddebae8d05573632b19736b2";
      sha256 = "1cnr3ccvrkjlv8kkdcglcfh133yy0fkva9agwgvc7wlj9n5ydl4g";
    };
    engine = rec {
      version = "release-20190314";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "${version}";
        sha256 = "15pvn5cx3g0nzbrgpsfz8dngad5wkzp5dz25ydzn8bmxafiijvcr";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  rv = unsafeBuildOpenRAMod {
    version = "1950";
    title = "Romanov's Vengeance";
    description = "Re-imagination of the original Command & Conquer: Red Alert 2 game";
    homepage = https://github.com/MustaphaTR/Romanovs-Vengeance;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Romanovs-Vengeance";
      rev = "d5756a5ec8d50ad131ffe9f78c2d7085540d0826";
      sha256 = "1mj79nsarfylm0firhw1khdrlmc1rflm37snds15ym46w25jyvmj";
    };
    engine = let commit = "d16e9ff"; in {
      version = abbrevCommit commit;
      mods = [ "as" ];
      src = fetchFromGitHub {
        owner = "GraionDilach";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "0ma6jfpvlvz9avyps04y66q3pwsa0qkj8b4j8rhmxznh0sr2lhzf";
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
    version = "245";
    title = "Shattered Paradise";
    description = "Re-imagination of the original Command & Conquer: Tiberian Sun game";
    homepage = https://github.com/ABrandau/OpenRAModSDK;
    src = fetchFromGitHub {
      owner = "ABrandau";
      repo = "OpenRAModSDK";
      rev = "6c69132032d71c013f7944cc1943fb3d620a1adc";
      sha256 = "1jvgpbf56hd02ikhklv49br4d1jiv5hphc5kl79qnjlaacnj222x";
    };
    engine = let commit = "SP-22-04-19"; in {
      version = abbrevCommit commit;
      mods = [ "as" "ts" ];
      src = fetchFromGitHub {
        owner = "ABrandau";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "1jvgpbf56hd02ikhklv49br4d1jiv5hphc5kl79qnjlaacnj222x";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  ss = buildOpenRAMod rec {
    version = "241";
    title = "Sole Survivor";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/MustaphaTR/sole-survivor;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "sole-survivor";
      rev = "24d44af6e1900e6b2c99f489fdf106b8e0a99cf0";
      sha256 = "1hsk9wpa1vfqssazrsj4px684z66xwhwl8fw6rf92221fbr4mnjk";
    };
    engine = let commit = "81674e2"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "04fc3vss6czqvb6wr6lmd80fii653glyg9bk12cfm6xiwbjl7lvs";
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
    version = "230";
    homepage = https://github.com/cookgreen/yr;
    title = "Yuri's Revenge";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    src = fetchFromGitHub {
      owner = "cookgreen";
      repo = "yr";
      rev = "ca52fd01e1dfc0336d9a0b9983bb1f769261f978";
      sha256 = "0vsi51lnfs79hgsbdkd8cbgp8a0mhyyk16f0p8hzzxsgmlbivjq7";
    };
    engine = rec {
      version = "release-20190314";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "${version}";
        sha256 = "15pvn5cx3g0nzbrgpsfz8dngad5wkzp5dz25ydzn8bmxafiijvcr";
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
