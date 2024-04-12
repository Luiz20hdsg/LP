same(X, X).
same([A| B], [C| D]):-
    A=C,
    same(B,D).
