{ stdenv, appimageTools, fetchurl }:

let
  version = "3.5.0";
  sha256 = "b134e70f5b0dd007e241721747c3d743e930b2111d581ffc2f8a634960936839";
in

(appimageTools.wrapType2 rec {
  name = "ocs-store";
  src = fetchurl {
    url = "https://dl.opendesktop.org/api/files/download/id/1546244095/s/eb5b1ac78b033698eef6e61906eb5bdc2ed4c54d0abda04e4fe9e9ffec8febff03396d7f6c06c9c2506f1e2c334750376f7c3ffe8ea3059931ac13efea2a0a4a/t/1549057874/u//ocs-store-3.5.0-1-x86_64.AppImage";
    inherit sha256;
  };
}).overrideAttrs(old: 
  name = "ocs-store-${version}";
  meta = with stdenv.lib; {
    description = "An application that allows for easy installation of GUI themes";
    longDescription = ''
      OCS-Store is a Content Management App for OCS-compatible websites 
      like opendesktop.org, gnome-look.org, etc. It allows to download, 
      install and apply desktop themes, icon themes, wallpapers, or mouse
      cursors under various desktop environments using the "Install"-button.
    '';
    homepage = https://www.opendesktop.org/p/1175480/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ fusion809 ];
    platforms = [ "x86_64-linux" ];
  };
})
