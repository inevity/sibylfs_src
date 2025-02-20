{ }:
let 
    pkgs = import <nixpkgs> {};
    #stdenv = pkgs.stdenv;
    fetchurl = pkgs.fetchurl;
    #ocaml = pkgs.ocaml;
    #op = pkgs.ocamlPackages.ocaml-ng.ocamlPackages_4_00_1;
    #op = pkgs.ocaml-ng.ocamlPackages_4_00_1;
    #op = pkgs.ocaml-ng.ocamlPackages_4_02;
    #op = pkgs.ocaml-ng.ocamlPackages_4_03;
    op = pkgs.ocaml-ng.ocamlPackages_4_02;
    #ocaml = op.ocaml;
    minepkgs = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "mine1402";                                                 
         url = "https://github.com/NixOS/nixpkgs/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
     }) {};                                                                           

     #type_conv = minepkgs.ocamlPackages.type_conv_108_08_00;
     #       error: type_conv-108.08.00 is not available for OCaml 4.05.0 ? who
     #       set?
     type_conv = minepkgs.ocamlPackages_4_02.type_conv;
     #findlib = op.findlib;
     findlib = minepkgs.ocamlPackages_4_02.findlib;
     ocaml = minepkgs.ocamlPackages_4_02.ocaml;
     stdenv = minepkgs.stdenv;
     ocamlbuild = minepkgs.ocamlPackages_4_02.ocamlbuild;
     camlp4 = minepkgs.ocamlPackages_4_02.camlp4;
     #findlib = minepkgs.ocamlPackages.findlib;
    #op = pkgs.ocaml-ng.ocamlPackages_3_12_1;
    
in stdenv.mkDerivation {
    name = "ocaml_dyntype";
  
    src = fetchurl {
      url = https://github.com/mirage/dyntype/archive/dyntype-0.9.0.tar.gz;
      sha256 = "60e9417f7613d121cea4e9cde4aaafde26b1914b6fd5f4096f6b384e442ab1d0";
    };
  
    #buildInputs = [ ocaml op.findlib op.janeStreet_0_9_0.ppx_type_conv pkgs.which op.camlp4 ]; 
    #buildInputs = [ ocaml op.findlib op.janeStreet_0_9_0.ppx_type_conv pkgs.which op.camlp4 ]; 
    #buildInputs = [ ocaml op.findlib type_conv pkgs.which op.camlp4 ]; 
    #buildInputs = [ ocaml op.findlib op.janeStreet.ppx_type_conv pkgs.which op.camlp4 ]; 
    #buildInputs = [ ocaml op.findlib op.ppx_type_conv pkgs.which op.camlp4 ]; 

    #buildInputs = [ ocaml op.findlib op.type_conv pkgs.which op.camlp4 ]; 
    #buildInputs = [ ocaml op.findlib type_conv pkgs.which op.camlp4 ]; 
    buildInputs = [ ocaml findlib ocamlbuild  type_conv pkgs.which camlp4 ]; 

  
    createFindlibDestdir = true;

}
