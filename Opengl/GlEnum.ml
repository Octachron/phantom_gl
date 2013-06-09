
type 'a t = int

let raw x = x

let byte= 0x1400

let array  = 0x8892
let element = 0x8893


let stream_draw  = 0x88E0
let stream_read  = 0x88E1
let stream_copy = 0x88E2

let static_draw = 0x88E4
let static_read  = 0x88E5
let static_copy = 0x88E6

let dynamic_draw  = 0x88E8
let dynamic_read  = 0x88E9
let dynamic_copy  = 0x88EA


let depth = 0x00000100
let stencil  = 0x00000400
let color = 0x00004000

let _true  =0
let _false  =1

let points = 0x0000
let lines = 0x0001
let lines_loop = 0x0002
let lines_strip = 0x0003
let triangles = 0x0004
let triangles_loop = 0x0005
let triangles_strip = 0x0006
let quads = 0x0007

let read  = 0x88B8
let write   = 0x88B9
let rw    = 0x88BA



let ( ++ )  = (lor)
