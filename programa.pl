%atiende(Persona,Dia,Desde,Hasta).
atiende(dodain,lunes,9,15).
atiende(dodain,miercoles,9,15).
atiende(dodain,viernes,9,15).
atiende(lucas,martes,10,20).
atiende(juanC,sabado,18,22).
atiende(juanC,domingo,18,22).
atiende(juanFdS,jueves,10,20).
atiende(juanFdS,viernes,12,20).
atiende(leoC,lunes,14,18).
atiende(leoC,miercoles,14,18).
atiende(martu,miercoles,23,24).

%% PUNTO 1
atiende(vale,Dia,Desde,Hasta):-
    atiende(dodain,Dia,Desde,Hasta).
atiende(vale,Dia,Desde,Hasta):-
    atiende(juanC,Dia,Desde,Hasta).

%nadie hace el mismo horario que leoC:
%   No se hace nada ya que por el concepto de universo cerrado, todo lo que no aparece escrito es falso.
%maiu está pensando si hace el horario de 0 a 8 los martes y miércoles:
%   No se hace nada ya que para el programa solo nos interesan hechos verdaderos o falsos.

%% PUNTO 2

quienAtiende(Persona,Dia,Hora):-
    atiende(Persona,Dia,Desde,Hasta),
    between(Desde,Hasta,Hora).

:- begin_tests(quienAtiende).
    test(quien_atiende_lunes_14,set(Personas==[dodain,leoC,vale])):-
        quienAtiende(Personas,lunes,14).
    test(que_dias_las_10_atiende_vale,set(Dias==[lunes,miercoles,viernes])):-
        quienAtiende(vale,Dias,10).
    test(a_que_horas_atiende_vale_los_miercoles,set(Horas==[9,10,11,12,13,14,15])):-
        quienAtiende(vale,miercoles,Horas).
:- end_tests(quienAtiende).

%% PUNTO 3
foreverAlone(Persona,Dia,Hora):-
    quienAtiende(Persona,Dia,Hora),
    not(atiendeConOtro(Persona,Dia,Hora)).

atiendeConOtro(Persona,Dia,Hora):-
    quienAtiende(OtraPersona,Dia,Hora),
    Persona \= OtraPersona.

:- begin_tests(foreverAlone).
    test(lucas_foreveralone_martes_19):-
        foreverAlone(lucas,martes,19).
    test(juanFdS_foreveralone_jueves_10,nondet):-
        foreverAlone(juanFdS,jueves,10).
    test(persona_que_no_trabaja_ese_horario_no_esta_foreveralone,fail):-
        foreverAlone(martu,miercoles,22).
    test(persona_que_no_trabaja_sola_no_esta_forever_alone,fail):-
        foreverAlone(dodain,lunes,10).
:- end_tests(foreverAlone).

%% PUNTO 4
posibilidadesDeAtencion(Dia,Posibilidades):- %%Version que devuelve lista para no tener tantos repetidos.
    quienAtiende(_,Dia,_),
    findall(Personas,quienesAtiendenPorHorario(Dia,_,Personas),PosibilidadesRepetidas),
    list_to_set(PosibilidadesRepetidas,Posibilidades).

% posibilidadesDeAtencion(Dia,Posibilidad):- %%Version que devuelve cada posibilidad por separado.
%     quienAtiende(_,Dia,_),
%     quienesAtiendenPorHorario(Dia,_,Posibilidad).

quienesAtiendenPorHorario(Dia,Horario,Personas):-
    between(0,24,Horario),
    findall(Persona,quienAtiende(Persona,Dia,Horario),AtiendenHorario),
    list_to_set(AtiendenHorario,Personas).

%% PUNTO 5

%venta(Vendedor,fecha(Dia,Numero,Mes),golosinas(Valor)).
%venta(Vendedor,fecha(Dia,Numero,Mes),cigarrillos(Marcas)).
%venta(Vendedor,fecha(Dia,Numero,Mes),bebida(Alcoholica,Cantidad)).
% venta(dodain,fecha(lunes,10,agosto),golosinas(1200)).
% venta(dodain,fecha(lunes,10,agosto),cigarrillos([jockey])).
% venta(dodain,fecha(lunes,10,agosto),golosinas(50)).
% venta(dodain,fecha(miercoles,12,agosto),bebida(alcoholica,8)).
% venta(dodain,fecha(miercoles,12,agosto),bebida(no-alcoholica,1)).
% venta(dodain,fecha(miercoles,12,agosto),golosinas(10)).
% venta(martu,fecha(miercoles,12,agosto),golosinas(1000)).
% venta(martu,fecha(miercoles,12,agosto),cigarrillos([chesterfield,colorado,parisiennes])).
% venta(lucas,fecha(martes,11,agosto),golosinas(600)).
% venta(lucas,fecha(martes,18,agosto),bebida(no-alcoholica,2)).
% venta(lucas,fecha(martes,18,agosto),cigarrillos([derby])).

%ventas(Persona,fecha(Dia,Numero,Mes),Ventas)
ventas(dodain,fecha(lunes,10,agosto),[golosinas(1200),cigarrillos([jockey]),golosinas(50)]).
ventas(dodain,fecha(miercoles,12,agosto),[bebida(alcoholica,8),bebida(no-alcoholica,1),golosinas(10)]).
ventas(martu,fecha(miercoles,12,agosto),[golosinas(1000),cigarrillos([chesterfield,colorado,parisiennes])]).
ventas(lucas,fecha(martes,11,agosto),[golosinas(600)]).
ventas(lucas,fecha(martes,18,agosto),[bebida(no-alcoholica,2),cigarrillos([derby])]).

esVendedorSuertudo(Persona):-
    ventas(Persona,_,_),
    forall(ventas(Persona,Fecha,_),laPrimeraVentaFueImportante(Persona,Fecha)).

laPrimeraVentaFueImportante(Persona,Fecha):-
    primeraVenta(Persona,Fecha,Venta),
    esVentaImportante(Venta).

primeraVenta(Persona,Fecha,PrimeraVenta):-
    ventas(Persona,Fecha,[PrimeraVenta|_]).

esVentaImportante(golosinas(Precio)):-
    Precio>100.

esVentaImportante(cigarrillos(Marcas)):-
    length(Marcas,Cantidad),
    Cantidad>2.

esVentaImportante(bebida(alcoholica,_)).
esVentaImportante(bebida(_,Cantidad)):-
    Cantidad>5.

/*

Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en los que vendió, la primera venta que hizo fue importante.
Una venta es importante:
    en el caso de las golosinas, si supera los $ 100.
    en el caso de los cigarrillos, si tiene más de dos marcas.
    en el caso de las bebidas, si son alcohólicas o son más de 5.

El predicado debe ser inversible: martu y dodain son personas suertudas.

*/