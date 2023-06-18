{ }:
let 
    pkgs = import <nixpkgs> {};
    #stdenv = pkgs.stdenv;
    fetchgit = pkgs.fetchgit;
    perl = pkgs.perl;
    #ocaml = pkgs.ocaml;
    #op = pkgs.ocamlPackages;
   # op = pkgs.ocaml-ng.ocamlPackages_4_02;
   # ocaml = op.ocaml;
   # findlib=op.findlib;
   # cppo=op.cppo;
   # ocaml_sexplib = op.ocaml_sexplib;
    mine = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "mine1402";                                                 
         url = "https://github.com/NixOS/nixpkgs/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
    }) {};                                                                           
    findlib = mine.ocamlPackages_4_02.findlib;
    cppo = mine.ocamlPackages_4_02.cppo;
    ocaml_sexplib = mine.ocamlPackages_4_02.ocaml_sexplib;
    ocaml = mine.ocamlPackages_4_02.ocaml;
    stdenv = mine.stdenv;
    sha = import ./sha { };
    isabelle = import ./isabelle { };
    lem = import ./lem { };
in stdenv.mkDerivation {
    name = "lemenv";

    # make these available in nix-shell
    lem = lem;
    isabelle = isabelle;
    sha = sha;
    
  
    src = lem;  
    buildInputs = [ isabelle ocaml findlib sha cppo ocaml_sexplib lem ]; 
  
    buildPhase = ''
false
      '';

# eval "${!curPhase:-$curPhase}" from nix-shell

shellHook = ''
    export LEMPATH=${lem}/lem
    export PATH=$PATH:${lem}/lem
    export LEMLIB=${lem}/lem/library
  '';

}
