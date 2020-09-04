{ lib, fetchFromGitHub }:
rec {
  version = "8.2.1591";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "1p504f85i13c85mcvhgqipnagfps2ia0b7llvs877329jb7r2503";
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
    homepage    = "http://www.vim.org";
    license     = licenses.vim;
    maintainers = with maintainers; [ lovek323 equirosa ];
    platforms   = platforms.unix;
  };
}
