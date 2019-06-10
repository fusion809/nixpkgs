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
    engine = let commit = "b8a7dd52ff893ed8225726d4ed4e14ecad748404"; in {
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
    version = "157";
    title = "Dune II";
    description = "A modernization of the original ${title} game";
    homepage = https://github.com/OpenRA/d2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "d2";
      rev = "9068affed45d7395b3f6691b81410ff09381a330";
      sha256 = "0y8pn1205jpjgjq8gqqwjaz6akv96v2mriqyz09za3pai8x1xgyw";
    };
    engine = rec {
      version = "release-20190314";
      mods = [ "cnc" "d2k" "ra" ];
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
    version = "267";
    title = "Medieval Warfare";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/CombinE88/Medieval-Warfare;
    src = fetchFromGitHub {
      owner = "CombinE88";
      repo = "Medieval-Warfare";
      rev = "fc6235370a66a48d367ceab00c15debef0b65ffd";
      sha256 = "0cmq42kvvzx2ha5jmgq0j86n9mqjmz0kj4bndllm9wp0xqnzaxz1";
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
    version = "903";
    title = "Red Alert 2";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/OpenRA/ra2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "ra2";
      rev = "2f7c700d6d63c0625e7158ef3098221fa6741569";
      sha256 = "11vnzwczn47wjfrq6y7z9q234p27ihdrcl5p87i6h2xnrpwi8b6m";
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
    version = "1759";
    title = "Romanov's Vengeance";
    description = "Re-imagination of the original Command & Conquer: Red Alert 2 game";
    homepage = https://github.com/MustaphaTR/Romanovs-Vengeance;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Romanovs-Vengeance";
      rev = "7e24ef1eb3ff0c019ab1a2adce4ba7e88b4e5fce";
      sha256 = "04si1i7vwgmk6s74mlplxsswxs255yvkcgjc6sf71dcgbj07bmv5";
    };
    engine = let commit = "48e5a17"; in {
      version = abbrevCommit commit;
      mods = [ "as" ];
      src = fetchFromGitHub {
        owner = "GraionDilach";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "154410ahj5063ix6zvx7s1kzi000ziaby067g3bcw80vkm4dgp3f";
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
    version = "227";
    title = "Shattered Paradise";
    description = "Re-imagination of the original Command & Conquer: Tiberian Sun game";
    homepage = https://github.com/ABrandau/OpenRAModSDK;
    src = fetchFromGitHub {
      owner = "ABrandau";
      repo = "OpenRAModSDK";
      rev = "7ba35701f7396fd9b6b71fd7093689fb9399a1db";
      sha256 = "06ag85sihdjx16fr3dx92jqin92y0sq43h1d04rwi04ylf8x7yk9";
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
    version = "137";
    title = "Sole Survivor";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/MustaphaTR/sole-survivor;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "sole-survivor";
      rev = "6e55b19a61aaa583667240afe53a245bb8148a2b";
      sha256 = "0xwfy5nsy0rc60p9va44s0f7x18xchwx7iahlwnp9m62i406cshm";
    };
    engine = let commit = "db487e1"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "1dsnbfiall5mismjk68pzh3hy2wxbg4v2zdqpw463raws7v19qnp";
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
    version = "205";
    homepage = https://github.com/cookgreen/yr;
    title = "Yuri's Revenge";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    src = fetchFromGitHub {
      owner = "cookgreen";
      repo = "yr";
      rev = "c945a1e4de55e3f45d6fae52fc0f6a72020d644d";
      sha256 = "1q43wnpi99aczkzv8hngihl2ri5yn1al4s3x90jh024mclb2b85g";
    };
    engine = rec {
      version = "db487e1";
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
