
fun count_main (x: int) =
    let
        fun count (from: int) =
            if from = x
            then from :: []
            else from :: count (from + 1)
    in
        count 1
    end;
