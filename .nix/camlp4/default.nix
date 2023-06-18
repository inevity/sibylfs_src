#{ stdenv, fetchzip, which, ocaml, ocamlbuild }:

#let 
#param = {
#  "4.02" = {
#     version = "4.02+6";
#     sha256 = "06yl4q0qazl7g25b0axd1gdkfd4qpqzs1gr5fkvmkrcbz113h1hj"; };
#  "4.03" = {
#     version = "4.03+1";
#     sha256 = "1f2ndch6f1m4fgnxsjb94qbpwjnjgdlya6pard44y6n0dqxi1wsq"; };
#  "4.04" = {
#     version = "4.04+1";
#     sha256 = "1ad7rygqjxrc1im95gw9lp8q83nhdaf383f2808f1p63yl42xm7k"; };
#  "4.05" = {
#     version = "4.05+1";
#     sha256 = "0wm795hpwvwpib9c9z6p8kw2fh7p7b2hml6g15z8zry3y7w738sv"; };
#  "4.06" = {
#     version = "4.06+1";
#     sha256 = "0fazfw2l7wdmbwnqc22xby5n4ri1wz27lw9pfzhsbcdrighykysf"; };
#  }."${ocaml.meta.branch}";

{ }:
let 
    pkgs = import <nixpkgs> {};
    fetchurl = pkgs.fetchurl;
    fetchgithub = pkgs.fetchFromGitHub;
    fetchzip = pkgs.fetchzip;
    which = pkgs.which;

    minepkgs = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify                
         name = "mine1402";                                                 
         url = "https://github.com/NixOS/nixpkgs/";                       
         ref = "refs/heads/nixpkgs-unstable";                     
         rev = "a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";                                           
     }) {};                                                                           
     ocaml = minepkgs.ocamlPackages_4_02.ocaml;
     stdenv = minepkgs.stdenv;
     ocamlbuild = minepkgs.ocamlPackages_4_02.ocamlbuild;
in

stdenv.mkDerivation rec {
  version = "4.02+6";
  name = "camlp4-${version}";
  #inherit (param) version;

  src = fetchzip {
    url = "https://github.com/ocaml/camlp4/archive/${version}.tar.gz";
   # inherit (param) sha256;
    sha256 = "06yl4q0qazl7g25b0axd1gdkfd4qpqzs1gr5fkvmkrcbz113h1hj";
  };

  buildInputs = [ which ocaml ocamlbuild ];

  dontAddPrefix = true;

  preConfigure = ''
    configureFlagsArray=(
      --bindir=$out/bin
      --libdir=$out/lib/ocaml/${ocaml.version}/site-lib
      --pkgdir=$out/lib/ocaml/${ocaml.version}/site-lib
    )
  '';

  postConfigure = ''
    substituteInPlace camlp4/META.in \
    --replace +camlp4 $out/lib/ocaml/${ocaml.version}/site-lib/camlp4
  '';

  makeFlags = "all";

  installTargets = "install install-META";

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "A software system for writing extensible parsers for programming languages";
    homepage = https://github.com/ocaml/camlp4;
    platforms = ocaml.meta.platforms or [];
  };
}
