%-------------------------------------------PRIMERA ENTREGA--------------------------------------------------------------------
/* Punto 3
Puedo hacer consultas tanto existenciales como individuales dado que el predicado es inversible
%paso es un predicado inversible porque en sus hechos no hay variables
%Entonces esSpoiler al relacionarse con paso liga las variables Serie y Hecho, haciendo que este también sea inversible
*/

esSpoiler(Serie,Hecho) :- paso(Serie,_,_,Hecho).

%paso(Serie, Temporada, Episodio, Lo que paso)
paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).
paso(got,3,2,plotTwist([suenio, sinPiernas])).
paso(got,3,12,plotTwist([fuego, boda])).
paso(superCampeones,9,9,plotTwist([suenio, coma, sinPiernas])).
paso(drHouse,8,7,plotTwist([coma,pastillas])).

%Punto 4
%Puedo hacer consultas tanto existenciales como individuales dado que el predicado es inversible.
%leSpoileo liga las variables Spoileador,Spoileado y Serie con leDijo que es inversible porque en sus hechos no hay variables,
%liga Serie y Hecho con esSpoiler que es inversible por la justificación del punto 3, y liga Spoileado y Serie con leInteresa
%que también es inversible por relacionarse con predicados inversibles.

leSpoileo(Spoileador,Spoileado,Serie) :- leInteresa(Spoileado,Serie), esSpoiler(Serie,Hecho), leDijo(Spoileador,Spoileado,Serie,Hecho).

leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)). 
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).
leDijo(nico,juan,futurama,muerte(seymourDiera)).
leDijo(pedro,aye,got,relacion(amistad,tyrion,dragon)).
leDijo(pedro,nico,got,relacion(parentesco,tyrion,dragon)).


leInteresa(Spoileado,Serie) :- miraSerie(Spoileado,Serie).
leInteresa(Spoileado,Serie) :- quiereVer(Spoileado,Serie).

%Como alf no ve ninguna serie, no lo incluyo en la base de conocimiento. Por el Principio de Universo Cerrado.
miraSerie(juan,himym).
miraSerie(juan,got).
miraSerie(juan,futurama).
miraSerie(maiu,starWars).
miraSerie(maiu,onePiece).
miraSerie(maiu,got).
miraSerie(nico,got).
miraSerie(nico,starWars).
miraSerie(gaston,hoc).
miraSerie(pedro,got).
quiereVer(juan,hoc).
quiereVer(aye,got).
quiereVer(gaston,himym).



%Punto 5
/*
Al agregar leInteresa(Persona,_) hago que el predicado sea inversible.
Esto es porque ligo la variable Persona involucrada en el predicado not(leSpoileo(Persona,_,_)).
O sea, le hago saber al motor el universo de personas.
*/


televidenteResponsable(Persona) :- leInteresa(Persona,_), not(leSpoileo(Persona,_,_)).

%Punto 6
vieneZafando(Persona,Serie) :- esFuerteoPopular(Serie), not(leSpoileo(_,Persona,Serie)), leInteresa(Persona,Serie).

esFuerteoPopular(Serie) :- esFuerte(Serie).
esFuerteoPopular(Serie) :- populares(Serie).


esFuerte(Serie) :- serie(Serie,Temporada,_), forall(serie(Serie,Temporada,_),fuerte(Serie)).

%serie(nombre,temporada,cantEpisodios)
serie(got,2,10).
serie(got,3,12).
serie(himym,1,23).
serie(drHouse,8,16).

%Si no recuerdo bien cant episodios de MadMen no lo incluyo en la base de Conocimentos.
%Por el Principio de Universo Cerrado.

fuerte(Serie) :- paso(Serie,_,_,relacion(amorosa,_,_)).
fuerte(Serie) :- paso(Serie,_,_,relacion(parentesco,_,_)).
fuerte(Serie) :- paso(Serie,_,_,muerte(_)).
fuerte(Giro):- finalDeTemporada(Giro), not(esCliche(Giro)).


%-----------------------------------------------------SEGUNDA ENTREGA----------------------------------------------------------
%Punto 1
malaGente(Persona) :- leSpoileo(Persona,_,Serie), not(miraSerie(Persona,Serie)).

malaGente(Persona):- leInteresa(Persona,_),forall(leInteresa(Victima,_),leSpoileo(Persona,Victima,_)).
%Conjunto de vicitimas a las que la persona le spoileo algo.


%Punto 2
esCliche(plotTwist(Giro)) :- paso(_,_,_,plotTwist(Giros)),
                             paso(_,_,_,plotTwist(Giro)),
							Giros \= Giro,
							findall(Giros,paso(_,_,_,plotTwist(Giros)),ListaDeGiros),
							flatten(ListaDeGiros,ListaDePalabras),
							intersection(Giro,ListaDePalabras,Giro).
											
%Al agregar la condicion Giros\=Giro estoy haciendo que el Giro que le paso sea distinto de los otros Giros.
%Despues se genera una lista con todos los otros giros.
%Si yo le paso un plotTwist la interseccion me debería dar la misma lista, sino no aparece en todos los demas giros.

%Punto 3
%Por el enunciado, sabemos que House of Cards es popular. Entonces lo agrego a la base de conocimiento.
popular(hoc).
popular(Serie) :- miraSerie(Persona,Serie),
                  leDijo(Persona,_,Serie,_),
                  conversadores(Persona,Serie,CantMiran,CantHablan),
                  puntaje(CantHablan,CantMiran,PuntajeSerie),
                  conversadores(Persona,starWars,CantMiranSW,CantHablanSW),
                  puntaje(CantMiranSW,CantHablanSW,PuntajeSW),
                  PuntajeSerie >= PuntajeSW.

%Primero agrego miraSerie y leDijo para saber quienes son los conversadores (Le hago saber al motor el universo de personas).
%Conversadores, de la forma en que definimos el predicado, puede ser reutilizado más abajo con star Wars;De esta forma nos
%ahorramos de hacer un predicado para conocer quienes hablan de StarWars. Lo mismo con puntaje.
				  
				  
conversadores(Persona,Serie,CantMiran,CantHablan):- findall(Persona,miraSerie(Persona,Serie),CantMiran),
                                                    findall(Persona,leDijo(Persona,_,Serie,_),CantHablan).
 
puntaje(CantMiran,CantHablan,Puntaje):- length(CantMiran,NumeroMiran), length(CantHablan,NumeroHablan),Puntaje is NumeroHablan*NumeroMiran.


%Punto 4
amigo(nico,maiu).
amigo(maiu,gaston).
amigo(maiu,juan).
amigo(juan,aye).

fullSpoil(Spoileador,Victima):- leSpoileo(Spoileador,Victima,_),Spoileador \= Victima.
fullSpoil(Spoileador,Victima):- amigo(Amigo,Victima), fullSpoil(Spoileador,Amigo), Victima \= Amigo, Spoileador \= Victima, Spoileador \= Amigo.