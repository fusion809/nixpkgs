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

  dr = buildOpenRAMod rec {
    version = "310";
    title = "Dark Reign";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/drogoganor/DarkReign;
    src = fetchFromGitHub {
      owner = "drogoganor";
      repo = "DarkReign";
      rev = "b7adc728b38170bdc1ea4ec7703d23be0695adc8";
      sha256 = "0p97mrd9k3ffqjyykq9hy115v6033gcs8qqi6fxd2p1msj09sg88";
    };
    engine = let commit = "fc49e7dc20b64b9abdf3bc2b9d3b4f32af44c7d0"; in {
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
    version = "884";
    title = "Red Alert 2";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/OpenRA/ra2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "ra2";
      rev = "a6f6ae8897a069567e9c1114d58f940f85314d61";
      sha256 = "10b5ac20i1sxp9sj93yzdnhmj8xqyqwqx7gg9mbngy8x1r7744vr";
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
    version = "1368";
    title = "Romanov's Vengeance";
    description = "Re-imagination of the original Command & Conquer: Red Alert 2 game";
    homepage = https://github.com/MustaphaTR/Romanovs-Vengeance;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Romanovs-Vengeance";
      rev = "e81d6475e323dadd1188bbe1fa2835e426219ee7";
      sha256 = "0zx5c5515j9gryp5a3kzn9d643zrzzm1kac57zydi4fhxdr3jkz4";
    };
    engine = let commit = "d4519a0"; in {
      version = abbrevCommit commit;
      mods = [ "as" ];
      src = fetchFromGitHub {
        owner = "GraionDilach";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "0i6wrxlzghh042x5nvsmd6ylfq17sfy33qcfray8dvvsxz4p8ynv";
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
    version = "199";
    title = "Shattered Paradise";
    description = "Re-imagination of the original Command & Conquer: Tiberian Sun game";
    homepage = https://github.com/ABrandau/OpenRAModSDK;
    src = fetchFromGitHub {
      owner = "ABrandau";
      repo = "OpenRAModSDK";
      rev = "1dcc510848a37770f51b1e7b6f20f4de6da2eba6";
      sha256 = "028vaq3xb38q9vhbhkr606v0abkj7xa2wgc7vwrkrf1r906nd3nk";
    };
    engine = let commit = "SP-11-02-19"; in {
      version = abbrevCommit commit;
      mods = [ "as" "ts" ];
      src = fetchFromGitHub {
        owner = "ABrandau";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "0pr4qv9yyh2fi022q6kh9dg1n8wr3x9fi07q71afsi73hqbw9125";
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
      sha256 = "0h7is7x2qyvq7vqp0jgw5zrdkw8g7ndd82d843ldhnb0a3vyrk34";
    };
    engine = let commit = "becfc154c5cd3891d695339ff86883db8b5790a5"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "0id8vf3cjr7h5pz4sw8pdaz3sc45lxr21k1fk4309kixsrpa7i0y";
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
    version = "143";
    homepage = https://github.com/cookgreen/yr;
    title = "Yuri's Revenge";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    src = fetchFromGitHub {
      owner = "cookgreen";
      repo = "yr";
      rev = "a03b7c0cfe246c8353ec6d804b19a95a9129e580";
      sha256 = "1wkwkmrnl5pr55smcb47wgppksx9sigw6y3fic4l4v9qdzf40y2m";
    };
    engine = rec {
      version = "release-20181215";
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
      The mod expects the Command & Conquer: The Ultimate Collection assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };
}
