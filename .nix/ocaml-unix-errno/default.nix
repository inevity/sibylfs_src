{ }:
let 
    pkgs = import <nixpkgs> {};
    stdenv = pkgs.stdenv;
    fetchgit = pkgs.fetchgit;
    #ocaml = pkgs.ocaml;
    op = pkgs.ocaml-ng.ocamlPackages_4_02;
    ocaml = op.ocaml;
    #findlib = pkgs.ocamlPackages.findlib; # needed?
    findlib = op.findlib;
    ocaml_version = (pkgs.lib.getVersion ocaml);
    #must place here, not in let 
    #so use the ctypes 0.13.1
    mine = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "mine402";                                                 
         url = "https://github.com/NixOS/nixpkgs/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
     }) {};                                                                           

    ctypes = mine.ocamlPackages.ctypes;
in 
let 
    rresult = stdenv.mkDerivation {
    name = "ocaml-rresult";
  
    src = fetchgit {
      url = https://github.com/dbuenzli/rresult.git;
      rev = "4524762a5";
      sha256 = "1zriaj4xaj7a5zw848m6sp0rh69xk15zdazpnkpw899y39yv5a0p";
    };
  
    #buildInputs = [ ocaml findlib pkgs.opam op.ctypes ]; 
    buildInputs = [ ocaml findlib pkgs.opam ctypes ]; 

    buildPhase = ''

ocaml pkg/git.ml
ocaml pkg/build.ml native=true native-dynlink=true # FIXME tr not sure about these; trying to get the same result as https://github.com/dbuenzli/rresult/blob/master/opam

    '';

    installPhase = ''
opam-installer --prefix=$out/lib/ocaml/${ocaml_version}/site-lib/ --libdir=. rresult.install
    '';
  
    createFindlibDestdir = true;

    };
in
stdenv.mkDerivation {
    name = "ocaml-unix-errno";
  
    src = fetchgit {
      url = https://github.com/dsheets/ocaml-unix-errno.git;
      rev = "5b705b7";
      sha256 = "0pf54p7pcvbxhszh7scsw81m8p2yl7l3mqpy7mxz9nygaq6xibrp";
      #now 0.2 version 
    };
  
    #why use newest ctypes?
    #buildInputs = [ ocaml findlib op.camlp4 op.ctypes rresult ]; 
    buildInputs = [ ocaml findlib op.camlp4 ctypes rresult ]; 
  
    createFindlibDestdir = true;

    rresult = rresult;

}
