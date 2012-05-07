

let ()=
	let v=Vector.create 1. 0. 0. 
	and w=Vector.create 1. 0. 1.
	and h=Hyperplane.create (Vector.create 1. 0. 0.)  0.
	in 
	let a= Vector.(2.*v-3.*w)in
	print_float Hyperplane.(h||a);
