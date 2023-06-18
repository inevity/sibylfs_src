{ }:
let 
    pkgs = import <nixpkgs> {};
    inherit (pkgs) fetchgit fetchurl fetchFromGitHub;
    #op = pkgs.ocamlPackages;
    #inherit (op) findlib cppo sexplib cstruct;
   # op = pkgs.ocaml-ng.ocamlPackages_4_02;
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
    #sexplib = minepkgs.ocamlPackages_4_02.sexplib;
    #sexplib = minepkgs.ocamlPackages.sexplib_111_25_00;
    #sexplib = minepkgs.ocamlPackages.sexplib_112_24_01;
    #should 113
    #sexplib = minepkgs.ocamlPackages.sexplib_p4;
    #ppx_sexp_conv = minepkgs.ocamlPackages.ppx_sexp_conv;
    cmdliner = minepkgs.ocamlPackages_4_02.cmdliner;
    menhir = minepkgs.ocamlPackages_4_02.menhir;
    findlib = minepkgs.ocamlPackages_4_02.findlib;
    #cppo = minepkgs.ocamlPackages_4_02.cppo;
    #cppo = minepkgs.ocamlPackages.cppo;
    ocaml = minepkgs.ocamlPackages_4_02.ocaml;
    sha = import ../.nix/sha { };
    fd_send_recv = import ../.nix/fd-send-recv { };
    lem_in_nix = import ../.nix/lem { };
    #ocaml_cow = import ../.nix/ocaml_cow { };
    cow = import ../.nix/cow { };
    ocaml_dyntype = import ../.nix/dyntype { };
    stdenv = minepkgs.stdenv;
    ocaml_version = (pkgs.lib.getVersion ocaml);
    camlp4 = minepkgs.ocamlPackages_4_02.camlp4;
    jbuilder = minepkgs.jbuilder;
    ocamlbuild = minepkgs.ocamlPackages_4_02.ocamlbuild;
    bash = minepkgs.bash;
    type_conv = minepkgs.ocamlPackages_4_02.type_conv;
    oasis = minepkgs.ocamlPackages_4_02.ocaml_oasis;


in let 
    cppon = stdenv.mkDerivation {
    name = "cppon";
  
    src = fetchgit {
      url = https://github.com/ocaml-community/cppo.git;
      rev = "404070a7b3a0aea7eda9815d1690bc92639042a0";
      sha256 = "cM8Yx4I2VYkscZ3sOpRkEP4fDmG9oUzrLflZDibjtJo=";
    };
    #buildInputs = [ ocaml findlib ocamlbuild ] ++ (param.buildInputs or []);
    buildInputs = [ ocaml findlib ocamlbuild jbuilder ] ;
    inherit (jbuilder) installPhase;
    };

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
       createFindlibDestdir = true;
  };

