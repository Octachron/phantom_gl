#! /opt/godi/bin/ocaml unix.cma


let cc="ocamlbuild"

let pkg="sdl,lablGL"
let target="Wyrd.native"



let command= Printf.sprintf " %s -use-ocamlfind -package %s %s" cc pkg target  



let catch p=match p with 
|Unix.WEXITED _ -> Printf.printf "Exited normally\n"
| _ -> Printf.printf "Interrupted\n"




let ()=Printf.printf "Building with:\n %s\n" command;

let p=Unix.system command in
catch  p;
