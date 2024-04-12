delete(X, [X|T], T).

delete(X, [H|T], [H|S]):-
    delete(X, T, S).


permutation([], []).

permutation([H|T], R):-
    permutation(T, X), delete(H, R, X).