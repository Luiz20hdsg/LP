datatype peri = RConst of peri | PQuadrado of peri | PCircul of peri | PRetangulo of peri*peri; | PTriangulo of peri;

fun eval (RConst i) = i
  | eval (PQuadrado(e1)) = (eval e1) * RConst 4.0
  | eval (PCircul(e1))= (eval e1)* RConst 2.0 * RConst 3.14
  | eval (PRetangulo(e1,e2))= (eval e1)* RConst 2.0 + (eval e2) * RConst 2.0
  | eval (PTriangulo(e1,e2))= (eval e1)+(eval e1)+(eval e1);