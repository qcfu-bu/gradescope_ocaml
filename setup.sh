#!/usr/bin/env bash

add-apt-repository ppa:avsm/ppa
apt update

apt install make
apt install -y opam m4

opam init --disable-sandboxing
opam switch create 4.14.0

eval $(opam env --switch=4.14.0)

opam install -y dune atdgen ounit2 qcheck
cd /autograder/source
dune build lib/ --profile release
