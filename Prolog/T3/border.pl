:- consult('img.pl').

is_border(S, (PX, PY, PV)) :-
    PV = 1,
    n4(S, (PX, PY, PV), N),
    findall((NX, NY, NV),
        (member((NX, NY, NV), N),
        NV =:= 0),
        Bag),
    length(Bag, LenBag),
    LenBag > 0.

find_border(Sin, Sout) :-
    length(Sin, Length),
    findall((PX, PY, 1),
        (between(1, Length, I),
        nth1(I, Sin, (PX, PY, PV)),
        is_border(Sin, (PX, PY, PV))),
    Sout).
