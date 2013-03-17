


type 'a t= {uid :int ; info: 'a}

let uid { uid; _ } = uid

type info2d = {x : int ; y :int }

let create info = {uid=Rgl.genTexture(); info}

let create2D x y= create{x; y }

let bind2D : info2d t -> unit = fun t -> Rgl.bindTexture 0 t.uid
	

