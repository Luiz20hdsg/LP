(* Plc interpreter main file *)
CM.make("$/basis.cm");
CM.make("$/ml-yacc-lib.cm");
use "Environ.sml";
use "Absyn.sml";
use "PlcParserAux.sml";
use "PlcParser.yacc.sig";
use "PlcParser.yacc.sml";
use "PlcLexer.lex.sml";
use "Parse.sml";
use "PlcInterp.sml";
use "PlcChecker.sml";

Control.Print.printLength := 1000;
Control.Print.printDepth := 1000;
Control.Print.stringDepth := 1000;

open PlcFrontEnd;

fun run exp =
    let
        val expressionType = teval exp []
        val result = eval exp []
    in
        val2string(result) ^ " : " ^ type2string(expressionType)
    end
        handle 
        SymbolNotFound => "SymbolNotFound: a symbol was not defined or could not be found"
        | NotAFunc => "NotFunc: calling non-functions as functions is not allowed"
        | HDEmptySeq => "HDEmptySeq: accessing the head of empty sequence is not allowed"
        | Impossible => "Impossible: this should be impossible"
        | TLEmptySeq => "TLEmptySeq: can not access empty tail sequence"
        | ValueNotFoundInMatch => "ValueNotFoundInMatch: match was unable to match with this pattern"
        | EmptySeq => "EmptySeq: can not resolve empty sequence"
        | UnknownType => "UnknownType: the interpreter could not resolve this type"
        | WrongRetType => "WrongRetType: can not return different type"
        | IfCondNotBool => "IfCondNotBool: ifs using non booleans as conditions are not allowed"
        | NoMatchResults => "NoMatchResults: could not match results"
        | DiffBrTypes => "DiffBrTypes: if branches with different types are not allowed"
        | NotFunc => "NotFunc: calling non-functions as functions is not allowed"
        | NotEqTypes => "NotEqTypes: can not compare different types"
        | MatchCondTypesDiff => "MatchCondTypesDiff: matches with different condition types are not allowed"
        | OpNonList => "OpNonList: can not treat a non list as a list"
        | MatchResTypeDiff => "MatchResTypeDiff: can not match with different result types"
        | CallTypeMisM => "CallTypeMisM: can not call a function sending different parameter types"
        | ListOutOfRange => "ListOutOfRange: accessing elements out of a list is not allowed"
        | _ => "UnknownError: the interpreter is unable to figure out what caused this error"