:- consult('centroid.pl').
:- consult('border.pl').

mean(L, M) :-
    sum_list(L, Sum),
    length(L, Len),
    M is Sum / Len.

sd(L, SD) :-
    mean(L, Mean),
    length(L, Len),
    findall(EF, (member(E, L), EF is ((E - Mean) ** 2)), Bag),
    sum_list(Bag, Sum),
    SD is sqrt(Sum / (Len - 1)).

distance((PX, PY), (CX, CY), D) :-
    X is abs(PX - CX),
    Y is abs(PY - CY),
    Distance is X**2 + Y**2,
    D is sqrt(Distance).

averageDistanceImg(Filename, AvgD) :-
    readPGM(Filename, M), coord(M, L), find_border(L, Lborder),
    centroidList(L, X, Y), averageDistance(Lborder, (X, Y), AvgD).

distances(Lborder, (CX, CY), L) :-
    findall(D, (member((X, Y, _), Lborder),
                distance((X, Y), (CX, CY), D)), L).

averageDistance(Lborder, (CX, CY), AvgD) :-
    distances(Lborder, (CX, CY), AuxL),
    mean(AuxL, AvgD).

