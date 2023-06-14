{ }:
let 
    pkgs = import <nixpkgs> {};
    #stdenv = pkgs.stdenv;
    fetchgit = pkgs.fetchgit;
    #op = pkgs.ocaml-ng.ocamlPackages_4_02;
    #ocaml = op.ocaml;
    #ocaml = pkgs.ocaml;
    #findlib = pkgs.ocamlPackages.findlib; # needed?

    mine = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "mine402";                                                 
         url = "https://github.com/NixOS/nixpkgs/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
     }) {};                                                                           
    findlib = mine.ocamlPackages.findlib;
    ocaml = mine.ocamlPackages.ocaml;

    stdenv = mine.stdenv;

    ocaml-unix-errno = import ../ocaml-unix-errno { } ;
    #ctypes = mine.ocamlPackages.ctypes;
    ctypes = import ../ocaml_ctypes { } ;
    # or use propagete, lost the camplp4 
    camlp4 = mine.ocamlPackages.camlp4;
    ocamlbuild = mine.ocamlPackages.ocamlbuild;
    #why must define here, direct use is not ok?
    #ctypes = op.ctypes;
in stdenv.mkDerivation {
    name = "ocaml-unix-fcntl";
  
    src = fetchgit {
      url = https://github.com/dsheets/ocaml-unix-fcntl.git;
      rev = "83ae867"; # july 27 2015
      sha256 = "06fznyvgkgfxkwk60v499ifb74y0ip6p5wwggckj2fspp0ljnlyg";
    };
  
    #buildInputs = [ ocaml findlib op.ocamlPackages.ctypes ocaml-unix-errno ocaml-unix-errno.rresult ]; 
    #buildInputs = [ ocaml findlib ctypes ocaml-unix-errno ocaml-unix-errno.rresult ]; 
    buildInputs = [ ocaml findlib ctypes ocaml-unix-errno ocamlbuild camlp4 ]; 
  
    createFindlibDestdir = true;

}
