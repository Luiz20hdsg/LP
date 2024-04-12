isEqual([X,Y]):- X == Y , !.
isEqual([H,H1|T]):- H == H1 , isEqual([H1|T]).