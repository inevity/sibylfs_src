{ }:
let 
    pkgs = import <nixpkgs> {};
    inherit (pkgs) fetchgit;
    #op = pkgs.ocamlPackages;
    #inherit (op) findlib cppo sexplib cstruct;
    op = pkgs.ocaml-ng.ocamlPackages_4_02;
    #ocaml = op.ocaml;
    #inherit (op) findlib cppo;
    minepkgs = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "mine1402";                                                 
         url = "https://github.com/NixOS/nixpkgs/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
     }) {};                                                                           

    cstruct = minepkgs.ocamlPackages_4_02.cstruct;
    sexplib = minepkgs.ocamlPackages_4_02.sexplib;
    cmdliner = minepkgs.ocamlPackages_4_02.cmdliner;
    menhir = minepkgs.ocamlPackages_4_02.menhir;
    findlib = minepkgs.ocamlPackages_4_02.findlib;
    cppo = minepkgs.ocamlPackages_4_02.cppo;
    ocaml = minepkgs.ocamlPackages_4_02.ocaml;
    sha = import ../.nix/sha { };
    fd_send_recv = import ../.nix/fd-send-recv { };
    lem_in_nix = import ../.nix/lem { };
    ocaml_cow = import ../.nix/ocaml_cow { };
    ocaml_dyntype = import ../.nix/dyntype { };
    stdenv = minepkgs.stdenv;
    ocaml_version = (pkgs.lib.getVersion ocaml);
    camlp4 = minepkgs.ocamlPackages_4_02.camlp4;

in stdenv.mkDerivation {

    name = "fs_spec";
  
    src = ./.;  

    # git for version num    
    buildInputs = [ ocaml findlib camlp4 cppo sexplib sha cmdliner fd_send_recv 
      lem_in_nix pkgs.coreutils pkgs.git menhir ocaml_cow ]; 
  
    cppo="${cppo}/bin/cppo";
    lem="${lem_in_nix}/lem/lem";
    LEMLIB="${lem_in_nix}/lem/library";
    LD_LIBRARY_PATH="${cstruct}/lib/ocaml/${ocaml_version}/site-lib/cstruct";
    EXTRACTDIR="${lem_in_nix}/lem/ocaml-lib/_build";
    DISABLE_BYTE="true";
    
    buildPhase = ''
      make
      mkdir -p $out
      cp -RL _build $out
    '';
  
    installPhase = "true";  # skip

}
