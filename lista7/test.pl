not-equal([],[H|_]).
not-equal([H|_],[]).
not-equal([H|T1],[H|T2]) :-
    not-equal(T1,T2).

not-equal([H1|T1],[H2|T2]) :-
    not(var(H1)),
    not(var(H2)),
    H1 =\= H2.