/* animais.pl - jogo de identificação de animais.

    inicia com ?- iniciar.     */

iniciar :- hipotese(Animal),
      write('Eu acho que o animal é: '),
      write(Animal),
      nl,
      undo.

/* hipóteses a serem testadas */
hipotese(chita)   :- chita, !.
hipotese(tigre)   :- tigre, !.
hipotese(girafa)   :- girafa, !.
hipotese(zebra)     :- zebra, !.
hipotese(avestruz)   :- avestruz, !.
hipotese(pinguim)   :- pinguim, !.
hipotese(albatroz) :- albatroz, !.
hipotese(desconhecido).             /* sem diagnóstico */

/* Regras de identificação dos animais */
chita :- mamífero,
           carnívoro,
           verificar(tem_cor_castanho_claro_para_marrom_alaranjado),
           verificar(tem_manchas_escuras).

tigre :- mamífero,
         carnívoro,
         verificar(tem_cor_castanho_claro_para_marrom_alaranjado),
         verificar(tem_listras_pretas).

girafa :- ungulado,
           verificar(tem_pescoço_longo),
           verificar(tem_pernas_longas).

zebra :- ungulado,
         verificar(tem_listras_pretas).

avestruz :- pássaro,
           verificar(não_voa),
           verificar(tem_pescoço_longo).

pinguim :- pássaro,
           verificar(não_voa),
           verificar(nada),
           verificar(é_preto_e_branco).

albatroz :- pássaro,
             verificar(aparece_no_conto_do_velho_marinheiro),
             verificar(voa_bem).

/* regras de classificação */
mamífero    :- verificar(tem_cabelo), !.
mamífero    :- verificar(dá_leite).

pássaro      :- verificar(tem_penas), !.
pássaro      :- verificar(voa),verificar(põe_ovos).

carnívoro :- verificar(come_carne), !.
carnívoro :- verificar(tem_dentes_pontudos),
             verificar(tem_garras),
             verificar(tem_olhos_frontais).

ungulado :- mamífero,verificar(tem_cascos), !.
ungulado :- mamífero,verificar(rumina).

/* Como fazer perguntas */
perguntar(Questão) :-
    write('O animal tem o seguinte atributo: '),
    write(Questão),
    write(' (s|n) ? '),
    read(Resposta),
    nl,
    ( (Resposta == sim ; Resposta == s)
      ->
       assert(yes(Questão)) ;
       assert(no(Questão)), fail).

:- dynamic yes/1,no/1.

/*
(Condição -> Ação_se_verdadeira ; Ação_se_falsa)

(8 =:= 4*2? -> write("sim") ; write("não")).
*/

/* Como verificar algo */
verificar(S) :-
   (yes(S) % tem yes?
    ->
    true ;  % se sim: retorna true
    (no(S) % não tem yes. Verifica tem no?
     ->
     fail ; % se sim:  para o fluxo de execução
     perguntar(S)% se não tem yes e nem no, deve perguntar
    )
   ).

/* Desfaz todas as afirmações sim / não */
undo :- retract(yes(_)),fail.
undo :- retract(no(_)),fail.
undo.
