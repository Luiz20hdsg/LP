ordered(L) :- orderedAUX(L).
orderedAUX([]) :- true.
orderedAUX([_]) :- true.
orderedAUX([A,B|T]) :- A=<B, orderedAUX([B|T]).