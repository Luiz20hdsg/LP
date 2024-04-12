parent(kim,holly).
parent(margaret,kim).
parent(margaret,kent).
parent(esther,margaret).
parent(herbert,margaret).
parent(herbert,jean).
greatGrandParent(GGP,GGC) :- parent(GGP,GP), parent(GP,P), parent(P,GGC).
sibling(X,Y) :- parent(P,X), parent(P, Y), not(X=Y).

firstCousin(CHI1,CHI2) :-parent(Y1,CHI1),parent(Y2,CHI2),sibling(Y1,Y2), not(CHI1=CHI2).


descendant(X, Y) :- parent(X, Z), descendant(Z, Y).
