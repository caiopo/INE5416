/*
   Programacao Logica - Prof. Alexandre G. Silva - UFSC
     Versao inicial     : 30set2015
     Adicao de gramatica: 15out2015
     Ultima atualizacao : 12out2016

   RECOMENDACOES:

   - O nome deste arquivo deve ser 'programa.pl'
   - O nome do banco de dados deve ser 'desenhos.pl'
   - O nome do arquivo de gramatica deve ser 'gramatica.pl'

   - Dicas de uso podem ser obtidas na execucação:
     ?- menu.

   - Exemplo de uso:
     ?- load.
     ?- searchAll(id1).

   - Exemplos de uso da gramatica:
     ?- comando([pf, '10'], []).
     Ou simplesmente:
     ?- cmd("pf 10").

     ?- comando([repita, '5', '[', pf, '50', gd, '45', ']'], []).
     Ou simplesmente:
     ?- cmd("repita 5[pf 50 gd 45]").

   - Colocar o nome e matricula de cada integrante do grupo
     nestes comentarios iniciais do programa

    Aluno: Caio Pereira Oliveira
    Matricula: 15100724
*/


:- set_prolog_flag(double_quotes, codes).
:- initialization(new0).

% Coloca tartaruga no centro da tela (de 1000x1000)
new0 :-
    consult('gramatica.pl'),
    load,
    set_angle(90),
    set_xylast(500, 500),

    (xy(_, _, _), ! -> getPoints(_, All), nth0(0, All, P), nth0(0, P, IDP),
        nb_setval(indexID, IDP), uselapis, commit;

    nb_setval(indexID, -1),
    uselapis,
    nb_getval(indexID, ID),
    new(ID, 500, 500),
    commit).

% Limpa os desenhos e reinicia no centro da tela (de 1000x1000)
% Implementacao incompleta:
%   - Considera apenas id1
tartaruga :-
    retractall(xy(_,_,_)),
    nb_setval(indexID, -1),
    uselapis,
    nb_getval(indexID, ID),
    new(ID, 500, 500),
    set_xylast(500, 500),
    set_angle(90).

% Para frente N passos
% Implementacao incompleta:
%   - Considera apenas id1
%   - Somando apenas em X, ou seja, nao considera a inclinacao da tartaruga
parafrente(N) :-
    angle(Ang),
    X is cos((Ang * pi) / 180) * N,
    Y is sin((Ang * pi) / 180) * N,
    nb_getval(lapis, L),
    nb_getval(indexID, ID),
    xylast(OldX, OldY),
    NewX is OldX + X,
    NewY is OldY + Y,
    set_xylast(NewX, NewY),
    (L =:= 1 -> new(ID, X, Y); true).

% Para tras N passos
paratras(N) :-
    N2 is -N,
    parafrente(N2).

% Gira a direita G graus
giradireita(G) :-
    angle(OldAngle),
    NewAngle is OldAngle + G,
    set_angle(NewAngle).

% Gira a esquerda G graus
giraesquerda(G) :-
    angle(OldAngle),
    NewAngle is OldAngle - G,
    set_angle(NewAngle).

% Use nada (levanta lapis)
usenada :-
    nb_setval(lapis, 0).

% Use lapis
uselapis :-
    nb_setval(lapis, 1), nb_getval(indexID, LastID),
    ID is LastID + 1, nb_setval(indexID, ID),
    (ID > 0 -> xylast(X, Y), new(ID, X, Y);
    true).

triangulo(Lado) :-
    Altura is (sqrt(3) / 2) * Lado,
    Desl is Altura / 3,
    nb_getval(lapis, Lapis),
    usenada,
    parafrente(Desl),
    uselapis,
    giradireita(150),
    parafrente(Lado),
    giradireita(120),
    parafrente(Lado),
    giradireita(120),
    parafrente(Lado),
    giraesquerda(390),
    usenada,
    paratras(Desl),
    (Lapis =:= 1 -> uselapis; true).

%---------------------------------------------------


set_angle(Angle) :-
    retractall(angle(_)),
    asserta(angle(Angle)).

set_xylast(X, Y) :-
    retractall(xylast(_, _)),
    asserta(xylast(X, Y)).


% Apaga os predicados 'xy' da memoria e carrega os desenhos a partir de um arquivo de banco de dados
load :-
    retractall(xy(_,_,_)),
    open('desenhos.pl', read, Stream),
    repeat,
        read(Stream, Data),
        (Data == end_of_file -> true ; assert(Data), fail),
        !,
        close(Stream).

% Ponto de deslocamento, se <Id> existente
new(Id,X,Y) :-
    xy(Id,_,_),
    assertz(xy(Id,X,Y)),
    !.

% Ponto inicial, caso contrario
new(Id,X,Y) :-
    asserta(xy(Id,X,Y)),
    !.

% Exibe opcoes de busca
search :-
    write('searchAll(Id).     -> Ponto inicial e todos os deslocamentos de <Id>'), nl,
    write('searchFirst(Id,N). -> Ponto inicial e os <N-1> primeiros deslocamentos de <Id>'), nl,
    write('searchLast(Id,N).  -> Lista os <N> ultimos deslocamentos de <Id>').

searchAll(Id) :-
    listing(xy(Id,_,_)).

