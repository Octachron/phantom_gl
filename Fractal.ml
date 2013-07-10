
module D3=
struct
	let dim=3
end

module V3= Vect.With(D3)

open V3

let v=  canon 1 +: (2.*:id |: zero)
