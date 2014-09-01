ReactCircles.jsoo
=================

A OCaml React and js_of_ocaml example.

Demo at : http://www.shabteam.com/reactdraw

Compilation:
```
ocamlbuild -use-ocamlfind -syntax camlp4o -package react,js_of_ocaml,js_of_ocaml.syntax reactcircles.byte reactcircles.ml
js_of_ocaml +weak.js reactcircles.byte
```

Dependencies:
- OCaml (tested with 4.01.0)
- react (1.1.0)
- js_of_ocaml (2.2)