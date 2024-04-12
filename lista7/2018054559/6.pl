evenSize([]).             
evenlength([_|Xs]) :-
   oddlength(Xs).

oddSize([_|Xs]) :-       
   evenlength(Xs).