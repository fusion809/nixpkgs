{ lib, fetchFromGitHub }:
rec {
  version = "8.1.2146";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "035aq4b9r333p58df236q09wfqarnad6xf4ks526yc1r8xwbqc5a";
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
