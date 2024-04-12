dupList([], []).
dupList([Head| Tail], DupList) :
	append([Head], [Head], Heads),
	dupList(Tail, Dups),
	append(Heads, Dups, DupList).