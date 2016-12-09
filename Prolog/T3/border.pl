:- consult('img.pl').

isBorder(S, (PX, PY, PV)) :-
    PV =:= 1,
    n4(S, (PX, PY, PV), N),
    findall((NX, NY, NV),
        (member((NX, NY, NV), N),
        NV =:= 0),
        Bag),
    length(Bag, LenBag),
    LenBag > 0.

findBorder(Sin, Sout) :-
    length(Sin, Length),
    findall((PX, PY, 1),
        (between(1, Length, I),
        nth1(I, Sin, (PX, PY, PV)),
        isBorder(Sin, (PX, PY, PV))),
    Sout).

border(Sin, Sout) :-
    findBorder(Sin, SinB),
    shape(Sin, H, W),
    zeros((H,W), SZeros),
    findall((ZX, ZY, Value),
        (member((ZX, ZY, _), SZeros),
        (member((ZX, ZY, PV), SinB) -> Value = PV; Value = 0)),
    Sout).

borderPGM(FileIn, FileOut) :-
    readPGM(FileIn, M),
    coord(M, S),
    border(S, Borders),
    coord2matrix(Borders, MBorders),
    writePGM(FileOut, MBorders).
