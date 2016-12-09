:- consult('centroid.pl').
:- consult('border.pl').

mean(L, M) :-
    sum_list(L, Sum),
    length(L, Len),
    M is Sum / Len.

sd_list(L, SD) :-
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

distances(Lborder, (CX, CY), L) :-
    findall(D, (member((X, Y, _), Lborder),
                distance((X, Y), (CX, CY), D)), L).

averageDistanceImg(Filename, AvgD) :-
    readPGM(Filename, M), coord(M, S), averageDistance(S, AvgD).

averageDistance(S, AvgD) :-
    findBorder(S, Lborder),
    centroidList(S, CX, CY),
    distances(Lborder, (CX, CY), AuxL),
    mean(AuxL, AvgD).

sdImg(Filename, Sd) :-
    readPGM(Filename, M), coord(M, L), findBorder(L, Lborder),
    centroidList(L, X, Y), distances(Lborder, (X, Y), Distances),
    sd_list(Distances, Sd).