% Exibe opcoes de alteracao
change :-
    write('change(Id,X,Y,Xnew,Ynew).  -> Altera um ponto de <Id>'), nl,
    write('changeFirst(Id,Xnew,Ynew). -> Altera o ponto inicial de <Id>'), nl,
    write('changeLast(Id,Xnew,Ynew).  -> Altera o deslocamento final de <Id>').

% Grava os desenhos da memoria em arquivo
commit :-
    open('desenhos.pl', write, Stream),
    telling(Screen),
    tell(Stream),
    listing(xylast),
    listing(xy),
    tell(Screen),
    close(Stream).

% Exibe menu principal
menu :-
    write('load.        -> Carrega todos os desenhos do banco de dados para a memoria'), nl,
    write('new(Id,X,Y). -> Insere um deslocamento no desenho com identificador <Id>'), nl,
    write('                (se primeira insercao, trata-se de um ponto inicial)'), nl,
    write('search.      -> Consulta pontos dos desenhos'), nl,
    write('change.      -> Modifica um deslocamento existente do desenho'), nl,
    write('remove.      -> Remove um determinado deslocamento existente do desenho'), nl,
    write('undo.        -> Remove o deslocamento inserido mais recentemente'), nl,
    write('commit.      -> Grava alteracoes de todos dos desenhos no banco de dados').

% T2A

getPoints(Id, Bag) :- findall(P, (xy(Id, X, Y), P = [Id, X, Y]), Bag).

searchFirst(Id, N) :- getPoints(Id, Points),
    findall(_, (between(1, N, T), nth1(T, Points, Vertex), writeln(Vertex)), _).

searchLast(Id, N) :- getPoints(Id, Points), length(Points, Length), Min is Length-N,
    findall(_, (between(Min, Length, Index), nth0(Index, Points, Vertex), writeln(Vertex)), _).

change(Id, X, Y, Xnew, Ynew) :- getPoints(Id, Points), length(Points, Length),
    removeAll(Id), between(0, Length, Index),
    nth0(Index, Points, Vertex), nth0(1, Vertex, XV), nth0(2, Vertex, YV),
    ((X = XV, Y = YV) -> new(Id, Xnew, Ynew); new(Id, XV, YV)), false; true.

changeFirst(Id, Xnew, Ynew) :- remove(Id, _, _), !, asserta(xy(Id, Xnew, Ynew)).

changeLast(Id, Xnew, Ynew) :- removeLast(Id), assertz(xy(Id, Xnew, Ynew)).

remove :-
    writeln('removeFirst(Id)      -> Remove o ponto inicial de um Id'),
    writeln('removeLast(Id)       -> Remove o último ponto de um Id'),
    writeln('remove(Id, X, Y)     -> Remove um ponto específico'),
    write('removeAll(Id)        -> Remove todos os pontos de um Id').

removeFirst(Id) :- remove(Id, _, _).

removeLast(Id) :- getPoints(Id, Points), last(Points, Last), nth0(1, Last, X),
    nth0(2, Last, Y), remove(Id, X, Y).

remove2(Id, X, Y) :- retract(xy(Id, X, Y)), !.

removeAll(Id) :- retractall(xy(Id, _, _)).

undo :- getPoints(_, Points), last(Points, Last),
    nth0(0, Last, Id), nth0(1, Last, X), nth0(2, Last, Y), remove2(Id, X, Y).

quadrado(Id, X, Y, Lado) :- new(Id, X, Y), new(Id, Lado, 0), new(Id, 0, Lado),
    N is -Lado, new(Id, N, 0).

figura(Id, X, Y) :- new(Id, X, Y), new(Id, -100, 200), new(Id, 200, 0),
    new(Id, -50, -100), new(Id, -100, 0), new(Id, 50, 100), new(Id, 50, -100).

replica(Id, N, Dx, Dy) :- between(1, N, Index), getPoints(Id, Points),
    length(Points, Length), between(0, Length, Index2),
    nth0(Index2, Points, Vertex), nth0(0, Vertex, IdVertex),
    nth0(1, Vertex, XVertex), nth0(2, Vertex, YVertex),
    atom_concat(IdVertex, '_r', Temp), atom_concat(Temp, Index, IdNew),
    X is XVertex + (Index * Dx), Y is YVertex + (Index * Dy),
    ((Index2 =:= 0) -> new(IdNew, X, Y); new(IdNew, XVertex, YVertex)),
    false; true.

testes :-
    consult('programa.pl'),
    load,
    cmd("pf 54 ge 37 pt 28 gd 95 pf 54 ge 37 pt 28 gd 95 pf 54 ge 37 pt 28 gd 95 pf 54 ge 37 pt 28 gd 95 pf 54 ge 37 pt 28 gd 95 pf 54 ge 37 pt 28 gd 95"),
    cmd("un pf 100 ul"),
    %cmd("repita 36 [ gd 150 repita 8 [ pf 50 ge 45]]"),
    cmd("pf 54 ge 37 pt 28 gd 95 pf 54 ge 37 pt 28 gd 95 pf 54 ge 37 pt 28 gd 95 pf 54 ge 37 pt 28 gd 95 pf 54 ge 37 pt 28 gd 95 pf 54 ge 37 pt 28 gd 95"),
    commit,
    !.
