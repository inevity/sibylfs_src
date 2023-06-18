#SHELL:=/bin/bash
#VARS_OLD := $(.VARIABLES)


# bash will read this config file first
#BASH_ENV=bash_env.sh
#export BASH_ENV


#export CPPO_ARGS:="-D aspect_perms"
#
##LEMLIB from nix env var
#export LEMFLAGS:="-lib $LEMLIB -only_changed_output -wl_unused_vars ign -wl_rename err -wl_comp_message ign -wl_pat_exh ign"
#export PKGS:="-package sexplib,sexplib.syntax,sha"
#export SYNTAX:="-syntax camlp4o" # simplify: use for every file
## 8~"pattern-matching is not exhaustive"; 
## 11~"this match case is unused";
## 26~"unused variable s2"
#export WARN:="-w @f@p@u@s@40-8-11-26"
## these include syntax, so should work on all files; may be overridden in ocamlc.sh
#export   ocamlc:="$DISABLE_BYTE ocamlfind ocamlc   $WARN -I $EXTRACTDIR extract.cma  $PKGS $SYNTAX"
#export ocamlopt:="$DISABLE_NTVE ocamlfind ocamlopt $WARN -I $EXTRACTDIR extract.cmxa $PKGS $SYNTAX"
#export ocamldep:="ocamlfind ocamldep $PKGS"
#export mk_cma:="$DISABLE_BYTE ocamlfind ocamlc"
#export mk_cmxa:="$DISABLE_NTVE ocamlfind ocamlopt"

# expect files to be linked in from ../Makefile
all: stage1 
	$(MAKE) fs_spec_lib.cma fs_spec_lib.cmxa # so deps are there

FORCE:

	#(for f in *.lem_cppo; do $$cppo $$CPPO_ARGS $$f -o $${f/.lem_cppo/.lem}; done)
	#echo $$cppo 
	#echo "1111" 
	#(for f in *.lem_cppo; do $$cppo $$CPPO_ARGS $$f -o $${f/.lem_cppo/.lem}; done)
	#(for f in *.lem_cppo; do ${cppo} ${CPPO_ARGS} $#f -o $${f/.lem_cppo/.lem}; done)
#run_cppo: $(wildcard *.lem_cppo) 
#run_cppo:  
#(for f in *.lem_cppo; do ${cppo} ${CPPO_ARGS} $f -o ${f/.lem_cppo/.lem}; done)
#run_cppo: $(wildcard *.lem_cppo) 
#nix cannot access this var, env in the nix-store? no use the bash now ...
#run_cppo: 
#	${cppo}
#	${cppo} t_dir_heap.lem_cppo -o t_dir_heap.lem   
#	${cppo} t_fs_spec_fs_command_properties.lem_cppo -o t_fs_spec_fs_command_properties.lem
#	${cppo} t_fs_spec.lem_cppo -o t_fs_spec.lem
#	${cppo} t_fs_spec_properties_perms.lem_cppo -o t_fs_spec_properties_perms.lem

# we have to invoke lem with the files in the right order
	#echo "1111"
	#echo $cppo;
	# Put this at the point where you want to see the variable values
#  $(foreach v,                                        \
#        $(filter-out $(VARS_OLD) VARS_OLD,$(.VARIABLES)), \
#        $(info $(v) = $($(v))))
	#(for f in *.lem_cppo; do cppo $$CPPO_ARGS $$f -o $${f/.lem_cppo/.lem}; done)
	#(for f in *.lem_cppo; do /nix/store/gdndpj78qb82lmcnwyhiy3i3ss0bas8q-cppon/bin/cppo $$CPPO_ARGS $$f -o $${f/.lem_cppo/.lem}; done)

run_cppo: $(wildcard *.lem_cppo) 
	(for f in *.lem_cppo; do $$cppo $$CPPO_ARGS $$f -o $${f/.lem_cppo/.lem}; done)
	touch $@

dot_lem:=\
t_list_array.lem \
t_fs_prelude.lem \
  t_fs_spec_properties.lem \
t_fs_spec.lem \
  t_fs_spec_fs_command_properties.lem \
  t_fs_spec_properties_perms.lem \
t_dir_heap.lem

run_lem: run_cppo $(wildcard *.lem)
	$$lem -lib $$LEMLIB $$LEMFLAGS -ocaml $(dot_lem)
	sed -i.bak -f patch_lem.sed t_fs_spec.ml
	touch $@

# now we are sure lem accepts the files, copy them to plain ml
run_cp: run_lem 
	for f in t_*.ml; do cp $$f $${f/t_/}; sed -i.bak -f patch_gen_ml.sed $${f/t_/}; done
	touch $@

# now we have various stages of ocaml compilation

stage1: run_cp
	touch $@

include .depend
%.x: %.mli %.ml stage1
	$$ocamlc -c $*.mli $*.ml
	$$ocamlopt -c $*.mli $*.ml
	touch $@

%.x: %.ml stage1
	$$ocamlc -c $*.ml
	$$ocamlopt -c $*.ml
	touch $@

fs_spec_lib.cma: $(xs)
	$$mk_cma -g -a -o $@ $(xs:.x=.cmo)

fs_spec_lib.cmxa: $(xs)
	$$mk_cmxa -g -a -o $@ $(xs:.x=.cmx)

clean_ocaml: FORCE
	rm -f *.cmi *.cmo *.cmx *.o *.x *.cma *.cmxa *.a a.out

clean: FORCE
	if [ `basename $(CURDIR)` = "src" ]; then false; fi # fail if in src!
	-rm -rf $$(comm -13 <(cd ../src && ls -1 | sort) <(ls -1 |sort) ) # comm may not exist on all systems

.SUFFIXES:
