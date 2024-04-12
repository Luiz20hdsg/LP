(* Plc interpreter main file *)

fun run (e: expr) = 
    let
        val eType = teval e []
        val eValue = eval e []
    in
        (val2string eValue) ^ " : " ^ (type2string eType)
    end
    handle
        EmptySeq => "\n PLC Type Exception: Empty input sequence. \n"
        | UnknownType => "\n PLC Type Exception: Unknown type. \n"
        | NotEqTypes => "\n PLC Type Exception: Type mismatch in comparison. \n"
        | WrongRetType => "\n PLC Type Exception: Declared return type does not match function body. \n"
        | DiffBrTypes => "\n PLC Type Exception: Type mismatch on If branches bodies. \n"
        | IfCondNotBool => "\n PLC Type Exception: Type mismatch on If condition; Condition must be Bool. \n"
        | NoMatchResults => "\n PLC Type Exception: No Match results. \n"
        | MatchResTypeDiff => "\n PLC Type Exception: Type mismatch on Match options' bodies. \n"
        | MatchCondTypesDiff => "\n PLC Type Exception: Type mismatch on Match options' conditions. \n"
        | CallTypeMisM => "\n PLC Type Exception: Type mismatch on function call. \n"
        | NotFunc => "\n PLC Type Exception: Not a function. \n"
        | ListOutOfRange => "\n PLC Type Exception: Attempting to access an item out of range. \n"
        | OpNonList => "\n PLC Type Exception: Attempting to access an item but expression is not a list. \n"
        | Impossible => "\n PLC Interpreter Exception: Impossible operation. \n"
        | HDEmptySeq => "\n PLC Interpreter Exception: HD called on empty sequence. \n"
        | TLEmptySeq => "\n PLC Interpreter Exception: TL called on empty sequence. \n"
        | ValueNotFoundInMatch => "\n PLC Interpreter Exception: Value not found in Match. \n"
        | NotAFunc => "\n PLC Interpreter Exception: Not a function. \n"