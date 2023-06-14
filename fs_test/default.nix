{ }:
let 
  pkgs = import <nixpkgs> {};
  inherit (pkgs) fetchgit;
  #op = pkgs.ocamlPackages;
  #inherit (op) findlib cppo sexplib cstruct;
  op = pkgs.ocaml-ng.ocamlPackages_4_02;
  #ocaml = op.ocaml;
  #stdenv eval the Derivation use the lastest pkgs
  inherit (op) findlib cppo;
  minepkgs = import (builtins.fetchGit {
       # Descriptive name to make the store path easier to identify                
       name = "mine1402";                                                 
       url = "https://github.com/NixOS/nixpkgs/";                       
       ref = "refs/heads/nixpkgs-unstable";                     
       rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
   }) {};                                                                           

  cstruct = minepkgs.ocamlPackages.cstruct;
  sexplib = minepkgs.ocamlPackages.sexplib;
  cmdliner = minepkgs.ocamlPackages.cmdliner;
  menhir = minepkgs.ocamlPackages.menhir;
  sha = import ../.nix/sha { };
  fd_send_recv = import ../.nix/fd-send-recv { };
  lem_in_nix = import ../.nix/lem { };
  ocaml_cow = import ../.nix/ocaml_cow { };
  ocaml_dyntype = import ../.nix/dyntype { };
  ocaml-unix-fcntl = import ../.nix/ocaml-unix-fcntl { };
  ocaml-unix-errno = import ../.nix/ocaml-unix-errno { };
  ocaml_version = (pkgs.lib.getVersion ocaml);
  fs_spec = import ../fs_spec { };
  stdenv = minepkgs.stdenv;
  ocaml = minepkgs.ocamlPackages.ocaml;
  #ctypes = minepkgs.ocamlPackages.ctypes;
  ctypes = import ../.nix/ocaml_ctypes { } ;
in 
stdenv.mkDerivation {

  name = "fs_test";
  
  src = ./.;  
  #buildInputs = [ ocaml findlib cppo sexplib sha op.ctypes op.cmdliner fd_send_recv 
#    lem_in_nix pkgs.coreutils pkgs.git op.menhir ocaml_cow ocaml-unix-fcntl 
#    ocaml-unix-errno ocaml-unix-errno.rresult fs_spec ]; # git for version num
  buildInputs = [ ocaml findlib cppo sexplib sha ctypes cmdliner fd_send_recv 
    lem_in_nix pkgs.coreutils pkgs.git menhir ocaml_cow ocaml-unix-fcntl 
    ocaml-unix-errno fs_spec ]; # git for version num

  LEMLIB = "${lem_in_nix}/lem/library";
  LD_LIBRARY_PATH = "${cstruct}/lib/ocaml/${ocaml_version}/site-lib/cstruct";
  EXTRACTDIR = "${lem_in_nix}/lem/ocaml-lib/_build";
  SPEC_BUILD = "${fs_spec}/_build";
  DISABLE_BYTE = "true";
  
  buildPhase = ''
    export GIT_REV="$out"
    export DIRTY_FLAG=""
    make
    mkdir -p $out
  '';


  # commenting so that the closure is not too large
  #    cp -RL ${fs_spec}/build $out; mkdir -p $out/fs_test; cp -RL . $out/fs_test
  
  installPhase = ''
    mkdir -p $out/bin
    cp fs_test fs_test_check fs_test_posix run_trace test_generation/tgen lib/fs_test_version.ml $out/bin
    # paths/testpath.native testall.sh 
  ''; 

  #  dontPatchELF = true;
  dontPatchShebangs = true;

}
