fun split [] = ([], [])   
 | split [x] = ([x], [])  
 | split (x1::x2::xs) = 
           let 
             val (ys, zs) = split xs
           in 
            ((x1::ys), (x2::zs))
          end;