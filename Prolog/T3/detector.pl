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
        writeln(' is a circle'), Circle = 'True';
        writeln(' is not a circle'), Circle = 'False'),
    viewPGM(Filename),
    writeln('Am I correct? y/n'),
    read(Answer),
    ((Circle = 'True', Answer = 'n') ->
        NewSD is MaxSD - 0.5,
        updateMaxSD(NewSD); true),
    ((Circle = 'False', Answer = 'n') ->
        updateMaxSD(SD); true).
