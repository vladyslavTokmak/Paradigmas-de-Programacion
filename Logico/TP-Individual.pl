%% se da %%
mago(harry,mestiza,[coraje,amistad,orgullo,inteligencia]).
mago(ron,pura,[amistad,diversion,coraje]).
mago(hermione,impura,[inteligencia,coraje,responsabilidad,amistad,orgullo]).
mago(hannahAbbott,mestiza,[amistad,diversion]).
mago(draco,pura,[inteligencia,orgullo]).
mago(lunaLovegood,mestiza,[inteligencia,responsabilidad,amistad,coraje]).

odia(harry,slytherin).
odia(draco,hufflepuff).

casa(gryffindor).
casa(hufflepuff).
casa(ravenclaw).
casa(slytherin).

caracteriza(gryffindor,amistad).
caracteriza(gryffindor,coraje).
caracteriza(slytherin,orgullo).
caracteriza(slytherin,inteligencia).
caracteriza(ravenclaw,inteligencia).
caracteriza(ravenclaw,responsabilidad).
caracteriza(hufflepuff,amistad).
caracteriza(hufflepuff,diversion).

%% se pide %%
%1
permiteEntrar(slytherin,Mago):- mago(Mago,Sangre,_), Sangre \= impura.
permiteEntrar(Casa,Mago):- casa(Casa), mago(Mago,_,_), Casa \= slytherin.

%2
tieneCaracter(Mago,Casa):-
	mago(Mago,_,_), casa(Casa),
	forall(caracteriza(Casa,Caracteristica), tieneCaracteristica(Mago,Caracteristica)).
	
tieneCaracteristica(Mago,Caracteristica):-
	mago(Mago,_,Caracteristicas),
	member(Caracteristica,Caracteristicas).

%3
casaPosible(Mago,Casa):-
	tieneCaracter(Mago,Casa),
	permiteEntrar(Casa,Mago),
	not(odia(Mago,Casa)).
	
%4
cadenaDeAmistades(Magos):-
	forall(member(Mago,Magos), tieneCaracteristica(Mago, amistad)),
	cadenaDeCasas(Magos).
cadenaDeCasas([_]).
cadenaDeCasas([M1, M2 | Magos]):-
	casaPosible(M1, Casa),
	casaPosible(M2, Casa),
	cadenaDeCasas([M2 | Magos]).
	
%% se da %%	
lugarProhibido(bosque,50).
lugarProhibido(seccionRestringida,10).
lugarProhibido(tercerPiso,75).

alumnoFavorito(flitwick, hermione).
alumnoFavorito(snape, draco).
alumnoOdiado(snape, harry).

hizo(ron, buenaAccion(jugarAlAjedrez, 50)).
hizo(harry, fueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(hermione, responder('Donde se encuentra un Bezoar', 15, snape)).
hizo(hermione, responder('Wingardium Leviosa', 25, flitwick)).
hizo(ron, irA(bosque)).
%% Agrego algunos hechos mas para poder probar bien el ultimo punto
hizo(lunaLovegood, responder('Felix Felicis', 20, snape)).
hizo(draco, responder('Hombre Lobo', 40, snape)).
hizo(draco, fueraDeCama).
hizo(hannahAbbott, responder('Lumos Maxima', 10, flitwick)).
hizo(hermione, buenaAccion(saberDeBotanica, 50)).
hizo(harry, buenaAccion(enfrentarAVoldemort, 100)).

esDe(harry, gryffindor).
esDe(ron, gryffindor).
esDe(hermione, gryffindor).
esDe(lunaLovegood, ravenclaw).
esDe(draco, slytherin).
esDe(hannahAbbott, hufflepuff).

%% se pide %%

%5
esBuenAlumno(Mago):- hizo(Mago,_),
	forall(hizo(Mago,Accion), esPositiva(Accion)).
	
esPositiva(Accion):- puntos(Accion, Puntos), Puntos >= 0.
	
puntos(fueraDeCama, -50).
puntos(irA(Lugar), Puntos):- lugarProhibido(Lugar, PuntosQueResta),
	Puntos is PuntosQueResta * -1.
puntos(irA(Lugar), 0):- not(lugarProhibido(Lugar, _)).

puntos(buenaAccion(_,Puntos), Puntos).

puntos(responder(Pregunta,Dificultad,Profesor), Puntos):-
	hizo(Mago, responder(Pregunta,Dificultad,Profesor)),
	coeficienteDeProfesor(Profesor,Mago,Coeficiente),
	Puntos is Dificultad * Coeficiente.
	
coeficienteDeProfesor(Profesor, Mago, 0):- alumnoOdiado(Profesor,Mago).
coeficienteDeProfesor(Profesor, Mago, 2):- alumnoFavorito(Profesor,Mago).
coeficienteDeProfesor(Profesor, Mago, 1):- not(alumnoFavorito(Profesor,Mago)), not(alumnoOdiado(Profesor,Mago)).
	
%6
puntosDeCasa(Casa, Total):- casa(Casa),
	findall(P, (esDe(Mago, Casa), puntosQueHizo(Mago, P)), Puntos),
	sumlist(Puntos, Total).
	
puntosQueHizo(Mago, Total):- mago(Mago,_,_),
	findall(P, (hizo(Mago, Accion), puntos(Accion, P)), Puntos),
	sumlist(Puntos, Total).
	
%7
casaGanadora(Casa):- puntosDeCasa(Casa, Puntos),
	forall((puntosDeCasa(Otra,P), Otra \= Casa), Puntos > P).