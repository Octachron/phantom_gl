

type t=Vector.t list

let cube s= 
let open Vector in 
let z= create 0. 0. 0. in
[z; {z with x=s}; {z with y=s; x=s}; {z with y=s} ]

let create l=l

type segment={l:Vector.t;r:Vector.t}

let segments= function
| [] -> []
| r::q -> let l,segs=List.fold_left (fun (l,segs) r -> (r,{l;r}::segs) ) (r,[]) q in
{l;r}::segs


let toList  = List.map (fun {r=x; _ } -> x) 

let print s=
 let rec mid= function
  | [] -> Printf.printf "]"
  | [a] -> Vector.print a; mid []
  | a::b::q-> Vector.print a; Printf.printf"->"; mid (b::q) 
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
	Vector.print l; print_string" -><- "; Vector.print r; print_newline() ;
        Hyperplane.print h; print_newline();
	let p,n= VectOp.(h||l, h||r) in
	let t= n/.(n-.p) in
	Printf.printf "Time : %f \n \n " t;
	VectOp.(t*l  + (1.-.t) * r) 

let revcat l1 l2= List.fold_left ( fun l x-> x::l) l2 l1 

let debug p n l= Printf.printf "%s : \n" n; p l; Printf.printf "\n"

let print_l= List.iter Vector.print

type edge = Nil | All | Seg of segment 

let dbg p s x =Printf.printf "%s : " s; p x; print_newline()
let dbgl= dbg (List.iter (fun x -> Vector.print x; print_string " "))
let dbgv= dbg (Vector.print)

let dbgc (f,l,e) =
 Printf.printf "Liste partielle : \n";
 dbgv "first" f; dbgl "mid" (List.rev l); dbgv "last" e; print_newline()

let intersection h p=
	dbgl "poly" p;
	let test a= VectOp.(h||a)>0. in
	let update state (f,l,e) a=if state=true then (f,a::l,a) else (f,l,a) in
	let commit (f,l,e) ll = (f, List.rev l, e)::ll in
	let rec contract state ll current=function 
		| a::q -> let t=test a in 
                          if t=state then 
                           contract state ll (update state current a) q
                          else (
                           dbgc current; contract t (commit current ll) (a,(if t then [a] else []),a) q )
		| [] -> commit current ll in
	let ( => ) d e=segint h d e in
	let fusion fp lp fn ln mid=let l,r = ln => fp, lp => fn  in
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
	| [ _, mid1 , lp; fn, [], ln; fp, mid2, _ ] -> let l,r= lp => fn, ln => fp in
	                                                   Seg {l;r},mid1@(l::r::mid2)
	| _ -> Nil, []

(*
let intersection h p=
Printf.printf "Intersection plane\n"; print_newline();
dbg Hyperplane.print "plan" h; dbgl "origin" p;
let test a =VectOp.(h||a)>0. in 
let rec normalize neg l= match l with
| a::q -> if test a then neg,l else normalize (a::neg) q
| [] -> (neg, [] ) in
let rec sep res p l = match l with
| a::q -> if test a then sep (p::res) a q else (p::res,p,l)
| [] -> (p::res,p,[])  in
let lastp neg1 neg2= match neg1 with
| a::q -> a
| [] -> List.fold_left (fun acc x -> x) (List.hd neg2) neg2 
in
let neg1, norm = normalize [] p in
dbgl "neg1" neg1; dbgl "norm" norm;
match norm with
| [] -> (Nil,[])
| _ -> let fpos=List.hd norm  
       and pos, lpos, neg2 = sep [] (List.hd norm) (List.tl norm) in
	dbgl "pos" pos; dbgl "neg2";
       match neg1, neg2 with 
         | [],[] -> All,List.rev(lpos::pos)
         | _,_ -> let lneg= lastp neg1 neg2
                  and fneg= lastp neg2 neg1 in
			dbgv "fpos" fpos; dbgv "lpos" lpos; dbgv "fneg" fneg; dbgv "lneg" lneg;
                  let l = segint h lneg fpos
                  and r=segint h lpos fneg in		
                Seg {l;r}, l::List.rev(r::pos) 
*)
let reconnect segs=
	List.iter (fun {l;r} -> Vector.print l; print_string "->"; Vector.print r; Printf.printf "\n") segs;
	print_newline();
	let test a b= Vector.(norm2 (a-b))< 1e-6 in 
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
   


