
module D3=
struct
	dim=3
end

module V3= Vect.Make(D3)

let v= V3.zero + V3.canon 1
