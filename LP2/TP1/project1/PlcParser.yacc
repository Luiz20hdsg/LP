%%

%name PlcParser

%pos int

%term VAR
    | AND
    | IF | THEN | ELSE
    | PLUS | MINUS | MULT | DIV | EQUAL | NEQUAL | LESS | LESSEQUAL | NOT
    | LPAR | RPAR | LSBRACKET | RSBRACKET | LCBRACES | RCBRACES
    | CONCAT
    | MATCH | WITH | END
    | PRINT
    | SEMIC | ARROW | PIPE | UNDERSCR | COLON | COMMA
    | NAME of string | NUM of int | CBOOL of bool
    | NIL | BOOL | INT
    | FUN | REC | FN | ARROWFUN
    | EOF
    | HD | TL | ISE

%right SEMIC ARROW
%nonassoc IF
%left ELSE
%left AND
%left EQUAL
%left LESS LESSEQUAL
%right CONCAT
%left PLUS MINUS
%left MULT DIV
%nonassoc NOT PRINT HD TL ISE
%left LSBRACKET

%nonterm Prog of expr 
    | Decl of expr
    | Expr of expr 
    | AtomicExpr of expr 
    | AppExpr of expr
    | Const of expr 
    | Comps of expr list
    | MatchExpr of (expr option * expr) list 
    | CondExpr of expr option
    | Args of (plcType * string) list
    | Params of (plcType * string) list
    | TypedVar of plcType * string
    | Type of plcType
    | AtomicType of plcType
    | Types of plcType list
    

%eop EOF

%noshift EOF

%start Prog

%%

Prog: Expr(Expr) 
    | Decl(Decl)

Decl: VAR NAME EQUAL Expr SEMIC Prog                        (Let(NAME, Expr, Prog))
    | FUN NAME Args EQUAL Expr SEMIC Prog                   (Let(NAME, makeAnon(Args, Expr), Prog))
    | FUN REC NAME Args COLON Type EQUAL Expr SEMIC Prog    (makeFun(NAME, Args, Type, Expr, Prog))

Expr: AtomicExpr                    (AtomicExpr)
    | AppExpr                       (AppExpr)
    | IF Expr THEN Expr ELSE Expr   (If(Expr1,Expr2,Expr3))
    | MATCH Expr WITH MatchExpr     (Match(Expr, MatchExpr))
    | NOT Expr                      (Prim1("!", Expr))
    | MINUS Expr                    (Prim1("-", Expr))
    | HD Expr                       (Prim1("hd", Expr))
    | TL Expr                       (Prim1("tl", Expr))
    | ISE Expr                      (Prim1("ise", Expr))
    | PRINT Expr                    (Prim1("print", Expr))
    | Expr AND Expr                 (Prim2("&&", Expr1, Expr2))
    | Expr PLUS Expr                (Prim2("+", Expr1, Expr2))
    | Expr MINUS Expr               (Prim2("-", Expr1, Expr2))
    | Expr MULT Expr                (Prim2("*", Expr1, Expr2))
    | Expr DIV Expr                 (Prim2("/", Expr1, Expr2))
    | Expr EQUAL Expr               (Prim2("=", Expr1, Expr2))
    | Expr NEQUAL Expr              (Prim2("!=", Expr1, Expr2))
    | Expr LESS Expr                (Prim2("<", Expr1, Expr2))
    | Expr LESSEQUAL Expr           (Prim2("<=", Expr1, Expr2))
    | Expr CONCAT Expr              (Prim2("::", Expr1, Expr2))
    | Expr SEMIC Expr               (Prim2(";", Expr1, Expr2))
    | Expr LSBRACKET NUM RSBRACKET  (Item(NUM, Expr))

AtomicExpr: Const               (Const)
    | NAME                      (Var(NAME))
    | LCBRACES Prog RCBRACES    (Prog)
    | LPAR Expr RPAR            (Expr)
    | LPAR Comps RPAR           (List(Comps))
    | FN Args ARROWFUN Expr END (makeAnon(Args, Expr))

AppExpr: AtomicExpr AtomicExpr (Call(AtomicExpr1,AtomicExpr2))
    | AppExpr AtomicExpr       (Call(AppExpr,AtomicExpr))

Const: CBOOL                                                    (ConB(CBOOL))
    | NUM                                                       (ConI(NUM))
    | LPAR RPAR                                                 (List([]))
    | LPAR LSBRACKET Type RSBRACKET LSBRACKET RSBRACKET RPAR    (ESeq(SeqT(Type)))

Comps: Expr COMMA Expr  (Expr1::Expr2::[])
    | Expr COMMA Comps  (Expr::Comps)

MatchExpr: END ([])
    | PIPE CondExpr ARROW Expr MatchExpr ((CondExpr, Expr)::MatchExpr)

CondExpr: Expr (SOME(Expr))
    | UNDERSCR (NONE)

Args: LPAR RPAR        ([])
    | LPAR Params RPAR (Params)

Params: TypedVar            (TypedVar::[])
    | TypedVar COMMA Params (TypedVar::Params)

TypedVar: Type NAME (Type,NAME)

Type: AtomicType                (AtomicType)
    | LPAR Types RPAR           (ListT(Types))
    | LSBRACKET Type RSBRACKET  (SeqT(Type))
    | Type ARROW Type           (FunT(Type1,Type2))

AtomicType: NIL         (ListT[])
    | BOOL              (BoolT)
    | INT               (IntT)
    | LPAR Type RPAR    (Type)

Types: Type COMMA Type  (Type1::Type2::[])
    | Type COMMA Types  (Type::Types)