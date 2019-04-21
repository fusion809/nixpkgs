{ lib, fetchFromGitHub }:
rec {
  version = "8.1.1195";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "1dvf1qpvkyw2spqm16pgpzqvpd569j725x5rpv41kimvbjgqpnl8";
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
