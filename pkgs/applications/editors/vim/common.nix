{ lib, fetchFromGitHub }:
rec {
  version = "8.1.2424";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "1d9mf4p55kjbh93z71pfhi8yypjkwf6fv76qnsi5rs7ahwnin05r";
  };

  enableParallelBuilding = true;

  hardeningDisable = [ "fortify" ];

  postPatch =
    # Use man from $PATH; escape sequences are still problematic.
    ''
      substituteInPlace runtime/ftplugin/man.vim \
        --replace "/usr/bin/man " "man "
    '';

  meta = with lib; {
    description = "The most popular clone of the VI editor";
    homepage    = http://www.vim.org;
    license     = licenses.vim;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
