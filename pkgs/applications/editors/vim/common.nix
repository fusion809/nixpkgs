{ lib, fetchFromGitHub }:
rec {
  version = "8.2.1779";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "057rj78xqfi0xm22ksbr5ridicn9vmaky54ql0pbq7x8dpm99rkd";
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
