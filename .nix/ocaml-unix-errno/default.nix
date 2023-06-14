{ }:
let 
    pkgs = import <nixpkgs> {};
    #stdenv = pkgs.stdenv;
    fetchgit = pkgs.fetchgit;
    #ocaml = pkgs.ocaml;
    #op = pkgs.ocaml-ng.ocamlPackages_4_02;
    #op = pkgs.ocaml-ng.ocamlPackages_4_00_1;
    #op = pkgs.ocaml-ng.ocamlPackages_4_01_0;
    #ocaml = op.ocaml;
    #findlib = pkgs.ocamlPackages.findlib; # needed?
    #findlib = op.findlib;
    #ocaml_version = (pkgs.lib.getVersion ocaml);
    #must place here, not in let 
    #so use the ctypes 0.13.1
    mine = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "mine402";                                                 
         url = "https://github.com/NixOS/nixpkgs/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
     }) {};                                                                           
    #findlib = mine.ocamlPackages.findlib;
    #ocaml = mine.ocamlPackages.ocaml;
     findlib = mine.ocamlPackages_4_02.findlib;
     #ocaml = minepkgs.ocamlPackages.ocaml_4_02;
     ocaml = mine.ocaml_4_02;

    camlp4 = mine.ocamlPackages_4_02.camlp4;
    result = mine.ocamlPackages_4_02.result;

    #ctypes = mine.ocamlPackages.ctypes;
    ctypes = import ../ocaml_ctypes { } ;
    #ctypes = op.ctypes;
    #ctypes too new??
#    stubs = ctypes.stubs;
    stdenv = mine.stdenv;
    ocamlbuild = mine.ocamlPackages_4_02.ocamlbuild;
in 
#let 
#    rresult = stdenv.mkDerivation {
#    name = "ocaml-rresult";
#  
#    src = fetchgit {
#      url = https://github.com/dbuenzli/rresult.git;
#      rev = "4524762a5";
#      sha256 = "1zriaj4xaj7a5zw848m6sp0rh69xk15zdazpnkpw899y39yv5a0p";
#    };
#  
#    #buildInputs = [ ocaml findlib pkgs.opam op.ctypes ]; 
#    buildInputs = [ ocaml findlib pkgs.opam ctypes ]; 
#
#    buildPhase = ''
#
#ocaml pkg/git.ml
#ocaml pkg/build.ml native=true native-dynlink=true # FIXME tr not sure about these; trying to get the same result as https://github.com/dbuenzli/rresult/blob/master/opam
#
#    '';
#
#    installPhase = ''
#opam-installer --prefix=$out/lib/ocaml/${ocaml_version}/site-lib/ --libdir=. rresult.install
#    '';
#  
#    createFindlibDestdir = true;
#
#    };
#in
stdenv.mkDerivation {
    name = "ocaml-unix-errno";
  
    #src = fetchgit {
    #  url = https://github.com/dsheets/ocaml-unix-errno.git;
    #  rev = "5b705b7";
    #  sha256 = "0pf54p7pcvbxhszh7scsw81m8p2yl7l3mqpy7mxz9nygaq6xibrp";
    #  #now 0.2 version 
    #};
    #src = fetchgit {
    #  url = https://github.com/dsheets/ocaml-unix-errno.git;
    #  #url = https://ghproxy.com/github.com/dsheets/ocaml-unix-errno.git;
    #  rev = "ffeb1de";
    #  #sha256 = "0pf54p7pcvbxhszh7scsw81m8p2yl7l3mqpy7mxz9nygaq6xibrp";
    #  sha256 = "NTOseIoRJb3de61AJLHEQE5YKl9OUmA2cJX8tE/aHgg=";
    #};
    #Locally-open F in each 'foreign' binding. (#9)
    src = fetchgit {
      url = https://github.com/dsheets/ocaml-unix-errno.git;
      rev = "64a853e";
      #sha256 = "0pf54p7pcvbxhszh7scsw81m8p2yl7l3mqpy7mxz9nygaq6xibrp";
      sha256 = "U0ITe+uyjsDlVOmJ/P7no/EPmG+0vuuaoA1VnroskOw=";
    };
    #export LD_LIBRARY_PATH=${ctypes}/lib/ocaml/${ocaml_version}/site-lib/ctypes;
  
    #why use newest ctypes?
    #buildInputs = [ ocaml findlib op.camlp4 op.ctypes rresult ]; 
    #why use ocaml new?
   # buildInputs = [ ocaml findlib ocamlbuild camlp4 ctypes ctypes.stubs result ]; 
    buildInputs = [ ocaml findlib ocamlbuild camlp4 ctypes result ]; 
    #buildInputs = [ ocaml findlib ocamlbuild camlp4 result ]; 
    #buildInputs = [ ocaml findlib ocamlbuild camlp4 stubs result ]; 
  
    createFindlibDestdir = true;
#    ❯ sudo find /nix/store -name dllctypes_stubs.so
#/nix/store/w44iwji1gkww8jzgm0kpd452px2dpwmy-ocaml4.14.1-ctypes-0.20.2/lib/ocaml/4.14.1/site-lib/stublibs/dllctypes_stubs.so
#/nix/store/wmjl5i9qqcsiwlni3cggd1vnx1srzxma-ocaml4.02.3-ctypes-0.20.2/lib/ocaml/4.02.3/site-lib/stublibs/dllctypes_stubs.so
#/nix/store/g1fbj39vnznxiby58d2b5112n2zrg8mg-ocaml-ctypes-0.13.1/lib/ocaml/4.05.0/site-lib/ctypes/dllctypes_stubs.so
#/nix/store/cbjv2hp852999a1z258lrw1d853i8l9g-ocaml_ctypes/lib/ocaml/4.05.0/site-lib/ctypes/dllctypes_stubs.so
#export LD_LIBRARY_PATH=${ctypes}/lib/ocaml/${ocaml_version}/site-lib/ctypes
   buildPhase = "
export LD_LIBRARY_PATH=${ctypes}/lib/ocaml/4.05.0/site-lib/ctypes/
make build
";

    #rresult = rresult;

}
