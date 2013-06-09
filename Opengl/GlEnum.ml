
type 'a t = int

let raw x = x

let byte : [`DataType] t= 0x1400

let array : [`BufferType] t = 0x8892
let element : [`BufferType] t = 0x8893


let stream_draw : [`BufferUseType] t = 0x88E0
let stream_read : [`BufferUseType] t = 0x88E1
let stream_copy : [`BufferUseType] t = 0x88E2

let static_draw : [`BufferUseType] t = 0x88E4
let static_read : [`BufferUseType] t = 0x88E5
let static_copy : [`BufferUseType] t = 0x88E6

let dynamic_draw : [`BufferUseType] t = 0x88E8
let dynamic_read : [`BufferUseType] t = 0x88E9
let dynamic_copy : [`BufferUseType] t = 0x88EA


let depth :  [` BufferBit | `Fusion] t = 0x00000100
let stencil :  [` BufferBit | `Fusion] t = 0x00000400
let color :  [` BufferBit | `Fusion] t = 0x00004000

let _true : [`Bool] t =0
let _false : [`Bool] t =0

let points : [`Primitives] t= 0x0000
let lines : [`Primitives] t= 0x0001
let lines_loop : [`Primitives] t= 0x0002
let lines_strip : [`Primitives] t= 0x0003
let triangles : [`Primitives] t= 0x0004
let triangles_loop : [`Primitives] t= 0x0005
let triangles_strip : [`Primitives] t= 0x0006
let quads : [`Primitives] t= 0x0007

let read : [`Access] t = 0x88B8
let write  : [`Access] t = 0x88B9
let rw   : [`Access] t = 0x88BA



let ( ++ ) : [> `Fusion] t -> [> `Fusion] t ->  [> `Fusion] t  = (lor)
