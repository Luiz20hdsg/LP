datatype btree = Leaf | Node of ( btree * int * btree ) ;

fun sumAll ( Leaf ) = 0
| sumAll ( Node ( tl ,x , tr ) ) =
let
    val sumtl = sumAll ( tl )
    val sumtr = sumAll ( tr )
in
    x + sumtl + sumtr
end ;