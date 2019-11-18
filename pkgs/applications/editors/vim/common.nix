{ lib, fetchFromGitHub }:
rec {
  version = "8.1.2318";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "13gkfk9bdv1rafq89qfldp28hxypj3grxh7mgxxqfqa3ps41lj75";
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
