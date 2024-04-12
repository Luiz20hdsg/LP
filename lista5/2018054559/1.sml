
structure  MyMathLib =
struct 
    val halfPi=Math.pi/2.0;
    
    fun fact 0 =1
    | fact x= x *fact (x-1)

    fun double x= x*2
    
    fun pow(x, 0) = 1
    | pow(x, n) = x * pow(x,n-1);     
    
   

end;


MyMathLib.pow(2,2);