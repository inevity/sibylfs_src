{ }:
let 
  pkgs = import <nixpkgs> {};
  inherit (pkgs) git fetchgit fetchFromGitHub;
  #op = pkgs.ocamlPackages;
  #inherit (op) findlib cppo sexplib cstruct;
  op = pkgs.ocaml-ng.ocamlPackages_4_02;
  #ocaml = op.ocaml;
  #stdenv eval the Derivation use the lastest pkgs
  #inherit (op) findlib cppo;
  inherit (op) cppo;
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
  sha = import ../.nix/sha { };
  fd_send_recv = import ../.nix/fd-send-recv { };
  lem_in_nix = import ../.nix/lem { };
  #ocaml_cow = import ../.nix/ocaml_cow { };
  cow = import ../.nix/cow { };
  ocaml_dyntype = import ../.nix/dyntype { };
  ocaml-unix-fcntl = import ../.nix/ocaml-unix-fcntl { };
  ocaml-unix-errno = import ../.nix/ocaml-unix-errno { };
  ocaml_version = (pkgs.lib.getVersion ocaml);
  fs_spec = import ../fs_spec { };
  stdenv = minepkgs.stdenv;
  ocaml = minepkgs.ocamlPackages_4_02.ocaml;
  ocamlbuild = minepkgs.ocamlPackages_4_02.ocamlbuild;
  oasis = minepkgs.ocamlPackages_4_02.ocaml_oasis;
  #default have
 # bash = minepkgs.bash;
  #ctypes = minepkgs.ocamlPackages.ctypes;
  ctypes = import ../.nix/ocaml_ctypes { } ;
  type_conv = minepkgs.ocamlPackages_4_02.type_conv;
  camlp4 = minepkgs.ocamlPackages_4_02.camlp4;
  findlib = minepkgs.ocamlPackages_4_02.findlib;
