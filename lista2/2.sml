datatype area = RConst of real | AQuadrado of area | ACircul of area | ARetangulo of area*area;


fun eval (RConst i) = i
  | eval (AQuadrado(e1)) = (eval e1) * (eval e1)
  | eval (ACircul(e1))= (eval e1)*(eval e1)*RConst 3.14
  | eval (ARetangulo(e1,e2))= (eval e1)*(eval e2);