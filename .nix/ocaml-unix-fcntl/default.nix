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
    #findlib = mine.ocamlPackages.findlib;
    #ocaml = mine.ocamlPackages.ocaml;
     findlib = mine.ocamlPackages_4_02.findlib;
     #ocaml = minepkgs.ocamlPackages.ocaml_4_02;
     ocaml = mine.ocaml_4_02;

    stdenv = mine.stdenv;

    ocaml-unix-errno = import ../ocaml-unix-errno { } ;
    #ocaml-unix-type-representations = import ../ocaml-unix-type-representations {} ;
    unix-type-representations = import ../ocaml-unix-type-representations {} ;
    #ctypes = mine.ocamlPackages_4_02.ctypes;
    ctypes = import ../ocaml_ctypes { } ;
    # or use propagete, lost the camplp4 
    camlp4 = mine.ocamlPackages_4_02.camlp4;
    ocamlbuild = mine.ocamlPackages_4_02.ocamlbuild;
    result = mine.ocamlPackages_4_02.result;
    lwt = mine.ocamlPackages_4_02.lwt2;
    #lwt = mine.ocamlPackages.lwt;
    #https://github.com/yallop/ocaml-unix-type-representations/archive/refs/tags/0.1.1.tar.gz
    #why must define here, direct use is not ok?
    #ctypes = op.ctypes;
    ocaml_version = (pkgs.lib.getVersion ocaml);
in stdenv.mkDerivation {
    name = "ocaml-unix-fcntl";
  
    #src = fetchgit {
    #  url = https://github.com/dsheets/ocaml-unix-fcntl.git;
    #  rev = "83ae867"; # july 27 2015
    #  sha256 = "06fznyvgkgfxkwk60v499ifb74y0ip6p5wwggckj2fspp0ljnlyg";
    #};
    #src = fetchgit {
    #  url = https://github.com/dsheets/ocaml-unix-fcntl.git;
    #  rev = "c780aee"; # oct 2 2015
    #  sha256 = "06fznyvgkgfxkwk60v499ifb74y0ip6p5wwggckj2fspp0ljnlyg";
    #};
    src = fetchgit {
      url = https://github.com/dsheets/ocaml-unix-fcntl.git;
      rev = "38c0953f7d24a02492bf7a93882f89964384dd5c"; # support unixerro 0.4.
      sha256 = "WLD7bw/RDc6GYeKFycJyrKHK5Ew1KGLtb0fgdOx3820=";
    };
  
    #buildInputs = [ ocaml findlib op.ocamlPackages.ctypes ocaml-unix-errno ocaml-unix-errno.rresult ]; 
    #buildInputs = [ ocaml findlib ctypes ocaml-unix-errno ocaml-unix-errno.rresult ]; 
    #buildInputs = [ ocaml findlib ctypes ocaml-unix-errno ocaml-unix-type-representations ocamlbuild camlp4 ]; 
    buildInputs = [ ocaml findlib ctypes lwt ocaml-unix-errno result unix-type-representations ocamlbuild camlp4 ]; 
    #buildInputs = [ ocaml findlib ctypes ocaml-unix-errno result unix-type-representations ocamlbuild camlp4 ]; 
   buildPhase = "
export LD_LIBRARY_PATH=${ctypes}/lib/ocaml/${ocaml_version}/site-lib/ctypes/
make build
";
  
    createFindlibDestdir = true;

}
