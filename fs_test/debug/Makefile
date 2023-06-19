## build fs_spec/build and fs_test/lib first
#SHELL:=/bin/bash
#
## bash will read this config file first
#BASH_ENV=bash_env.sh
#export BASH_ENV

NATIVES:=check2.native debug.native

all: before_all $(NATIVES) 

before_all: ../lib/fs_check_lib.cmxa

# FIXME do we want to do this in .. ? then we can include all the libs
check2.native: checklib_2.x check2.x
	$$mk_native -linkpkg -o $@ checklib_2.cmx check2.cmx

debug.native: checklib_2.x debug.x
	$$mk_native -linkpkg -o $@ checklib_2.cmx debug.cmx

include .depend

%.x: %.mli %.ml 
	$$debug_ocamlc -c $*.mli $*.ml
	$$debug_ocamlopt -c $*.mli $*.ml
	touch $@

#$debug_ocamlc -c checklib_2.mli checklib_2.ml
#findlib: [WARNING] Package camlp4 has multiple definitions in /nix/store/qgnfzp1hqgnj9h5344mk3d0s51ydpmb3-camlp4-4.02+6/lib/ocaml/4.02.3/site-lib/camlp4/META, /nix/store/rh90z90dz6i5f5f9cv4piraarx246vaf-camlp4-4.02+6/lib/ocaml/4.02.3/site-lib/camlp4/META
#File "checklib_2.mli", line 31, characters 12-22:
#Error: Unbound module Trace
#make[2]: *** [Makefile:24: checklib_2.x] Error 2
#make[2]: Leaving directory '/build/fs_test/debug'
#make[1]: *** [Makefile:36: debug/check2.native] Error 2
#make[1]: Leaving directory '/build/fs_test'
#make: *** [Makefile:14: all] Error 2
%.x: %.ml 
	$$debug_ocamlc -c $*.ml
	$$debug_ocamlopt -c $*.ml
	touch $@


clean: 
	rm -f *.cmi *.cmx *.cmo *.o
	rm -f *.x
	rm -f *.native 
