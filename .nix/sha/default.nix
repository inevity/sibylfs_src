{ }:
let 
    pkgs = import <nixpkgs> {};
    stdenv = pkgs.stdenv;
    fetchurl = pkgs.fetchurl;
    fetchgithub = pkgs.fetchFromGitHub;
    op = pkgs.ocaml-ng.ocamlPackages_4_02;
    ocaml = op.ocaml;
    findlib = pkgs.ocamlPackages.findlib; # needed?
in stdenv.mkDerivation {
    name = "ocaml_sha";
  
    #src = fetchurl {
    #  name = "ocaml_sha_v1.9";
    #  url = https://github.com/vincenthz/ocaml-sha/archive/ocaml-sha-v1.9.tar.gz;
    #  sha256 = "caa1dd9071c2c56ca180061bb8e1824ac3b5e83de8ec4ed197275006c2a088d0";
    #};
    src = fetchgithub {
      owner = "vincenthz";
      repo = "ocaml-sha";
      rev = "73f9b84";
      sha256 = "67cJaeunkEWt3103MKnWHlfsIp8Z+zvDcZIOEzt1cSs=";
    };
  
    #buildInputs = [ ocaml findlib pkgs.ocamlPackage.stdlib-shims ]; 
    buildInputs = [ ocaml findlib ]; 
  
    createFindlibDestdir = true;

}
