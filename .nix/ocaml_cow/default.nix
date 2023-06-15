{ }:
let 
    pkgs = import <nixpkgs> {};
    #stdenv = pkgs.stdenv;
    fetchurl = pkgs.fetchurl;
    fetchgit = pkgs.fetchgit;
    fetchFromGitHub = pkgs.fetchFromGitHub;
    #ocaml = pkgs.ocaml;
    #op = pkgs.ocamlPackages;
    op = pkgs.ocaml-ng.ocamlPackages_4_02;
    #ocaml = op.ocaml;
    #findlib = op.findlib;
#    minepkgs = import (builtins.fetchGit {
#        # Descriptive name to make the store path easier to identify                
#        name = "minepkgs";                                                 
#        url = "https://github.com/NixOS/nixpkgs/";                       
#        ref = "refs/heads/nixpkgs-unstable";                     
#        rev = "0c159930e7534aa803d5cf03b27d5c86ad6050b7";                                           
#     }) {};
#     
#    #cstruct = op.ppx_cstruct;
#    cstruct = minepkgs.ocamlPackages.ppx_cstruct;
#    xmlm = minepkgs.ocamlPackages.xmlm;
#    ezjsonm = minepkgs.ocamlPackages.ezjsonm;
    mine = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "mine402";                                                 
         url = "https://github.com/NixOS/nixpkgs/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
    }) {};                                                                           

    type_conv = mine.ocamlPackages_4_02.type_conv;
    #cstruct = mine.ocamlPackages.ppx_cstruct;
    cstruct = mine.ocamlPackages_4_02.cstruct;
    xmlm = mine.ocamlPackages_4_02.xmlm;
    ocaml = mine.ocamlPackages_4_02.ocaml;
    camlp4 = mine.ocamlPackages_4_02.camlp4;
    #camlp4 = mine.ocamlPackages.camlp4;
    #TODO use myself  
    findlib = mine.ocamlPackages_4_02.findlib;
    ocamlbuild = mine.ocamlPackages_4_02.ocamlbuild;

    # use myself 
    #findlib = mine.ocamlPackages.findlib;

    stdenv = mine.stdenv;

    ezjsonm = mine.ocamlPackages_4_02.ezjsonm;
    re = mine.ocamlPackages_4_02.re;
    uri = mine.ocamlPackages_4_02.uri;
    which = mine.which;
    dyntype = import ../dyntype { };
    syntax = dyntype.syntax;
    omd = import ../omd { };
    ulex = import ../ulex { };

    ocaml_version = (pkgs.lib.getVersion ocaml);
    strace = 
      if stdenv.isDarwin then null else pkgs.strace;
in 
let 
    selfcamlp4 = stdenv.mkDerivation {
    name = "camlp4";
  
    src = fetchgit {
      url = https://github.com/camlp4/camlp4.git;
      rev = "ba6e0ba48bb38436cd3f6c1e6678b74f67dcf060";
      sha256 = "yyS42AErm2TtSPkAZiPes1/O34x3XORVrX5850wYUcw=";
    };
    buildInputs = [ ocaml findlib ocamlbuild camlp4 which ]; 
    configurePhase="true";
    createFindlibDestdir = true;
    };


in stdenv.mkDerivation {
    name = "ocaml_cow";
  
    src = fetchurl {
      url = https://github.com/mirage/ocaml-cow/archive/v1.2.1.tar.gz;
      sha256 = "c9ae1f0be8ca2fb37673e89c5e5f1a4cfb70d7cfa7e99322ca49592431434ba0";
     # url = https://github.com/mirage/ocaml-cow/archive/refs/tags/v2.0.1.tar.gz;
     # sha256 = "EbP4g3LyE6E6zr7E4ZFrXuEfXLhm82xHT9qZXrz5ykE=";
    };
  
   # src = fetchFromGitHub {
   #    owner = "mirage";
   #    rev = "0bab31b1b6291afed32219f0a81f1c59c9129517";
   #    repo = "ocaml-cow";
   #    sha256 = "OYM7jolwFE2D1EWBeBUNt8RooIuSwip7tiGM6zM3zuk=";
   # };
#    patches = ./patch;


#   postConfigure = ''
#     substituteInPlace camlp4/META.in \
#     --replace +camlp4 $out/lib/ocaml/${ocaml_version}/site-lib/camlp4
#   '';

#     substituteInPlace camlp4/config/Camlp4_config.ml \
#     --replace \
#       "Filename.concat ocaml_standard_library" \
#       "Filename.concat \"$out/lib/ocaml/${ocaml_version}/site-lib\""


    #camlp4=op.camlp4;

    #buildInputs = [ ocaml findlib pkgs.which strace minepkgs.ocamlPackages.ounit2 ]; 
    #buildInputs = [ ocaml findlib pkgs.which strace minepkgs.ocamlPackages.ounit ]; 
    #buildInputs = [ ocaml findlib pkgs.which strace selfcamlp4 dyntype ]; 
    #buildInputs = [ ocaml findlib pkgs.which strace selfcamlp4 dyntype ]; 
    buildInputs = [ ocaml findlib camlp4 pkgs.which strace dyntype ]; 
  
    #propagatedBuildInputs = [ dyntype omd op.janeStreet_0_9_0.ppx_type_conv  op.re ulex minepkgs.ocamlPackages.uri op.xmlm op.ezjsonm op.camlp4 cstruct ];
    #propagatedBuildInputs = [ dyntype omd op.janeStreet_0_9_0.ppx_type_conv  op.re ulex minepkgs.ocamlPackages.uri xmlm ezjsonm op.camlp4 cstruct ];
    #propagatedBuildInputs = [ dyntype dyntype.syntax omd type_conv  re ulex uri xmlm ezjsonm camlp4 cstruct ];
    #propagatedBuildInputs = [ dyntype syntax omd type_conv  re ulex uri xmlm ezjsonm camlp4 cstruct ];
    #propagatedBuildInputs = [ dyntype omd type_conv  re ulex uri xmlm ezjsonm camlp4 cstruct ];
    #propagatedBuildInputs = [ dyntype omd camlp4 type_conv  re ulex uri xmlm ezjsonm  cstruct ];
    #propagatedBuildInputs = [ dyntype omd selfcamlp4 type_conv  re ulex uri xmlm ezjsonm  cstruct ];
    #propagatedBuildInputs = [ dyntype omd selfcamlp4 type_conv  re ulex uri xmlm ezjsonm  cstruct ];
    propagatedBuildInputs = [ dyntype omd camlp4 type_conv  re ulex uri xmlm ezjsonm  cstruct ];

   buildPhase = "
export LD_LIBRARY_PATH=${cstruct}/lib/ocaml/${ocaml_version}/site-lib/cstruct
make
";

#    installPhase="true";

    createFindlibDestdir = true;

}
