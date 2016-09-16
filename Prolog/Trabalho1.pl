% Aluno: Caio Pereira Oliveira (15100724)

dados(1, cad5151, [],                 'Teoria das Organizações').
dados(1, ccn5115, [],                 'Contabilidade I').
dados(1, dir5966, [],                 'Legislação Comercial e Societária').
dados(1, llv5603, [],                 'Produção Textual Acadêmica I').
dados(1, mtm5134, [],                 'Matemática I').

dados(2, ccn5116, [ccn5115],          'Contabilidade II').
dados(2, cnm5145, [],                 'Teoria Econômica').
dados(2, dir5972, [],                 'Legislação Social e Previdenciária').
dados(2, ine5125, [],                 'Métodos Estatísticos I').
dados(2, mtm5151, [],                 'Matemática Financeira I').

dados(3, ccn5117, [ccn5116],          'Contabilidade III').
dados(3, ccn5124, [ccn5116],          'Laboratório de Prática Contábil').
dados(3, fil5109, [],                 'Ética e Filosofia Política').
dados(3, ine5126, [ine5125],          'Métodos Estatísticos II').
dados(3, mtm5152, [mtm5151],          'Matemática Financeira II').

dados(4, ccn5119, [ccn5117],          'Contabilidade Superior').
dados(4, ccn5120, [ine5125],          'Contabilometria').
dados(4, ccn5137, [ccn5117],          'Contabilidade de Custos').
dados(4, dir5991, [],                 'Legislação Tributária').

dados(5, ccn5139, [ccn5137],          'Análise de Custos').
dados(5, ccn5171, [],                 'Contabilidade Pública I').
dados(5, ccn5303, [ccn5119],          'Análise das Demonstrações Contábeis').
dados(5, ccn5321, [dir5991],          'Contabilidade Tributária I').
dados(5, cnm5305, [mtm5152],          'Mercado de Capitais').

dados(6, ccn5140, [ccn5139],          'Contabilidade Gerencial').
dados(6, ccn5141, [ccn5119],          'Técnicas de Pesquisa em Contabilidade').
dados(6, ccn5172, [ccn5171],          'Contabilidade Pública II').
dados(6, ccn5180, [mtm5152],          'Contabilidade e Finanças').
dados(6, ccn5322, [dir5991],          'Contabilidade Tributária II').

dados(7, ccn5181, [ccn5140],          'Simulação Gerencial I').
dados(7, ccn5183, [ccn5180],          'Contabilidade Atuarial').
dados(7, ccn5184, [ccn5119],          'Contabilidade Avançada').
dados(7, ccn5185, [ccn5124],          'Sistemas de Informação Contábil').
dados(7, ccn5186, [ccn5119],          'Teoria da Contabilidade').
dados(7, ccn5318, [ccn5303],          'Auditoria Contábil I').

dados(8, ccn5147, [ccn5318],          'Perícia Contábil').
dados(8, ccn5182, [ccn5181],          'Simulação Gerencial II').
dados(8, ccn5320, [ccn5318],          'Auditoria Contábil II').
dados(8, ccn5323, [ccn5321, ccn5322], 'Planejamento Tributário').
dados(8, ccn5325, [ccn5140],          'Controladoria').

dados(9, ccn5404, [ccn5141],          'Trabalho de Conclusão do Curso - TCC').
dados(9, ccn5405, [],                 'Trabalho de Conclusão de Curso - TCC/Artigo').

% T1A Questão 1 e 2
fase(Materia, Fase) :- dados(Fase, Materia, _, _).

% T1A Questão 3
requisitos(Materia, Requisitos) :- dados(_, Materia, Requisitos, _).

% T1A Questão 4
necessitam(Requisito, Bag) :- findall(Materia, (requisitos(Materia, Requisitos), member(Requisito, Requisitos)), Bag).

is_req(D, PR) :- requisitos(D, Req), member(PR, Req).

% T1B Questão 1
nomecompleto(Materia, Nome) :- dados(_, Materia, _, Nome).

% T1B Questão 2
precomum(D1, D2, PR) :- is_req(D1, PR), is_req(D2, PR), D1 @< D2.

% T1B Questão 3
prepre(D, PR) :- is_req(D, X), is_req(X, PR).

% T1B Questão 4
saopre(F, PR) :- fase(PR, F), necessitam(PR, Reqs), Reqs \= [].

% T1B Questão 5
tempre(F, PR) :- fase(PR, F), requisitos(PR, Reqs), Reqs \= [].

% T1B Questão 6
temprecomumsaopre(F, D1, D2) :- precomum(D1, D2, _), saopre(F, D1), saopre(F, D2).

% T1B Questão 7
% Disciplina (D) que está a em uma determinada fase (F)
% e tem não pré-requisito(s) para ser cursada.
proposta(F, D) :- fase(D, F), requisitos(D, Reqs), Reqs = [].