in let 
   
   pa_sexp_conv = stdenv.mkDerivation {
      # 113.00.02
      #opam need sexplib < 113.01.00  
       name = "pa_sexp_conv";
       src = fetchFromGitHub {
         owner = "janestreet-deprecated";
         repo = "pa_sexp_conv";
         rev = "43a6c3e52e0c3d306d1cbf32c6af36b8b8fd8802";
         sha256 = "A0OaiNSN+f9YCqqR+RjR8ryDbWg4ACjqLwy42EpmMz8=";
       };

       buildInputs = [ ocaml findlib ocamlbuild oasis] ;
       propagatedBuildInputs = [ type_conv camlp4 ];
       createFindlibDestdir = true;
       #and fiindlib must use above, inheit no impact.
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
in 
stdenv.mkDerivation {

  name = "fs_test";
  
  src = ./.;  
  #buildInputs = [ ocaml findlib cppo sexplib sha op.ctypes op.cmdliner fd_send_recv 
#    lem_in_nix pkgs.coreutils pkgs.git op.menhir ocaml_cow ocaml-unix-fcntl 
#    ocaml-unix-errno ocaml-unix-errno.rresult fs_spec ]; # git for version num
  #buildInputs = [ ocaml findlib cppo sexplib sha ctypes cmdliner fd_send_recv 
  buildInputs = [ ocaml findlib cppo pa_sexp_conv sha ctypes cmdliner fd_send_recv 
    lem_in_nix pkgs.coreutils pkgs.git menhir cow ocaml-unix-fcntl 
    ocaml-unix-errno  fs_spec git ]; # git for version num

  LEMLIB = "${lem_in_nix}/lem/library";
  LD_LIBRARY_PATH = "${cstruct}/lib/ocaml/${ocaml_version}/site-lib/cstruct";
  EXTRACTDIR = "${lem_in_nix}/lem/ocaml-lib/_build";
  SPEC_BUILD = "${fs_spec}/_build";
  DISABLE_BYTE = "true";

  #lem=/nix/store/3syv88pzb3vchsfqzgi6bpqmczad18sx-lem/lem/lem
  #LEMLIB=/nix/store/3syv88pzb3vchsfqzgi6bpqmczad18sx-lem/lem/library
  #EXTRACTDIR=/nix/store/3syv88pzb3vchsfqzgi6bpqmczad18sx-lem/lem/ocaml-lib/_build
  #cppo=/nix/store/gdndpj78qb82lmcnwyhiy3i3ss0bas8q-cppon/bin/cppo
  #DISABLE_BYTE=true
  #export lem LEMLIB EXTRACTDIR cppo  DISABLE_BYTE
    cppo="${cppo}/bin/cppo";
    lem="${lem_in_nix}/lem/lem";
    #shell env 
  
    #SPEC_BUILD="${SPEC_BUILD:-$ROOT/fs_spec/_build}" # default if not set
    # cmis from elsewhere
    from_lem="
    ${lem_in_nix}/lem/ocaml-lib/_build/*.cmi 
    ${lem_in_nix}/lem/ocaml-lib/_build/extract.*
    ";
   # from_lem="
   # $EXTRACTDIR/*.cmi 
   # $EXTRACTDIR/extract.*
   # "
  
    from_spec="
    ${fs_spec}/_build/lem_support.cmi 
    ${fs_spec}/_build/abstract_string.cmi 
    ${fs_spec}/_build/fs_interface.cmi
    ${fs_spec}/_build/fs_dict_wrappers.cmi
    ${fs_spec}/_build/fs_prelude.cmi
    ${fs_spec}/_build/fs_spec_lib.*
    ";
    
    COREPKGS="unix,bigarray,str,num,bytes";
    #XTRAPKGS="bytes,sexplib,sexplib.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,$BISECT"
    #XTRAPKGS="bytes,sexplib,sexplib.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl";
    XTRAPKGS="bytes,pa_sexp_conv, pa_sexp_conv.syntax, cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl";
    #PKGS="-package $COREPKGS,$XTRAPKGS"
    #PKGS="-package unix,bigarray,str,num,bytes,bytes,sexplib,sexplib.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl"
    #TODO sexplib
    #PKGS="-package unix,bigarray,str,num,bytes,sexplib,sexplib.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl";
    PKGS="-package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl";
    SYNTAX="-syntax camlp4o";
    WARN="-w @f@p@u@s@40";
    CCFLAGS="-g";
    
    WITH_FS_CHECK_LIB="-I $out/lib fs_check_lib.cmxa";
    
    # FIXME we should include fs_check_lib when we know it has been built
  #    ocamlc="$DISABLE_BYTE ocamlfind ocamlc   $WARN $CCFLAGS $PKGS -I $BASH_DIR/include extract.cma  fs_spec_lib.cma $SYNTAX"
  #  ocamlopt="$DISABLE_NTVE ocamlfind ocamlopt $WARN $CCFLAGS $PKGS -I $BASH_DIR/include extract.cmxa fs_spec_lib.cmxa $SYNTAX"
  #  ocamldep="ocamlfind ocamldep $WARN $CCFLAGS $PKGS -I $BASH_DIR/include extract.cmxa fs_spec_lib.cmxa $SYNTAX $FCLXA"
     DISABLE_NTVE="true"; 
  #    ocamlc="ocamlfind ocamlc -w @f@p@u@s@40     -g  $PKGS -I $out/include extract.cma  fs_spec_lib.cma -syntax camlp4o";
  #  ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40   -g  $PKGS -I $out/include extract.cmxa fs_spec_lib.cmxa -syntax camlp4o";
  #  ocamldep="ocamlfind ocamldep $WARN $CCFLAGS $PKGS -I $out/include extract.cmxa fs_spec_lib.cmxa -syntax camlp4o $FCLXA";
      ocamlc="ocamlfind ocamlc -w @f@p@u@s@40     -g -package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,unix-errno -I $out/include extract.cma  fs_spec_lib.cma -syntax camlp4o";
    ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40   -g -package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,unix-errno -I $out/include extract.cmxa fs_spec_lib.cmxa -syntax camlp4o";
    ocamldep="ocamlfind ocamldep -w @f@p@u@s@40 -g -package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,unix-errno -I $out/include extract.cmxa fs_spec_lib.cmxa -syntax camlp4o $FCLXA";
    
    #mk_native="$ocamlopt $WITH_FS_CHECK_LIB $out/lib/syscall_stubs.o";
    mk_native="$ocamlopt -I $out/lib fs_check_lib.cmxa $out/lib/syscall_stubs.o";
    # lib dir
    #BASH_DIR=$(realpath $(dirname $BASH_SOURCE))
    #ROOT=$BASH_DIR/../..
    
    #test -f $ROOT/config.sh && source $ROOT/config.sh
    #source ../bash_env.sh
    
    #ocamlc="$DISABLE_BYTE ocamlfind ocamlc   $WARN $CCFLAGS $PKGS -I ../include fs_spec_lib.cma  $SYNTAX"
    #ocamlopt="$DISABLE_NTVE ocamlfind ocamlopt $WARN $CCFLAGS $PKGS -I ../include fs_spec_lib.cmxa $SYNTAX"
    #
    #mk_cma="$DISABLE_BYTE ocamlfind ocamlc"
    #mk_cmxa="$DISABLE_NTVE ocamlfind ocamlopt"
    #
    #function run_menhir {
    #    menhir --explain --infer --ocamlc "ocamlfind ocamlc $PKGS -I ../include $SYNTAX" $@
    #}


   # lib_ocamlc="ocamlfind ocamlc   $WARN $CCFLAGS $PKGS -I ../include fs_spec_lib.cma  $SYNTAX";
   # lib_ocamlopt="ocamlfind ocamlopt $WARN $CCFLAGS $PKGS -I ../include fs_spec_lib.cmxa $SYNTAX";
    #lib_ocamlc="ocamlfind ocamlc -w @f@p@u@s@40     -g  $PKGS -I ../include   fs_spec_lib.cma -syntax camlp4o";
    lib_ocamlc="ocamlfind ocamlc -w @f@p@u@s@40     -g  -package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,unix-errno -I ../include   fs_spec_lib.cma -syntax camlp4o";
    #lib_ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40   -g  $PKGS -I ../include fs_spec_lib.cmxa -syntax camlp4o";
    lib_ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40   -g -package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,unix-errno -I ../include fs_spec_lib.cmxa -syntax camlp4o";
    
    mk_cma="ocamlfind ocamlc";
    mk_cmxa="ocamlfind ocamlopt";
    
    #how defein fn to makefile?
   # function run_menhir {
   #     menhir --explain --infer --ocamlc "ocamlfind ocamlc $PKGS -I ../include $SYNTAX" $@
   #     menhir --explain --infer --ocamlc "ocamlfind ocamlc -package unix,bigarray,str,num,bytes,sexplib,sexplib.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl -I ../include -syntax camlp4o" $@
   # }
  #debug_ocamlc="$DISABLE_BYTE ocamlfind ocamlc   $WARN $CCFLAGS $PKGS -I $BASH_DIR/include extract.cma  fs_spec_lib.cma $SYNTAX $WITH_FS_CHECK_LIB"
  #debug_ocamlopt="$DISABLE_NTVE ocamlfind ocamlopt $WARN $CCFLAGS $PKGS -I $BASH_DIR/include extract.cmxa fs_spec_lib.cmxa $SYNTAX $WITH_FS_CHECK_LIB"
  #TODO fs_check_lib.cmxa do what?
#  debug_ocamlc="ocamlfind ocamlc  -w @f@p@u@s@40   -g -package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,unix-errno     -I ../../include extract.cma  fs_spec_lib.cma  -I $out/lib fs_check_lib.cmxa -syntax camlp4o";
#  debug_ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40   -g -package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,unix-errno  -I ../../include extract.cmxa fs_spec_lib.cmxa -I $out/lib fs_check_lib.cmxa -syntax camlp4o";
  debug_ocamlc="ocamlfind ocamlc  -w @f@p@u@s@40   -g -package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,unix-errno     -I ../../include extract.cma  fs_spec_lib.cma  -I $out/lib -syntax camlp4o";
  debug_ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40   -g -package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,unix-errno  -I ../../include extract.cmxa fs_spec_lib.cmxa -I $out/lib -syntax camlp4o";
  #debug_ocamlc="ocamlfind ocamlc  -w @f@p@u@s@40   -g -package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,unix-errno     -I ../../include extract.cma  fs_spec_lib.cma -I $out/lib fs_check_lib.cmxa ";
  #debug_ocamlopt="ocamlfind ocamlopt -w @f@p@u@s@40   -g -package unix,bigarray,str,num,bytes,pa_sexp_conv,pa_sexp_conv.syntax,cmdliner,fd-send-recv,sha,cow,cow.syntax,unix-fcntl,unix-errno  -I ../../include extract.cmxa fs_spec_lib.cmxa -syntax camlp4o -I $out/lib fs_check_lib.cmxa";
  #    
      
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
