{ lib, fetchFromGitHub }:
rec {
  version = "8.2.0834";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "1m8fybb8qskpgh4by2h0mx99q87kkpjpdzfaavhgwnbns92vs6px";
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
