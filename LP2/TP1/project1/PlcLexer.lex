(* Plc Lexer *)

(* User declarations *)

open Tokens
type pos = int
type slvalue = Tokens.svalue
type ('a,'b) token = ('a,'b) Tokens.token
type lexresult = (slvalue, pos)token

(* A function to print a message error on the screen. *)

fun keyword (s, lpos, rpos) =
    case s of
        "var" => VAR (lpos, rpos)
        | "if" => IF (lpos, rpos)
        | "then" => THEN (lpos, rpos)
        | "else" => ELSE (lpos, rpos)
        | "fun" => FUN(lpos, rpos)
        | "fn" => FN(lpos, rpos)
        | "print" => PRINT (lpos, rpos)
        | "Bool" => BOOL (lpos, rpos)
        | "rec" => REC(lpos, rpos)
        | "match" => MATCH (lpos, rpos)
        | "with" => WITH (lpos, rpos)
        | "hd" => HD (lpos, rpos)
        | "end" => END (lpos, rpos)
        | "Int" => INT (lpos, rpos)
        | "Nil" => NIL (lpos, rpos)
        | "tl" => TL (lpos, rpos)
        | "ise" => ISE (lpos, rpos)
        | "_" => UNDERSCR (lpos, rpos)
        | _ => NAME (s, lpos, rpos)

val error = fn x => TextIO.output(TextIO.stdOut, x ^ "\n")

val lineNumber = ref 0

(* Get the current line being read. *)
fun getLineAsString() =
    let
        val lineNum = !lineNumber
    in
        Int.toString lineNum
    end

fun strToBool s =
    case Bool.fromString s of
          SOME i => i
        | NONE => raise Fail ("Could not convert string to bool")

fun strToInt s =
    case Int.fromString s of
          SOME i => i
        | NONE => raise Fail ("Could not convert string to int")


(* Define what to do when the end of the file is reached. *)
fun eof () = Tokens.EOF(0,0)

(* Initialize the lexer. *)
fun init() = ()
%%
%header (functor PlcLexerFun(structure Tokens: PlcParser_TOKENS));
alpha=[A-Za-z];
digit=[0-9];
whitespace=[\ \t];
identifier=[a-zA-Z_][a-zA-Z_0-9]*;
boolean=(true)|(false);
%%

\n => (lineNumber := !lineNumber + 1; lex());
{whitespace}+ => (lex());
{digit}+ => (NUM(strToInt(yytext), yypos, yypos));
{boolean}+ => (CBOOL(strToBool(yytext), yypos, yypos));
{identifier} => (keyword(yytext, yypos, yypos));
":" => (COLON(yypos, yypos));
"::" => (CONCAT(yypos, yypos));
";" => (SEMIC(yypos, yypos));
"," => (COMMA(yypos, yypos));
"+" => (PLUS(yypos, yypos));
"-" => (MINUS(yypos, yypos));
"*" => (MULT(yypos, yypos));
"/" => (DIV(yypos, yypos));
"=" => (EQUAL(yypos, yypos));
"!=" => (NEQUAL(yypos, yypos));
"<=" => (LESSEQUAL(yypos, yypos));
"=>" => (ARROWFUN(yypos, yypos));
"(" => (LPAR(yypos, yypos));
")" => (RPAR(yypos, yypos));
"[" => (LSBRACKET(yypos, yypos));
"]" => (RSBRACKET(yypos, yypos));
"{" => (LCBRACES(yypos, yypos));
"}" => (RCBRACES(yypos, yypos));
"<" => (LESS(yypos, yypos));
"!" => (NOT(yypos, yypos));
"&&" => (AND(yypos, yypos));
"->" => (ARROW(yypos, yypos));
"|" => (PIPE(yypos, yypos));
. => (error("\n *** Lexer error: character invalid ***\n "); raise
Fail("Lexer error: character invalid" ^yytext));

