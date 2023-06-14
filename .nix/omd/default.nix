{ }:
let 
    pkgs = import <nixpkgs> {};
    stdenv = pkgs.stdenv;
    fetchurl = pkgs.fetchurl;
    fetchgithub = pkgs.fetchFromGitHub;
  #  ocaml = pkgs.ocaml;
  #  op = pkgs.ocamlPackages;
   # op = pkgs.ocaml-ng.ocamlPackages_4_02;
   # ocaml = op.ocaml;
    minepkgs = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "mine1402";                                                 
         url = "https://github.com/NixOS/nixpkgs/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
     }) {};                                                                           
     ocaml = minepkgs.ocamlPackages.ocaml;
     findlib = minepkgs.ocamlPackages.findlib;

in stdenv.mkDerivation {
    name = "ocaml_omd";
  
    #src = fetchurl {
    #  #url = http://pw374.github.io/distrib/omd/omd-1.2.6.tar.gz;
    #  url = https://github.com/ocaml/omd/archive/refs/tags/1.3.1.tar.gz;
    #  #sha256 = "4164fe538149e51e19c2bd786f5f817b7c2f6ba9d1376965d2e43d93d745aeb6";
    #};
    src = fetchgithub {
      #url = http://pw374.github.io/distrib/omd/omd-1.2.6.tar.gz;
      owner = "ocaml";
      repo = "omd";
      rev =  "861afb6";
      #url = https://github.com/ocaml/omd/archive/refs/tags/1.3.1.tar.gz;
      sha256 = "0A9N6IwvE0uTcFKkceds2rZ9YXx/RvB4SOusYaMGwc0=";
    };
  
    buildInputs = [ ocaml findlib  ]; 
 
    configurePhase="
    mkdir -p $out/bin
    export bindir=$out/bin
    make configure
";

    createFindlibDestdir = true;

}
