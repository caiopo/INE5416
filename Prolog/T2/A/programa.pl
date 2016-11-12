/*
   Programacao Logica - Prof. Alexandre G. Silva - 30set2015

   RECOMENDACOES:

   - O nome deste arquivo deve ser 'programa.pl'

   - O nome do banco de dados deve ser 'desenhos.pl'

   - Dicas de uso podem ser obtidas na execucação:
     ?- menu.

   - Exemplo de uso:
     ?- load.
     ?- searchAll(id1).

   - Colocar o nome e matricula de cada integrante do grupo
     nestes comentarios iniciais do programa
*/

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
    writeln('searchAll(Id).     -> Ponto inicial e todos os deslocamentos de <Id>'),
    writeln('searchFirst(Id,N). -> Ponto inicial e os <N-1> primeiros deslocamentos de <Id>'),
    write('searchLast(Id,N).  -> Lista os <N> ultimos deslocamentos de <Id>').

searchAll(Id) :-
    listing(xy(Id,_,_)).

% Exibe opcoes de alteracao
change :-
    writeln('change(Id,X,Y,Xnew,Ynew).  -> Altera um ponto de <Id>'),
    writeln('changeFirst(Id,Xnew,Ynew). -> Altera o ponto inicial de <Id>'),
    write('changeLast(Id,Xnew,Ynew).  -> Altera o deslocamento final de <Id>').

% Grava os desenhos da memoria em arquivo
commit :-
    open('desenhos.pl', write, Stream),
    telling(Screen),
    tell(Stream),
    listing(xy),
    tell(Screen),
    close(Stream).

% Exibe menu principal
menu :-
    writeln('load.        -> Carrega todos os desenhos do banco de dados para a memoria'),
    writeln('new(Id,X,Y). -> Insere um deslocamento no desenho com identificador <Id>'),
    writeln('                (se primeira insercao, trata-se de um ponto inicial)'),
    writeln('search.      -> Consulta pontos dos desenhos'),
    writeln('change.      -> Modifica um deslocamento existente do desenho'),
    writeln('remove.      -> Remove um determinado deslocamento existente do desenho'),
    writeln('undo.        -> Remove o deslocamento inserido mais recentemente'),
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

remove(Id, X, Y) :- retract(xy(Id, X, Y)), !.

removeAll(Id) :- retractall(xy(Id, _, _)).

undo :- getPoints(_, Points), last(Points, Last),
    nth0(0, Last, Id), nth0(1, Last, X), nth0(2, Last, Y), remove(Id, X, Y).

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
