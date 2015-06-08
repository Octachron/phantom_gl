module FunOp=FunOp


let load f= 
 let cin = open_in f in
 let n= in_channel_length cin in
 let s=String.create n in
 ignore(input cin s 0 n); s   
