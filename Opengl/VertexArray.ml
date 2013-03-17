

type 'a loc = int

let uid x  =x 

let getLoc p  = Rgl.getAttribLocation (Program.uid p)

let enable loc = Rgl.enableVertexAttribArray loc
let disable loc = Rgl.disableVertexAttribArray loc
