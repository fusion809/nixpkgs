# This file was generated by go2nix.
{ buildGoPackage, fetchFromGitHub, fetchpatch, lib }:

buildGoPackage rec {
  pname = "prometheus-json-exporter";
  version = "unstable-2017-10-06";

  goPackagePath = "github.com/kawamuray/prometheus-json-exporter";

  src = fetchFromGitHub {
    owner = "kawamuray";
    repo = "prometheus-json-exporter";
    rev = "51e3dc02a30ab818bb73e5c98c3853231c2dbb5f";
    sha256 = "1v1p4zcqnb3d3rm55r695ydn61h6gz95f55cpa22hzw18dasahdh";
  };

  goDeps = ./json-exporter_deps.nix;

  patches = [(fetchpatch { # adds bool support
    url = "https://patch-diff.githubusercontent.com/raw/kawamuray/prometheus-json-exporter/pull/17.patch";
    sha256 = "0mc5axhd2bykci41dgswl4r1552d70jsmb17lbih7czhsy6rgmrm";
  })];

  meta = with lib; {
    description = "A prometheus exporter which scrapes remote JSON by JSONPath";
    homepage = https://github.com/kawamuray/prometheus-json-exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
  };
}
