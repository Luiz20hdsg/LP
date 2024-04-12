%%

%name PlcParser

%pos int

%term
    VAR |
    FN |
    FUN |
    IF |
    THEN |
    ELSE |
    END |
    REC |
    MATCH |
    WITH |
    NEGATIVE |
    AND |
    HD |
    TL |
    ISE |
    PRINT |
    PLUS |
    MINUS |
    MULTIPLIER |
    DIVIDER|
    EQUAL |
    DIFFERENT |
    LESS |
    LESSEQUAL |
    DOUBLECOLON |
    COLON |
    SEMICOLON |
    COMMA |
    ARROW |
    PIPE |
    UNDERSCORE |
    DOUBLEARROW |
    NIL |
    BOOL |
    INT |
    TRUE |
    FALSE|
    OPENPARENTHESIS |
    CLOSEPARENTHESIS |
    OPENBRACKETS |
    CLOSEBRACKETS |
    OPENCBRACKETS |
    CLOSECBRACKETS |
    NAME of string |
    CINT of int |
    EOF

%nonterm Prog of expr |
    Decl of expr |
    Expr of expr |
    AtomExpr of expr |
    AppExpr of expr |
    Const of expr |
    Comps of expr list |
    MatchExpr of (expr option * expr) list |
    CondExpr of expr option |
    Args of (plcType * string) list |
    Params of (plcType * string) list |
    TypedVar of plcType * string |
    Type of plcType |
    AtomType of plcType |
    Types of plcType list


%right SEMICOLON ARROW
%nonassoc IF
%left ELSE
%left AND
%left EQUAL DIFFERENT
%left LESS LESSEQUAL
%right DOUBLECOLON
%left PLUS MINUS
%left MULTIPLIER DIVIDER
%nonassoc NEGATIVE HD TL ISE PRINT NAME
%left OPENBRACKETS

%eop EOF

%noshift EOF

%start Prog

%%

Prog: Expr (Expr)
    | Decl (Decl)

Decl: VAR NAME EQUAL Expr SEMICOLON Prog (Let(NAME, Expr, Prog))
    | FUN NAME Args EQUAL Expr SEMICOLON Prog (Let(NAME, makeAnon(Args, Expr), Prog))
    | FUN REC NAME Args COLON Type EQUAL Expr SEMICOLON Prog (makeFun(NAME, Args, Type, Expr, Prog))

Expr: AtomExpr(AtomExpr)
    | AppExpr(AppExpr)
    | IF Expr THEN Expr ELSE Expr (If(Expr1, Expr2, Expr3))
    | MATCH Expr WITH MatchExpr (Match (Expr, MatchExpr))
    | NEGATIVE Expr (Prim1("!", Expr))
    | Expr AND Expr (Prim2("&&", Expr1, Expr2))
    | HD Expr (Prim1("hd", Expr))
    | TL Expr (Prim1("tl", Expr))
    | ISE Expr (Prim1("ise", Expr))
    | PRINT Expr (Prim1("print", Expr))
    | Expr PLUS Expr (Prim2("+", Expr1, Expr2))
    | Expr MINUS Expr (Prim2("-", Expr1, Expr2))
    | Expr MULTIPLIER Expr (Prim2("*", Expr1, Expr2))
    | Expr DIVIDER Expr (Prim2("/", Expr1, Expr2))
    | MINUS Expr (Prim1("-", Expr))
    | Expr EQUAL Expr (Prim2("=", Expr1, Expr2))
    | Expr DIFFERENT Expr (Prim2("!=", Expr1, Expr2))
    | Expr LESS Expr (Prim2("<", Expr1, Expr2))
    | Expr LESSEQUAL Expr (Prim2("<=", Expr1, Expr2))
    | Expr DOUBLECOLON Expr (Prim2("::", Expr1, Expr2))
    | Expr SEMICOLON Expr (Prim2(";", Expr1, Expr2))
    | Expr OPENBRACKETS CINT CLOSEBRACKETS (Item (CINT, Expr))

AtomExpr: Const (Const)
    | NAME (Var(NAME))
    | OPENCBRACKETS Prog CLOSECBRACKETS (Prog)
    | OPENPARENTHESIS Comps CLOSEPARENTHESIS (List Comps)
    | OPENPARENTHESIS Expr CLOSEPARENTHESIS (Expr)
    | FN Args DOUBLEARROW Expr END (makeAnon(Args, Expr))

AppExpr: AtomExpr AtomExpr (Call(AtomExpr1, AtomExpr2))
    | AppExpr AtomExpr (Call(AppExpr, AtomExpr))

Const: TRUE (ConB true) | FALSE (ConB false)
    | CINT (ConI CINT)
    | OPENPARENTHESIS CLOSEPARENTHESIS (List [])
    | OPENPARENTHESIS Type OPENBRACKETS CLOSEBRACKETS CLOSEPARENTHESIS (ESeq(Type))

Comps: Expr COMMA Expr (Expr1 :: Expr2 :: [])
    | Expr COMMA Comps (Expr :: Comps)

MatchExpr: END ([])
    | PIPE CondExpr ARROW Expr MatchExpr ((CondExpr, Expr) :: MatchExpr)

CondExpr: Expr (SOME(Expr))
    | UNDERSCORE (NONE)

Args: OPENPARENTHESIS CLOSEPARENTHESIS ([])
    | OPENPARENTHESIS Params CLOSEPARENTHESIS (Params)

Params : TypedVar (TypedVar::[])
    | TypedVar COMMA Params (TypedVar::Params)

TypedVar: Type NAME ((Type, NAME))

Type: AtomType(AtomType)
    | OPENPARENTHESIS Types CLOSEPARENTHESIS (ListT Types)
    | OPENBRACKETS Type CLOSEBRACKETS (SeqT Type)
    | Type ARROW Type (FunT (Type1, Type2))

AtomType: NIL (ListT [])
    | BOOL (BoolT)
    | INT (IntT)
    | OPENPARENTHESIS Type CLOSEPARENTHESIS (Type)

Types: Type COMMA Type (Type1 :: Type2 :: [])
    | Type COMMA Types (Type :: Types)