PHONY: deps format build clean

.DEFAULT_GOAL := build

deps:
	opam pin add -n note.dev git+https://github.com/dbuenzli/note.git; \
	opam pin add -n brr.dev git+https://github.com/dbuenzli/brr.git; \
	opam pin add -n gen_js_api.dev git+https://github.com/LexiFi/gen_js_api.git; \
	opam pin add -n ocaml-vdom.dev git+https://github.com/LexiFi/ocaml-vdom.git; \
	opam install js_of_ocaml js_of_ocaml-ppx brr note js_of_ocaml-lwt ocamlformat gen_js_api ocaml-vdom js_of_ocaml-tyxml routes bonsai

format:
	dune build @fmt --auto-promote

build:
	dune build --profile=release

clean:
	dune clean
