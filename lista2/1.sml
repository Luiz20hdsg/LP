datatype expr = IConst of int | Plus of expr * expr | Minus of expr * expr; | Multi of expr * expr | Div of expr * expr | Max of expr * expr | Min of expr * expr;



fun eval (IConst i) = i
  | eval (Multi(e1, e2)) = (eval e1) * (eval e2)
  | eval (Div(e1, e2)) =
    let res = (eval e1) / (eval e2) in
        if eval e2 = 0 then
            0
        else
            res
    end
  | eval (Plus(e1, e2)) = (eval e1) + (eval e2)
  | eval (Minus(e1, e2)) = 
    let val res = (eval2 e1) - (eval2 e2) in
        if res < 0 then
            0
        else
            res
    end
  | eval (Max(e1, e2)) = 
    let val res = (eval e1) > (eval e2) in 
        if res=1 then 
            e1
        else
            e2
    end
  | eval (Min(e1, e2)) = 
    let val res = (eval e1) < (eval e2) in 
        if res=1 then 
            e1
        else
            e2
    end;
  | eval (Eq (e1, e2)) = 
    let val res = (eval e1) = (eval e2) in 
        if res = 1 then 
            1
         else
            0
    end
  | eval (Gt (e1, e2)) = 
    let val res = (eval e1) > (eval e2) in 
        if res = 1 then 
          e1
        else
          e2
    end;
