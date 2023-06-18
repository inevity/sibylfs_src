{ }:
let 
    pkgs = import <nixpkgs> {};
    fetchurl = pkgs.fetchurl;
    op = pkgs.ocaml-ng.ocamlPackages_4_02;
    #findlib = op.findlib;
    mine = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "mine1402";                                                 
         url = "https://github.com/NixOS/nixpkgs/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
    }) {};                                                                           

    type_conv = mine.ocamlPackages_4_02.type_conv;
    #cstruct = mine.ocamlPackages.ppx_cstruct;
    cstruct = mine.ocamlPackages_4_02.cstruct;
    xmlm = mine.ocamlPackages_4_02.xmlm;
    ocaml = mine.ocamlPackages_4_02.ocaml;
    stdenv = mine.stdenv;

    ezjsonm = mine.ocamlPackages_4_02.ezjsonm;
    uri = mine.ocamlPackages_4_02.uri;
    camlp4 = mine.ocamlPackages_4_02.camlp4;
    #base-bytes = mine.ocamlPackages.base-bytes; 
    #conf-pkg-config = mine.ocamlPackages.conf-pkg-config;
    re = mine.ocamlPackages_4_02.re;
    pkgconfig = mine.pkgconfig;
    ncurses = mine.ncurses;
    libffi = mine.libffi;
    ocaml_version = (pkgs.lib.getVersion ocaml);
    findlib = mine.ocamlPackages_4_02.findlib;
    #integers = mine.ocamlPackages_4_02.integers;
    integers = import ../integers { } ;

    strace = 
      if stdenv.isDarwin then null else pkgs.strace;
in stdenv.mkDerivation {
    name = "ocaml_ctypes";
  
    src = fetchurl {
      #url = https://github.com/mirage/ocaml-cow/archive/v1.2.1.tar.gz;
      #sha256 = "c9ae1f0be8ca2fb37673e89c5e5f1a4cfb70d7cfa7e99322ca49592431434ba0";
      #url = https://github.com/yallop/ocaml-ctypes/archive/refs/tags/0.9.4.tar.gz;
      #sha256 = "4UwsOiPsfiHyB5ZSwjwwnNfPuVguvCl1AHopyIzm+A0=";
      #url = https://github.com/yallop/ocaml-ctypes/archive/refs/tags/0.9.3.tar.gz;
      #sha256 = "rd0vSjF/x8gYm0fL1gXphKGRwmLNr+dJO5vgBwm9YEU=";
      url = https://github.com/yallop/ocaml-ctypes/archive/refs/tags/0.8.2.tar.gz;
      sha256 = "62uh2+xgbDhy7p/5WC5ORXpSMC3hkloVS4TgLtssk/A=";
    };
  
    #buildInputs = [ ocaml findlib pkgs.which strace base-bytes conf-pkg-config  ]; 
  
    #propagatedBuildInputs = [ dyntype omd type_conv  re ulex uri xmlm ezjsonm camlp4 cstruct ];

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ ocaml findlib ncurses ];
    #buildInputs = [ ocaml findlib];
    propagatedBuildInputs = [ integers libffi ];
    #propagatedBuildInputs = [ integers ];
  
    hasSharedObjects = true;
  
       #make XEN=false libffi.config ctypes-base ctypes-stubs
    buildPhase =  ''
       make XEN=false libffi.config ctypes-base ctypes-stubs
       make XEN=false ctypes-foreign
    '';
  
    installPhase =  ''
      make install XEN=false
    '';


    createFindlibDestdir = true;

}

#{ stdenv, buildOcaml, fetchzip, libffi, pkgconfig, ncurses, integers }:
#
#buildOcaml rec {
#  name = "ctypes";
#  version = "0.13.1";
#
#  minimumSupportedOcamlVersion = "4";
#
#  src = fetchzip {
#    url = "https://github.com/ocamllabs/ocaml-ctypes/archive/67e711ec891e087fbe1e0b4665aa525af4eaa409.tar.gz";
#    sha256 = "1z84s5znr3lj84rzv6m37xxj9h7fwx4qiiykx3djf52qgk1rb2xb";
#  };
#
#  nativeBuildInputs = [ pkgconfig ];
#  buildInputs = [ ncurses ];
#  propagatedBuildInputs = [ integers libffi ];
#
#  hasSharedObjects = true;
#
#  buildPhase =  ''
#     make XEN=false libffi.config ctypes-base ctypes-stubs
#     make XEN=false ctypes-foreign
#  '';
#
#  installPhase =  ''
#    make install XEN=false
#  '';
#
#  meta = with stdenv.lib; {
#    homepage = https://github.com/ocamllabs/ocaml-ctypes;
#    description = "Library for binding to C libraries using pure OCaml";
#    license = licenses.mit;
#    maintainers = [ maintainers.ericbmerritt ];
#  };
#}
