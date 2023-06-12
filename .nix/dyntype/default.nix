{ }:
let 
    pkgs = import <nixpkgs> {};
    stdenv = pkgs.stdenv;
    fetchurl = pkgs.fetchurl;
    #ocaml = pkgs.ocaml;
    #op = pkgs.ocamlPackages.ocaml-ng.ocamlPackages_4_00_1;
    #op = pkgs.ocaml-ng.ocamlPackages_4_00_1;
    #op = pkgs.ocaml-ng.ocamlPackages_4_02;
    #op = pkgs.ocaml-ng.ocamlPackages_4_03;
    op = pkgs.ocaml-ng.ocamlPackages_4_04;
    ocaml = op.ocaml;
    #op = pkgs.ocaml-ng.ocamlPackages_3_12_1;
    
in stdenv.mkDerivation {
    name = "ocaml_dyntype";
  
    src = fetchurl {
      url = https://github.com/mirage/dyntype/archive/dyntype-0.9.0.tar.gz;
      sha256 = "60e9417f7613d121cea4e9cde4aaafde26b1914b6fd5f4096f6b384e442ab1d0";
    };
  
    buildInputs = [ ocaml op.findlib op.janeStreet_0_9_0.ppx_type_conv pkgs.which op.camlp4 ]; 
    #buildInputs = [ ocaml op.findlib op.janeStreet.ppx_type_conv pkgs.which op.camlp4 ]; 
    #buildInputs = [ ocaml op.findlib op.ppx_type_conv pkgs.which op.camlp4 ]; 
    #buildInputs = [ ocaml op.findlib op.type_conv pkgs.which op.camlp4 ]; 
  
    createFindlibDestdir = true;

}