# in let 
# 
# #https://github.com/janestreet-deprecated/pa_sexp_conv.git
#    #sexplib = stdenv.mkDerivation {
#    pa_sexp_conv = stdenv.mkDerivation {
#        name = "pa_sexp_conv";
#        version = "112.24.01";
# 
# 
#        src = fetchFromGitHub {
#          owner = "janestreet-deprecated";
#          repo = "pa_sexp_conv";
#          rev = "43a6c3e52e0c3d306d1cbf32c6af36b8b8fd8802";
#          sha256 = "A0OaiNSN+f9YCqqR+RjR8ryDbWg4ACjqLwy42EpmMz8=";
#        };
# 
#        buildInputs = [ ocaml findlib ocamlbuild oasis] ;
#        propagatedBuildInputs = [ type_conv camlp4 ];
#        #SETUP="setup.exe";
#        #configureFlags="--prefix $out";
#        #configurePhase="make configure";
#        #buildPhase="make build";
#        #installPhase="make install";
#        #SETUP="setup.exe";
#        #configureFlags="--prefix $out";
#        #./configure --prefix $out 
#        #SETUP=setup.exe make configure --prefix $out 
#        #configurePhase=''
#        #SETUP=setup.exe make configure 
#        #make 
#        #'';
#        #buildPhase="make build";
#        #installPhase="make install";
# 
# 
#        #SETUP=setup.exe make configure 
#        #make 
#        #ocaml setup.ml -configure --prefix $out
#        configurePhase=''
#          oasis setup
#          ocaml setup.ml -configure --prefix $out 
#        '';
#        buildPhase=''
#          ocaml setup.ml -build 
#        '';
#        installPhase=''
#          ocaml setup.ml -install --prefix $out 
#        '';
#   };
#   # sexplib = stdenv.mkDerivatio{
#   #     name = "sexplib";
#   #     version = "112.24.01";
# 
#   #     src = fetchurl {
#   #       #url = "https://github.com/janestreet/sexplib/archive/${version}.tar.gz";
#   #       url = "https://github.com/janestreet/sexplib/archive/112.24.01.tar.gz";
#   #       sha256 = "5f776aee295cc51c952aecd4b74b52dd2b850c665cc25b3d69bc42014d3ba073";
#   #     };
# 
#   #     buildInputs = [ ocaml findlib ocamlbuild ] ;
#   #     propagatedBuildInputs = [ type_conv camlp4 ];
#   #   #  configureFlags="--prefix $out";
#   #   #  configurePhase="make configure";
#   #   #  buildPhase="make build";
#   #   #  installPhase="make build";
#   #     configurePhase="ocaml setup.ml -configure --prefix $out";
#   #     buildPhase="ocaml setup.ml -build";
#   #     installPhase="ocaml setup.ml -install";
#   #};
in stdenv.mkDerivation {

    name = "fs_spec";
  
    src = ./.;  

    # git for version num    
    #buildInputs = [ ocaml findlib camlp4 cppo sexplib sha cmdliner fd_send_recv 
    #buildInputs = [ ocaml findlib camlp4 cppon sexplib sha cmdliner fd_send_recv 
    buildInputs = [ ocaml findlib camlp4 cppon pa_sexp_conv sha cmdliner fd_send_recv 
      lem_in_nix pkgs.coreutils pkgs.git menhir cow bash ]; 

    #propagatedBuildInputs = [ pa_sexp_conv ];  
  
    #cppo="${cppo}/bin/cppo";
    cppo="${cppon}/bin/cppo";
    lem="${lem_in_nix}/lem/lem";
    LEMLIB="${lem_in_nix}/lem/library";
    LD_LIBRARY_PATH="${cstruct}/lib/ocaml/${ocaml_version}/site-lib/cstruct";
    EXTRACTDIR="${lem_in_nix}/lem/ocaml-lib/_build";
    DISABLE_BYTE="true";
    #NIX_DEBUG = 7;
    NIX_DEBUG = 6;


   CPPO_ARGS="-D aspect_perms";
   LEMFLAGS="-lib $LEMLIB -only_changed_output -wl_unused_vars ign -wl_rename err -wl_comp_message ign -wl_pat_exh ign";
   #TODO as shell env var cannot replace?
   PKGS="-package sexplib,sexplib.syntax,sha";
   SYNTAX="-syntax camlp4o";# simplify: use for every file
   
   # 8~"pattern-matching is not exhaustive"; 
   # 11~"this match case is unused";
   # 26~"unused variable s2"
   #WARN="-w @f@p@u@s@40-8-11-26";
   WARN="";
   
   ## these include syntax, so should work on all files; may be overridden in ocamlc.sh
   #ocamlc="$DISABLE_BYTE ocamlfind ocamlc   $WARN -I $EXTRACTDIR extract.cma  $PKGS $SYNTAX";
   #ocamlopt="$DISABLE_NTVE ocamlfind ocamlopt $WARN -I $EXTRACTDIR extract.cmxa $PKGS $SYNTAX";
   #ocamldep="ocamlfind ocamldep $PKGS";
   #
   #mk_cma="$DISABLE_BYTE ocamlfind ocamlc";
   #mk_cmxa="$DISABLE_NTVE ocamlfind ocamlopt";
   DISABLE_NTVE="true"; 

   #ocamlc="ocamlfind ocamlc   $WARN -I $EXTRACTDIR extract.cma  $PKGS $SYNTAX";
   #ocamlopt="ocamlfind ocamlopt $WARN -I $EXTRACTDIR extract.cmxa $PKGS $SYNTAX";
   #ocamlc="ocamlfind ocamlc -w @f@p@u@s@40-8-11-26-I $EXTRACTDIR extract.cma -package ppx_sexp_conv,sexplib,sexplib.syntax,sha -syntax camlp4o";
   #ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40-8-11-26-I $EXTRACTDIR extract.cmxa -package ppx_sexp_conv,sexplib,sexplib.syntax,sha -syntax camlp4o";
#   ocamlc="ocamlfind ocamlc -w @f@p@u@s@40-8-11-26-I $EXTRACTDIR extract.cma -package sexplib,sexplib.syntax,sha -syntax camlp4o";
#   ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40-8-11-26-I $EXTRACTDIR extract.cmxa -package sexplib,sexplib.syntax,sha -syntax camlp4o";
##   ocamlc="ocamlfind ocamlc -w @f@p@u@s@40-8-11-26-I $EXTRACTDIR extract.cma -package sexplib,sha -syntax camlp4o";
##   ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40-8-11-26-I $EXTRACTDIR extract.cmxa -package sexplib,sha -syntax camlp4o";
#   ocamldep="ocamlfind ocamldep -package sexplib,sexplib.syntax,sha";
   
   #ocamlc="ocamlfind ocamlc -w @f@p@u@s@40-8-11-26-I $EXTRACTDIR extract.cma -package pa_sexp_conv,sha -syntax camlp4o";
   #ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40-8-11-26-I $EXTRACTDIR extract.cmxa -package pa_sexp_conv,sha -syntax camlp4o";
   #only nix var,not defefined var at left.
   ocamlc="ocamlfind ocamlc -w @f@p@u@s@40-8-11-26 -I ${lem_in_nix}/lem/ocaml-lib/_build extract.cma -package pa_sexp_conv,sha -syntax camlp4o";
   ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40-8-11-26 -I ${lem_in_nix}/lem/ocaml-lib/_build extract.cmxa -package pa_sexp_conv,sha -syntax camlp4o";
   ocamldep="ocamlfind ocamldep -package sexplib,sexplib.syntax,sha";
   mk_cma="ocamlfind ocamlc";
   mk_cmxa="ocamlfind ocamlopt";


    #NIX_DEBUG = 5;
   # dumpVars = 1;
    #preConfigure = ''
   # preBuild = ''
   # export cppo="${cppon}/bin/cppo";
   # export lem="${lem_in_nix}/lem/lem";
   # export LEMLIB="${lem_in_nix}/lem/library";
   # export LD_LIBRARY_PATH="${cstruct}/lib/ocaml/${ocaml_version}/site-lib/cstruct";
   # export EXTRACTDIR="${lem_in_nix}/lem/ocaml-lib/_build";
   # export DISABLE_BYTE="true";
   # '';

    
      #export PATH=$PATH:"${cppon}/bin/";
    buildPhase = ''
      make
      mkdir -p $out
      cp -RL _build $out
    '';
  
    installPhase = "true";  # skip

}
