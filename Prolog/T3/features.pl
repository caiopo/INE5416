:- consult('centroid.pl').
:- consult('border.pl').

mean(L, M) :-
    sum_list(L, Sum),
    length(L, Len),
    M is Sum / Len.

distance((PX, PY), (CX, CY), D) :-
    X is abs(PX - CX),
    Y is abs(PY - CY),
    Distance is X**2 + Y**2,
    D is sqrt(Distance).

distances(Lborder, (CX, CY), L) :-
    findall(D, (member((X, Y, _), Lborder),
                distance((X, Y), (CX, CY), D)), L).

averageDistance(S, AvgD) :-
    findBorder(S, Lborder),
    centroidList(S, CX, CY),
    distances(Lborder, (CX, CY), AuxL),
    mean(AuxL, AvgD).

averageDistanceImg(Filename, AvgD) :-
    readPGM(Filename, M), coord(M, S), averageDistance(S, AvgD).

standardDeviationList(L, SD) :-
    mean(L, Mean),
    length(L, Len),
    findall(EF, (member(E, L), EF is ((E - Mean) ** 2)), Bag),
    sum_list(Bag, Sum),
    SD is sqrt(Sum / (Len - 1)).

standardDeviation(S, SD) :-
    findBorder(S, SBorder),
    centroid(S, X, Y), distances(SBorder, (X, Y), Distances),
    standardDeviationList(Distances, SD).

standardDeviationImg(Filename, SD) :-
    readPGM(Filename, M), coord(M, S), standardDeviation(S, SD).
