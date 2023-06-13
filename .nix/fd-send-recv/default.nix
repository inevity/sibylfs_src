{ }:
let 
    pkgs = import <nixpkgs> {};
    stdenv = pkgs.stdenv;
    fetchurl = pkgs.fetchurl;
    fetchgithub = pkgs.fetchFromGitHub;
    op = pkgs.ocaml-ng.ocamlPackages_4_02;
    ocaml = op.ocaml;
    #ocaml = pkgs.ocaml;
    #findlib = pkgs.ocamlPackages.findlib; # needed?
    findlib = op.findlib;
in stdenv.mkDerivation {
    name = "ocaml_fd-send-recv";
  
    #src = fetchurl {
    #  #url = https://github.com/xen-org/ocaml-fd-send-recv/archive/ocaml-fd-send-recv-1.0.1.tar.gz;
    #  url = https://github.com/djs55/ocaml-fd-send-recv/archive/refs/tags/v1.0.4.tar.gz;
    #  sha256 = "gKF1JcF3Lvd9tW84BzylUlVkG4TZQzFwRmtu1w48ufQ=";
    #  #sha256 = "664f109b63412493d3689057010938fe8d0fe122e57e4eecc6a2adf0e94f3c92";
    #};
    src = fetchgithub {
      owner = "djs55";
      repo = "ocaml-fd-send-recv";
      rev = "f05e338";

      #url = https://github.com/xen-org/ocaml-fd-send-recv/archive/ocaml-fd-send-recv-1.0.1.tar.gz;
      #url = https://github.com/djs55/ocaml-fd-send-recv/archive/refs/tags/v1.0.4.tar.gz;
      #sha256 = "gKF1JcF3Lvd9tW84BzylUlVkG4TZQzFwRmtu1w48ufQ=";
      sha256 = "cMqvJLezsj7XTL0QYmM3ffMaIMhawJiZpFaAaAc6Ops=";
      #sha256 = "664f109b63412493d3689057010938fe8d0fe122e57e4eecc6a2adf0e94f3c92";
    };
  
    buildInputs = [ ocaml findlib ]; 
  
    createFindlibDestdir = true;

}
