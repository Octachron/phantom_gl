

type t=Vec3.t list

let cube s= 
let open Vec3 in 
let z= zero in
[z; {z with x=s}; {z with y=s; x=s}; {z with y=s} ]

let create l=l

type segment={l:Vec3.t;r:Vec3.t}

let segments= function
| [] -> []
| r::q -> let l,segs=List.fold_left (fun (l,segs) r -> (r,{l;r}::segs) ) (r,[]) q in
{l;r}::segs


let toList  = List.map (fun {r=x; _ } -> x) 

let print s=
 let rec mid= function
  | [] -> Printf.printf "]"
  | [a] -> Vec3.print a; mid []
  | a::b::q-> Vec3.print a; Printf.printf"->"; mid (b::q) 
 in
Printf.printf "["; mid s

let triangles: t -> t list=
let rec separation  t ls  = function
| a::b::c::q -> separation ([a;b;c]::t) (c::a::ls)  q
| [a;b] -> test t (b::a::ls)
| [a] -> test t (a::ls)
| [] -> test t ls
and test t=function
| a::b::c::q as l-> separation t [] l
| l -> t in
separation [] [] 

let map=List.map


let segint h l r= 
	let p,n= Vec3.(h||l, h||r) in
	let t= n/.(n-.p) in
	Vec3.(t*l  + (1.-.t) * r) 

let revcat l1 l2= List.fold_left ( fun l x-> x::l) l2 l1 


type edge = Nil | All | Seg of segment 

let intersection h p=
	let test a= Vec3.(h||a)>0. in
	let update state (f,l,e) a=if state=true then (f,a::l,a) else (f,l,a) in
	let commit (f,l,e) ll = (f, List.rev l, e)::ll in
	let rec contract state ll current=function 
		| a::q -> let t=test a in 
                          if t=state then 
                           contract state ll (update state current a) q
                          else (
                            contract t (commit current ll) (a,(if t then [a] else []),a) q )
		| [] -> commit current ll in
	let ( <=> ) d e=segint h d e in
	let fusion fp lp fn ln mid=let l,r = ln <=> fp, lp <=> fn  in
                                   Seg {l;r},l::(mid@[r])
        in
	match p with
		|[] -> Nil, []
		| a:: q -> let t= test a in 
                           let ll= contract t [] (a,(if t then [a] else []),a) q in
	match List.rev ll with
	| [ (_,[],_) ] -> Nil, []
	| [a] -> All, p 
	| [fn,[],ln; fp, mid, lp] -> fusion fp lp fn ln mid
 	| [fp,mid,lp; fn, [] , ln] -> fusion fp lp fn ln mid
        | [_, [] , ln; fp, mid, lp; fn, [], _ ] -> fusion fp lp fn ln mid
	| [ _, mid1 , lp; fn, [], ln; fp, mid2, _ ] -> let l,r= lp <=> fn, ln <=> fp in
	                                                   Seg {l;r},mid1@(l::r::mid2)
	| _ -> Nil, []

let reconnect segs=
	let test a b= Vec3.(norm2 (a-b))< 1e-6 in 
	let rec reconn resv pts last= function
		| ({l;r} as s)::q ->if test last l then
				 reconn resv (r::pts) r q 
			   else if test last r then
				reconn resv (l::pts) l q
			    else 
				reconn (s::resv) pts last q
		| [] -> (match resv with 
			  | [] -> pts
			  | _-> reconn [] pts last resv ) in
       match segs with 
	| {l;r}::q -> reconn [] [l;r] r segs
	| [] -> [] 					
   


