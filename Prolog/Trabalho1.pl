dados(1, cad5151, []).
dados(1, ccn5115, []).
dados(1, dir5966, []).
dados(1, llv5603, []).
dados(1, mtm5134, []).

dados(2, ccn5116, [ccn5115]).
dados(2, cnm5145, []).
dados(2, dir5972, []).
dados(2, ine5125, []).
dados(2, mtm5151, []).

dados(3, ccn5117, [ccn5116]).
dados(3, ccn5124, [ccn5116]).
dados(3, fil5109, []).
dados(3, ine5126, [ine5125]).
dados(3, mtm5152, [mtm5151]).

dados(4, ccn5119, [ccn5117]).
dados(4, ccn5120, [ine5125]).
dados(4, ccn5137, [ccn5117]).
dados(4, dir5991, []).

dados(5, ccn5139, [ccn5137]).
dados(5, ccn5171, []).
dados(5, ccn5303, [ccn5119]).
dados(5, ccn5321, [dir5991]).
dados(5, cnm5305, [mtm5152]).

dados(6, ccn5140, [ccn5139]).
dados(6, ccn5141, [ccn5119]).
dados(6, ccn5172, [ccn5171]).
dados(6, ccn5180, [mtm5152]).
dados(6, ccn5322, [dir5991]).

dados(7, ccn5181, [ccn5140]).
dados(7, ccn5183, [ccn5180]).
dados(7, ccn5184, [ccn5119]).
dados(7, ccn5185, [ccn5124]).
dados(7, ccn5186, [ccn5119]).
dados(7, ccn5318, [ccn5303]).

dados(8, ccn5147, [ccn5318]).
dados(8, ccn5182, [ccn5181]).
dados(8, ccn5320, [ccn5318]).
dados(8, ccn5323, [ccn5321, ccn5322]).
dados(8, ccn5325, [ccn5140]).

dados(9, ccn5404, [ccn5141]).
dados(9, ccn5405, []).

fase(Fase, Materia) :- dados(Fase, Materia, _).

requisitos(Materia, Requisitos) :- dados(_, Materia, Requisitos).

requisita(Requisito, Bag) :- findall(Materia, (requisitos(Materia, Requisitos), member(Requisito, Requisitos)), Bag).
