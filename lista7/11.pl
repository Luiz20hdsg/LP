max(X,Y,Z):- X>Y,Z is X.
max(X,Y,Z):- X=<Y,Z is Y.
maxlist([],0):-!.
maxlist([R],R):-!.
maxlist([H|T],R):-maxlist(T,R1),max(H,R1,R),!.


test([], _, _, _).
test([Y|Ys], X, Cs, Ds) :-
    C is X-Y, \+ member(C, Cs),
    D is X+Y, \+ member(D, Ds),
    X1 is X + 1,
    test(Ys, X1, [C|Cs], [D|Ds]).

queen8(Q) :- perm([1,2,3,4,5,6,7,8], Q), test(Q, 1, [], []).
