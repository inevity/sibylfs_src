{ }:

let
    pkgs = import <nixpkgs> {};
    stdenv = pkgs.stdenv;
    fetchurl = pkgs.fetchurl;
    #ocaml = pkgs.ocaml;
    #op = pkgs.ocamlPackages;
    op = pkgs.ocaml-ng.ocamlPackages_4_02;
    findlib=op.findlib;
    ocaml = op.ocaml;
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.1";
  pname = "ulex";

in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.cduce.org/download/${pname}-${version}.tar.gz";
    sha256 = "0fjlkwps14adfgxdrbb4yg65fhyimplvjjs1xqj5np197cig67x0";
  };

  createFindlibDestdir = true;

  buildInputs = [ocaml findlib];

  buildFlags = "all all.opt";

  meta = {
    homepage = http://www.cduce.org/download.html;
    description = "A lexer generator for Unicode and OCaml";
    license = pkgs.lib.licenses.mit;
    maintainers = [ pkgs.lib.maintainers.roconnor ];
  };
}
