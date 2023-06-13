{ }:
let 
    pkgs = import <nixpkgs> {};
    stdenv = pkgs.stdenv;
    fetchurl = pkgs.fetchurl;
    #ocaml = pkgs.ocaml;
    #op = pkgs.ocamlPackages;
    op = pkgs.ocaml-ng.ocamlPackages_4_02;
    ocaml = op.ocaml;
    findlib = op.findlib;
    dyntype = import ../dyntype { };
    omd = import ../omd { };
    ulex = import ../ulex { };
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

    type_conv = mine.ocamlPackages.type_conv;
    cstruct = mine.ocamlPackages.ppx_cstruct;
    xmlm = mine.ocamlPackages.xmlm;

    ezjsonm = mine.ocamlPackages.ezjsonm;

    ocaml_version = (pkgs.lib.getVersion ocaml);
    strace = 
      if stdenv.isDarwin then null else pkgs.strace;
in stdenv.mkDerivation {
    name = "ocaml_cow";
  
    src = fetchurl {
      url = https://github.com/mirage/ocaml-cow/archive/v1.2.1.tar.gz;
      sha256 = "c9ae1f0be8ca2fb37673e89c5e5f1a4cfb70d7cfa7e99322ca49592431434ba0";
    };
  
#    patches = ./patch;


#   postConfigure = ''
#     substituteInPlace camlp4/META.in \
#     --replace +camlp4 $out/lib/ocaml/${ocaml_version}/site-lib/camlp4
#   '';

#     substituteInPlace camlp4/config/Camlp4_config.ml \
#     --replace \
#       "Filename.concat ocaml_standard_library" \
#       "Filename.concat \"$out/lib/ocaml/${ocaml_version}/site-lib\""


    camlp4=op.camlp4;

    #buildInputs = [ ocaml findlib pkgs.which strace minepkgs.ocamlPackages.ounit2 ]; 
    #buildInputs = [ ocaml findlib pkgs.which strace minepkgs.ocamlPackages.ounit ]; 
    buildInputs = [ ocaml findlib pkgs.which strace ]; 
  
    #propagatedBuildInputs = [ dyntype omd op.janeStreet_0_9_0.ppx_type_conv  op.re ulex minepkgs.ocamlPackages.uri op.xmlm op.ezjsonm op.camlp4 cstruct ];
    #propagatedBuildInputs = [ dyntype omd op.janeStreet_0_9_0.ppx_type_conv  op.re ulex minepkgs.ocamlPackages.uri xmlm ezjsonm op.camlp4 cstruct ];
    propagatedBuildInputs = [ dyntype omd type_conv  op.re ulex mine.ocamlPackages.uri xmlm ezjsonm op.camlp4 cstruct ];

   buildPhase = "
export LD_LIBRARY_PATH=${cstruct}/lib/ocaml/${ocaml_version}/site-lib/cstruct
make
";

#    installPhase="true";

    createFindlibDestdir = true;

}
