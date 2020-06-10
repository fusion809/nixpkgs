{ lib, fetchFromGitHub }:
rec {
  version = "8.2.0948";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "0n2dkb437ir1rnwdkvn0628yxykzpdbyw8w44vl6v8pmpr02kpvy";
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
