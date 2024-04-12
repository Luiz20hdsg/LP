(* PlcChecker *)

exception EmptySeq
exception UnknownType
exception NotEqTypes
exception WrongRetType
exception DiffBrTypes
exception IfCondNotBool
exception NoMatchResults
exception MatchResTypeDiff
exception MatchCondTypesDiff
exception CallTypeMisM
exception NotFunc
exception ListOutOfRange
exception OpNonList

(* Função auxiliar para tratar igualdades e diferenças*)
fun igualdade IntT = true   
    |   igualdade BoolT = true
    |   igualdade (ListT []) = true
    |   igualdade (ListT (h::[])) = igualdade h
    |   igualdade (ListT (h::t)) = if igualdade h then igualdade(ListT t) else false
    |   igualdade (SeqT (t)) = igualdade t
    |   igualdade _ = false;


fun teval(e: expr) (env: plcType env) : plcType =
    case  e of
        ConI _ => IntT 
        | ConB _ => BoolT
        | ESeq (SeqT t) => SeqT t
        | ESeq _ => raise EmptySeq
        | Var s => lookup env s
        | Let (s, e1, e2) => if((teval e1 env) = (teval e2 env)) then teval e2 env else raise WrongRetType
        | Letrec (s1, pt1, s2, pt2, e1, e2) =>
            let
                val fnenv = (s2, pt1)::env
            in
                if ((teval e1 fnenv) = pt2) then teval e1 fnenv else raise WrongRetType
            end
        | Prim1 (s, e) =>
            let
                val e2 = teval e env
            in
                case s of
                    "!" => if (e2 = BoolT) then e2 else raise UnknownType
                    | "-" => if (e2 = IntT) then e2 else raise UnknownType
                    | "hd" => let in
                        case e2 of
                            ListT(types) => e2
                            | _ => raise UnknownType
                        end
                    | "tl" => let in
                        case e2 of
                            ListT(types) => e2
                            | _ => raise UnknownType
                        end
                    | "ise" => let in
                        case e2 of
                            SeqT t => BoolT
                            | _ => raise UnknownType
                        end
                    | "print" => e2
                    | _ => raise UnknownType
            end
        | Prim2 (s, e1, e2) =>
            let
                val ee1 = teval e1 env
                val ee2 = teval e2 env
            in
                case s of
                    "&&" => if ((ee1 = BoolT) andalso (ee2 = BoolT)) then BoolT else raise NotEqTypes
                    | "::" => 
                        let 
                            fun excecao (SeqT tipo) = tipo
                            | excecao _ = raise UnknownType 
                        in
                            if(ee2 = (SeqT e2)) andalso ee1 = excecao ee2 then ee2 else raise UnknownType
                        end
                    | "+" => if ee1 = IntT andalso ee2 = IntT then IntT else UnknownType
                    | "-" => if ee1 = IntT andalso ee2 = IntT then IntT else UnknownType
                    | "*" => if ee1 = IntT andalso ee2 = IntT then IntT else UnknownType
                    | "/" => if ee1 = IntT andalso ee2 = IntT then IntT else UnknownType
                    | "<" => if ee1 = IntT andalso ee2 = IntT then IntT else UnknownType
                    | "<=" => if ee1 = IntT andalso ee2 = IntT then IntT else UnknownType
                    | "=" => if not (igualdade ee1) orelse not (igualdade ee2) then raise UnknownType else if ee1 = ee2 then BoolT else raise NotEqTypes
                    | "!=" => if not (igualdade ee1) orelse not (igualdade ee2) then raise UnknownType else if ee1 = ee2 then BoolT else raise NotEqTypes
                    | ";" => ee2
                    | _ => raise UnknownType 
            end
        | If (e1, e2, e3) =>
            let
                val t1 = teval e1 env
                val t2 = teval e2 env
                val t3 = teval e3 env
            in
                if (t1 = BoolT)
                then if t2 = t3
                    then t2
                    else raise DiffBrTypes
                else raise IfCondNotBool
            end
        | Match (e, l) =>
            if null l then raise NoMatchResults else
            let
                val e1 = teval e env
                val lhd = (#2 (hd l))
                val l1 = teval lhd env
                fun findMatch (Match(e, l)) (env: plcType env) =
                    let in
                        case l of
                            x::[] => let in
                                case x of
                                    (SOME e2, e3) =>
                                        if (teval e3 env) = l1 then
                                            if (e1 = (teval e2 env)) 
                                            then teval thirdExp env
                                            else raise MatchCondTypesDiff
                                        else raise MatchCondTypesDiff
                                    | (NONE, e3) => if (teval e3 env) = l1 then l1 else raise MatchResTypeDiff
                            end
                        | x::xs => let in
                            case x of
                                (SOME e2, e3) =>
                                    if (teval e2, e3) = l1 then
                                        if (e1 = (teval e2 env)) then
                                            findMatch (Match (e1, xs)) env
                                        else raise MatchCondTypesDiff
                                    else raise MatchResTypeDiff
                                | _ => raise UnknownType
                            end
                    end
                    | findMatch _ _ = raise UnknownType
            in
                findMatch (Match(e, l)) env
            end
        | Call (e1, e2) => 
            let 
                val ee1 = teval e1 env
                val ee2 = teval e2 env
            in
                case e2 of FunT(argType, resultType) => 
                    if ee1 = argType then resultType else raise CallTypeMisM
                | _ => raise NotFunc
            end
        | List (e) =>
            case e of (hd::tl) => teval hd env
            | _ => raise OpNonList
        | Item (i, e) => let
            val e1 = teval e env
            in
                case e1 of 
                    ListT t => e1
                    | _ => raise OpNonList
            end
        | Anon (plT, s, e) =>
            let
                val e1 = teval e env
            in
                if (e1 = plT) then e1 else raise WrongRetType
            end;
        