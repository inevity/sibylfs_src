{ }:
let 
    pkgs = import <nixpkgs> {};
#    stdenv = pkgs.stdenv;
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
     #ocaml = minepkgs.ocamlPackages_4_02.ocaml;
     #opam = minepkgs.opam;
     #findlib = minepkgs.ocamlPackages_4_02.findlib;
     #stdenv = minepkgs.stdenv;
     #topfind = minepkgs.ocamlPackages_4_02.topfind;
     ocaml = minepkgs.ocamlPackages_4_02.ocaml;
     opam = minepkgs.opam;
     findlib = minepkgs.ocamlPackages_4_02.findlib;
    # ocamlfind = minepkgs.ocamlPackages_4_02.ocamlfind;
     #findlib = minepkgs.ocamlPackages.findlib;
     #findlib = pkgs.ocamlPackages.findlib;
     #op = pkgs.ocaml-ng.ocamlPackages_4_02;
     #findlib = op.findlib;

     stdenv = minepkgs.stdenv;
     #stdenv = pkgs.stdenv;
    # camlp4 = minepkgs.ocamlPackages_4_02.camlp4;
     camlp4 = minepkgs.ocamlPackages_4_02.camlp4;
     ocamlbuild = minepkgs.ocamlPackages_4_02.ocamlbuild;
     #oasis = minepkgs.ocamlPackages_4_02.oasis;
     
     #topfind = minepkgs.ocamlPackages.topfind;
     lwt = minepkgs.ocamlPackages_4_02.ocaml_lwt;       
     #utop = minepkgs.ocamlPackages_4_02.utop;
     utop = minepkgs.ocamlPackages.utop;
     oasis = minepkgs.ocamlPackages_4_02.ocaml_oasis;    
    # oasis2opam = minepkgs.ocamlPackages_4_02.oasis2opam;
     

in stdenv.mkDerivation {
    name = "ocaml_omd";
  
   # src = fetchurl {
   #   url = http://pw374.github.io/distrib/omd/omd-1.2.6.tar.gz;
   #   #url = https://github.com/ocaml/omd/archive/refs/tags/1.3.1.tar.gz;
   #   sha256 = "4164fe538149e51e19c2bd786f5f817b7c2f6ba9d1376965d2e43d93d745aeb6";
   # };
    src = fetchgithub {
      #url = http://pw374.github.io/distrib/omd/omd-1.2.6.tar.gz;
      owner = "ocaml";
      repo = "omd";
      #rev =  "861afb6";
      rev = "2c214d2"; #1.2.5
      #url = https://github.com/ocaml/omd/archive/refs/tags/1.3.1.tar.gz;
      #sha256 = "0A9N6IwvE0uTcFKkceds2rZ9YXx/RvB4SOusYaMGwc0=";
      sha256 = "BHEUxSogTAw/ZDhCRFvqRE8iS9hmbjdzeIRDUdaJl48=";

    };
   # src = fetchgithub {
   #   owner = "ocaml";
   #   repo = "omd";
   #   rev =  "861afb6"; #1.3.1
   #   sha256 = "0A9N6IwvE0uTcFKkceds2rZ9YXx/RvB4SOusYaMGwc0=";
   # };
  
    #buildInputs = [ ocaml findlib opam topfind ]; 
    #buildInputs = [ ocaml findlib ocamlbuild  ocamlfind opam camlp4 lwt utop oasis]; 
    #buildInputs = [ ocaml findlib ocamlbuild  opam camlp4 lwt utop oasis oasis2opam]; 
    #buildInputs = [ ocaml findlib ocamlbuild  opam camlp4 lwt utop oasis ]; 
    buildInputs = [ ocaml findlib ocamlbuild opam camlp4 lwt oasis ]; 
    #buildInputs = [ ocaml findlib ocamlbuild  opam camlp4 lwt oasis ]; 
 
#    #opam init
    #mkdir -p $out/bin
    #export bindir=$out/bin
    #make all
    #make configure
    #topfind not find 
    #ocaml -I $OCAML_TOPLEVEL_PATH -I $CAML_LD_LIBRARY_PATH  setup.ml -configure
    #ocaml setup.ml -configure `opam config var prefix` 

#below install why need /usr create?

    configurePhase="
    oasis setup
    ocaml setup.ml -configure --prefix $out 
";
##
    #ocaml setup.ml -configure --prefix $out
 buildPhase = ''
    ocaml  setup.ml -build
'';

 installPhase = ''
    ocaml setup.ml -install --prefix $out 
'';


#    configurePhase="
#";
###
#    #ocaml setup.ml -configure
# buildPhase = ''
#    cd src
#    make all 
#    ls -lath
#'';

#mkdir -p $out/lem && cp -R -L * $out/lem

    createFindlibDestdir = true;

   pa_sexp_conv = stdenv.mkDerivation {
       name = "pa_sexp_conv";
       src = fetchFromGitHub {
         owner = "janestreet-deprecated";
         repo = "pa_sexp_conv";
         rev = "43a6c3e52e0c3d306d1cbf32c6af36b8b8fd8802";
         sha256 = "A0OaiNSN+f9YCqqR+RjR8ryDbWg4ACjqLwy42EpmMz8=";
       };

       buildInputs = [ ocaml findlib ocamlbuild oasis] ;
       propagatedBuildInputs = [ type_conv camlp4 ];
       configurePhase=''
         oasis setup
         ocaml setup.ml -configure --prefix $out 
       '';
       buildPhase=''
         ocaml setup.ml -build 
       '';
       installPhase=''
         ocaml setup.ml -install --prefix $out 
       '';
  };
}
