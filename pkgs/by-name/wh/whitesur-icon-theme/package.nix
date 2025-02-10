{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
  jdupes,
  boldPanelIcons ? false,
  blackPanelIcons ? false,
  alternativeIcons ? false,
  themeVariants ? [ ],
}:

let
  pname = "Whitesur-icon-theme";
in
lib.checkListOfEnum "${pname}: theme variants"
  [
    "default"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "grey"
    "nord"
    "all"
  ]
  themeVariants

  stdenvNoCC.mkDerivation
  rec {
    inherit pname;
    version = "2025-02-10";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = version;
      hash = "sha256-09ieq49ZoxgdR/821Xg+gBCDntwtVA9Hwtgwy3Wc4M0=";
    };

    nativeBuildInputs = [
      gtk3
      jdupes
    ];

    buildInputs = [ hicolor-icon-theme ];

    # These fixup steps are slow and unnecessary
    dontPatchELF = true;
    dontRewriteSymlinks = true;
    dontDropIconThemeCache = true;

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      ./install.sh --dest $out/share/icons \
        --name WhiteSur \
        --theme ${builtins.toString themeVariants} \
        ${lib.optionalString alternativeIcons "--alternative"} \
        ${lib.optionalString boldPanelIcons "--bold"} \
        ${lib.optionalString blackPanelIcons "--black"}

      jdupes --link-soft --recurse $out/share
      rm $out/share/icons/WhiteSur/devices/scalable/device-notifier.svg
      rm $out/share/icons/WhiteSur/actions/32/open-menu-symbolic.svg
      rm $out/share/icons/WhiteSur/mimes/16/stock_new-template.svg
      rm $out/share/icons/WhiteSur/mimes/16/text-x-preview.svg
      rm $out/share/icons/WhiteSur/mimes/16/application-vnd_cups-pdf-banner.svg
      rm $out/share/icons/WhiteSur/mimes/16/gnome-fs-regular.svg
      rm $out/share/icons/WhiteSur/apps/scalable/lutris_dota-2.svg
      runHook postInstall
    '';

    meta = with lib; {
      description = "MacOS Big Sur style icon theme for Linux desktops";
      homepage = "https://github.com/vinceliuice/WhiteSur-icon-theme";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [ icy-thought ];
    };

  }
