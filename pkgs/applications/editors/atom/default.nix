{ stdenv, pkgs, fetchurl, wrapGAppsHook, gvfs, gtk3, atomEnv }:

let
  versions = {
    atom = {
      version = "1.40.1";
      sha256 = "0hzm491g22gqk2shi6zalbz2ja7x6bs4x60jr3kn278h3k7j2j8d";
    };

    atom-beta = {
      version = "1.41.0";
      beta = 1;
      sha256 = "1ppdf5lzpdfs9y0bhr2p2ic5q4zz8726sdamz4m04ncy459j7ggs";
    };
  };

  common = pname: {version, sha256, beta ? null}:
      let fullVersion = version + stdenv.lib.optionalString (beta != null) "-beta${toString beta}";
      name = "${pname}-${fullVersion}";
  in stdenv.mkDerivation {
    inherit name;
    version = fullVersion;

    src = fetchurl {
      url = "https://github.com/atom/atom/releases/download/v${fullVersion}/atom-amd64.deb";
      name = "${name}.deb";
      inherit sha256;
    };

    nativeBuildInputs = [
      wrapGAppsHook  # Fix error: GLib-GIO-ERROR **: No GSettings schemas are installed on the system
    ];

    buildInputs = [
      gtk3  # Fix error: GLib-GIO-ERROR **: Settings schema 'org.gtk.Settings.FileChooser' is not installed
    ];

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix "PATH" : "${gvfs}/bin" \
      )
    '';

    buildCommand = ''
      mkdir -p $out/usr/
      ar p $src data.tar.xz | tar -C $out -xJ ./usr
      sed -i -e "s|Exec=.*$|Exec=$out/bin/${pname}|" $out/usr/share/applications/${pname}.desktop
      mv $out/usr/* $out/
      rm -r $out/share/lintian
      rm -r $out/usr/
      sed -i "s/${pname})/.${pname}-wrapped)/" $out/bin/${pname}

      fixupPhase

      share=$out/share/${pname}

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:$share" \
        $share/atom
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}" \
        $share/resources/app/apm/bin/node
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $share/resources/app.asar.unpacked/node_modules/symbols-view/vendor/ctags-linux

      dugite=$share/resources/app.asar.unpacked/node_modules/dugite
      rm -f $dugite/git/bin/git
      ln -s ${pkgs.git}/bin/git $dugite/git/bin/git
      rm -f $dugite/git/libexec/git-core/git
      ln -s ${pkgs.git}/bin/git $dugite/git/libexec/git-core/git

      find $share -name "*.node" -exec patchelf --set-rpath "${atomEnv.libPath}:$share" {} \;
    '';

    meta = with stdenv.lib; {
      description = "A hackable text editor for the 21st Century";
      homepage = https://atom.io/;
      license = licenses.mit;
      maintainers = with maintainers; [ offline nequissimus ysndr ];
      platforms = platforms.x86_64;
    };
  };
in stdenv.lib.mapAttrs common versions
