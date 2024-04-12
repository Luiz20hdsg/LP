select(X, [X|L], L).
select(X, [H|L], [H|LR]) :- select(X, L, LR).