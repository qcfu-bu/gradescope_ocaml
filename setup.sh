#!/usr/bin/env bash

apt install make
apt install -y ocaml

add-apt-repository ppa:avsm/ppa
apt update

apt install -y opam m4

opam init --disable-sandboxing

eval `opam config env`

opam install -y dune atdgen ounit2 qcheck
cd /autograder/source
dune build lib/ --profile release
