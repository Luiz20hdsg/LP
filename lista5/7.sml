structure  MyMathLib =
struct 
    val halfPi=Math.pi/2.0;

    fun fact 0 =1
    | fact x= x *fact (x-1)

    fun double x= x*2
    
    fun pow(x, 0) = 1
    | pow(x, n) = x * pow(x,n-1);     
    
  
end;

fun useMyMathLib(x,b) =
    
    if x<0 then  raise Fail "Não posso lidar com numeros negativo"

    else
        if b= "pow" then MyMathLib.pow(x,x)
        else
            if b= "double" then MyMathLib.double(x)
            else
                if b= "fact" then MyMathLib.fact(x)
     
                else 0;
                    





useMyMathLib(5,"fact");