:- consult('features.pl').

:- dynamic maxCircleSD/1.

maxCircleSD(0.80).

updateMaxSD(SD) :-
    retractall(maxCircleSD(_)),
    assert(maxCircleSD(SD)).

isCircleImg(Filename) :-
    readPGM(Filename, M),
    coord(M, S),
    standardDeviation(S, SD),
    maxCircleSD(MaxSD),
    write(Filename),
    ((SD =< MaxSD) ->
        writeln(' is a circle');
        writeln(' is not a circle')),
    viewPGM(Filename),
    writeln('Am i correct? y/n'),
    read(Answer),
    ((Answer = 'n') ->
        updateMaxSD(SD)).
