#!/bin/bash 

# Edit this file to ensure the paths are set appropriately

# for debugging
set -x

# path to the lem executable; must be an absolute path
lem=/nix/store/3syv88pzb3vchsfqzgi6bpqmczad18sx-lem/lem/lem

# path to lem's library (lots of .lem files); must be an absolute path
LEMLIB=/nix/store/3syv88pzb3vchsfqzgi6bpqmczad18sx-lem/lem/library

# path to lem's ocaml library; must be an absolute path; we expect to
# find EXTRACTDIR, with extract.cm[x]a
EXTRACTDIR=/nix/store/3syv88pzb3vchsfqzgi6bpqmczad18sx-lem/lem/ocaml-lib/_build

# if on your path, this does not have to be an absolute path; it is
# the command to run the ocaml preprocessor
#cppo=/nix/store/lbfqdl6bxaqm6mzhwcqv9szn09lzzycj-cppo-1.3.2/bin/cppo
cppo=/nix/store/gdndpj78qb82lmcnwyhiy3i3ss0bas8q-cppon/bin/cppo


# may or may not be needed; needed when using nix dependencies, but
# building manually
#LD_LIBRARY_PATH=/nix/store/gjc187wilf18d45c87s59xiqxb5vwisf-ocaml-cstruct-1.6.0/lib/ocaml/4.01.0/site-lib/cstruct

DISABLE_BYTE=true

# needed?
#export lem LEMLIB EXTRACTDIR cppo LD_LIBRARY_PATH DISABLE_BYTE
export lem LEMLIB EXTRACTDIR cppo  DISABLE_BYTE
