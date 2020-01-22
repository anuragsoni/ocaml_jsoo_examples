PHONY: deps

deps:
	opam pin add -n note.dev git+https://github.com/dbuenzli/note.git
	opam pin add -n brr.dev git+https://github.com/dbuenzli/brr.git
	opam install js_of_ocaml js_of_ocaml-ppx brr note js_of_ocaml-lwt
