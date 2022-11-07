(lang dune 3.3)
(name gradescope_ocaml)
(generate_opam_files true)
(source
 (github qcfu-bu/gradescope_ocaml))
(authors "Qiancheng Fu")
(maintainers "Qiancheng Fu")

(package
 (name gradescope_ocaml)
 (synopsis "Gradescope Bindings for OCaml")
 (description "Gradescope Bindings for OCaml")
 (depends ocaml dune atdgen ounit2 qcheck))
