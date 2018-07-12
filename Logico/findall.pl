% Teniendo la conocida base de conocimientos (algo extendida):

padre(abbbbbbbbbbbe, abbbe).
padre(abbbe, abe).
padre(abe,homero).
padre(abe,herbert).
padre(homero,bart).
padre(homero,lisa).
padre(homero,maggie).

% Un ejemplo de predicado recursivo:
% El predicado ancestro/2, que relaciona dos personas si una es descendiente de la otra

ancestro(Ancestro, Descendiente):-
    padre(Ancestro,Descendiente).
ancestro(Ancestro, Descendiente):-
    padre(Ancestro,Viejo),
    ancestro(Viejo,Descendiente).

% Vemos que hay un caso base y un caso recursivo.

% Luego, con los productos:
% https://docs.google.com/document/d/1Lf_NpZISQkOlIsQlDPm1chQEgx5fcd2zthB3D_fvyQA/edit

producto(coto, lacteo, leche, 35).
producto(coto, galletita, oreo, 60).
producto(dia, lacteo, leche, 22).
producto(dia, lacteo, yoghurt, 30).
producto(dia, infusion, cafe, 70).
producto(dia, infusion, te, 30).
producto(dia, galletita, oreo, 45).

esBarato(Precio) :- Precio < 40.

%%%%%%%%%%%%%%%%%%%%%%
%%%% Punto 2
%%%%%%%%%%%%%%%%%%%%%%

% es cierto cuando los únicos productos baratos son los de ese tipo.
tieneDescuentoEspecial(Super,Tipo):-
	producto(Super,Tipo,_,_),
	% para todo producto barato del super (de cualquier tipo), se cumple que es del Tipo indicado por parámetro
	forall( (producto(Super,_,Producto,Precio), esBarato(Precio)) ,  producto(Super,Tipo,Producto,Precio)).

% Mejorando expresividad:
tieneDescuentoEspecialV2(Super,Tipo):-
		producto(Super,Tipo,_,_),
		forall( productoBaratoDe(Super,Producto,Precio), producto(Super,Tipo,Producto,Precio)).

productoBaratoDe(Super,Producto,Precio):- 
		producto(Super,_,Producto,Precio), esBarato(Precio).

% Con Not:
% No existe un producto barato que sea de un tipo distinto al dado
tieneDescuentoEspecialV3(Super,Tipo):-
		producto(Super,Tipo,_,_), 
		not(( producto(Super,Tipo2,_,Precio), esBarato(Precio), Tipo2 \= Tipo )).

%%%%%%%%%%%%%%%%%%%%%%
%%%% Punto 3
%%%%%%%%%%%%%%%%%%%%%%
% Leer la guía de lenguajes.

%%%%%%%%%%%%%%%%%%%%%%
%%%% Punto 4 y 5
%%%%%%%%%%%%%%%%%%%%%%

% Para "Juntar" en una lista, existe el findall:

cuantosProductosLacteosTiene(Super,Cuantos):-
	producto(Super,_,_,_),
	findall(Nombre, producto(Super,lacteo,Nombre,_), Productos),
	length(Productos,Cuantos).

% Importante entender que la consulta del medio del findall:
% producto(Super,lacteo,Nombre,_) 
% Es cierta si Nombre es el nombre de un lácteo de ese Super.
% Entonces, todos los Nombre estarán en la lista Productos.

% Si ponemos una variable anónima en donde dice "lacteo" dentro del findall de 
% arriba, el predicado se transforma en el punto 4: "cuantosProductosTiene".

%%%%%%%%%%%%%%%%%%%%%%
%%%% Punto 6
%%%%%%%%%%%%%%%%%%%%%%

quiereComprar(pepe,leche).
quiereComprar(pepe,oreo).
quiereComprar(ana,cafe).

% Este predicado se puede armar delegando, ó se puede hacer un "y"

% Delegando:

gastoEnSuper(Super, Persona, Monto):-
	supermercado(Super),
	persona(Persona),
	findall(Precio,precioDeLoQueQuiere(Super,Persona,Precio),Precios),
	sum_list(Precios,Monto).

supermercado(Super) :-
	producto(Super,_,_,_).

persona(Persona):-
	quiereComprar(Persona,_).

precioDeLoQueQuiere(Super,Persona,Precio):-
	producto(Super,_,Nombre,Precio),
	quiereComprar(Persona,Nombre).


% Con un "y"
gastoEnSuperV2(Super, Persona, Monto):-
		supermercado(Super),
		persona(Persona),
        findall(Precio, (producto(Super,_,Nombre,Precio), quiereComprar(Persona,Nombre)),Precios),
        sum_list(Precios,Monto).

% Ponerles nombre a los generadores (en este caso "supermercado") mejora mucho la expresividad.

%%%%%%%%%%%%%%%%%%%%%%
%%%% Punto 7
%%%%%%%%%%%%%%%%%%%%%%

% meAlcanzaPaRatonear/2 Relaciona un super y un monto, y da cierto cuando ese monto alcanza para comprar todos los productos baratos del super
meAlcanzaPaRatonear(Super,Monto):-
	sumaDeBaratos(Super,Total),
	Monto >= Total.

sumaDeBaratos(Super,Total):-
	findall(Precio, productoBaratoDe(Super,_,Precio), PreciosBaratos),
	sum_list(PreciosBaratos, Total).