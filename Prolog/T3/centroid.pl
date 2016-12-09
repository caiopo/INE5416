:- consult('img.pl').

centroidImg(Filename, X, Y) :- 
    readPGM(Filename, M), coord(M, L),
    centroidList(L, X, Y).

centroidList(L, X, Y) :-
    findall((X, Y), member((X, Y, 1), L), AuxL),
    length(AuxL, Len), calculateSumXY(AuxL, (0,0), (Xsum, Ysum)),
    X is Xsum / Len,
    Y is Ysum / Len.

calculateSumXY([], (X, Y), (X, Y)).
calculateSumXY([(Xs, Ys)|L], (X, Y), (A, B)) :-
    Xsum is X + Xs,
    Ysum is Y + Ys,
    calculateSumXY(L, (Xsum, Ysum), (A, B)).
    