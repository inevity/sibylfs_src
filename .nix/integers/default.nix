{ }:
let 
    pkgs = import <nixpkgs> {};
    fetchgit = pkgs.fetchgit;
    mine = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "mine402";                                                 
         url = "https://github.com/NixOS/nixpkgs/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
     }) {};                                                                           
     findlib = mine.ocamlPackages_4_02.findlib;
     ocaml = mine.ocaml_4_02;

    camlp4 = mine.ocamlPackages_4_02.camlp4;
    result = mine.ocamlPackages_4_02.result;

    stdenv = mine.stdenv;
    ocamlbuild = mine.ocamlPackages_4_02.ocamlbuild;
    topkg = mine.ocamlPackages_4_02.topkg;
    opam = mine.opam;
    #ocamlfind = mine.ocamlPackages_4_02.ocamlfind;
    ocaml_version = (pkgs.lib.getVersion ocaml);
    dune = mine.ocamlPackages_4_02.dune_1;

    #dune = mine.dune;
    #dune = pkgs.dune;
    #dune = pkgs.ocamlPackages.dune_1;
in 
stdenv.mkDerivation {
    name = "ocaml-integers";
    src = fetchgit {
      url = https://github.com/yallop/ocaml-integers.git;
      #rev = "b442bc2f3d27a12732c0332f08802b34aff321b8"; #0.2.0 -0.2.1 
      #sha256 = "K0vbItjcis/jmeCTqUNa98FhebDVhpFANOuRGC1+p3A=";
      rev = "34b61adf334881d95416bf7d7c17683c54c10f2c"; #0.1.0
      sha256 = "Ha8Ug8jujnHwJW9u3J39ItdIOveL5894t2ShKGLGLys=";
      #Too new
      #rev = "41846f424b13af552200939228492d29bd06a495"; #0.3 2019 
      #sha256 = "F0lM/31YyGXlTXG0JnukY11Jyx3d1QjrMDBrAn9xEfo=";
      #0.1.0 0.2.0 0.2.1  0.2.2    0.3.0

    };
    #buildInputs = [ ocaml findlib ocamlbuild camlp4 topkg ocamlfind ]; 
    buildInputs = [ ocaml findlib ocamlbuild camlp4 topkg opam ]; 
    #buildInputs = [ ocaml findlib ocamlbuild camlp4 topkg dune ]; 
    #buildPhase = "ocaml pkg/pkg.ml build";
    installPhase = "true";
    #installPhase = "ocaml pkg/pkg.ml install";
  
    createFindlibDestdir = true;
}
#{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg }:
#
#stdenv.mkDerivation {
#	name = "ocaml${ocaml.version}-integers-0.2.2";
#
#	src = fetchurl {
#		url = https://github.com/ocamllabs/ocaml-integers/releases/download/v0.2.2/integers-0.2.2.tbz;
#		sha256 = "08b1ljw88ny3l0mdq6xmffjk8anfc77igryva5jz1p6f4f746ywk";
#	};
#
#	unpackCmd = "tar xjf $src";
#
#	buildInputs = [ ocaml findlib ocamlbuild topkg ];
#
#	inherit (topkg) buildPhase installPhase;
#
#	meta = {
#		description = "Various signed and unsigned integer types for OCaml";
#		license = stdenv.lib.licenses.mit;
#		homepage = https://github.com/ocamllabs/ocaml-integers;
#		maintainers = [ stdenv.lib.maintainers.vbgl ];
#		inherit (ocaml.meta) platforms;
#	};
#}
#*/
