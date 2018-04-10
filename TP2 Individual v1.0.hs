{-
	Nombre y apellido: Vladysalv Tokmak
	Curso: K2004
-}

type ManzanasAragon = Int

data Hobbit = UnHobbit {
    nombre :: String,
    estatura :: Int,
    salud :: Int,
    fuerza :: Int,
    deComarca :: Bool,
    anillo :: Anillo} deriving Show

data Anillo = UnAnillo {
    peso :: Int,
    frase :: String } deriving Show

data Comidas = UnaComida {
    nombreComida :: String,
    hagregarNombre :: String,
    hagregarSalud :: Int,
    hagregarFuerza ::Int} deriving Show

--Frodo y su anillo--------------------------------------------------------------------------------------------------------
frodo :: Hobbit
frodo = UnHobbit { nombre = "Frodo", estatura = 106, salud = 10, fuerza = 50, deComarca = True, anillo = anilloUnico }

anilloUnico :: Anillo
anilloUnico = UnAnillo { peso = 12, frase = "Un Anillo para gobernarlos a todos. Un Anillo para encontrarlos, un Anillo para atraerlos a todos y atarlos en las tinieblas." }

--Aradum y su anillo--------------------------------------------------------------------------------------------------------
aradun :: Hobbit
aradun = UnHobbit { nombre = "Aradun", estatura = 100, salud = 15, fuerza = 82, deComarca = False, anillo = anilloDeSam }

anilloDeSam :: Anillo
anilloDeSam = UnAnillo { peso = 5, frase = "No soy hombre de plegarias, pero si estas en el cielo, Salvame Superman." }

--Anillo extra--------------------------------------------------------------------------------------------------------
anilloExtranio :: Anillo
anilloExtranio = UnAnillo { peso = 10, frase = "Actuamos en las sombras, para servir a la luz. Nada es verdad, todo esta permitido. Somos Asesinos." }

--Calcular poder del anillo--------------------------------------------------------------------------------------------------------
poderDeAnillo :: Anillo -> Int
poderDeAnillo anillo = (peso anillo) * (length (frase anillo))

--Calcula el poder del anillo de un hobbit ------------------------------------------------------------------------------------------------------
poderAnilloDeHobbit :: Hobbit -> Int
poderAnilloDeHobbit hobbit = (peso (anillo hobbit)) * (length (frase (anillo hobbit)))

--Calcular fuerza de un hobbit de la comarca--------------------------------------------------------------------------------------------------------
calcPoderHobbitComarca :: Hobbit -> Int
calcPoderHobbitComarca hobbit = (estatura hobbit * salud hobbit + fuerza hobbit)

--Calcular fuerza de un hobbit no de la comarca--------------------------------------------------------------------------------------------------------
calcPoderHobbitNoComarca :: Hobbit -> Int
calcPoderHobbitNoComarca hobbit = (salud hobbit * fuerza hobbit)


--Determina si el nombre del hobbit comienza con la letra F -------------------------------------------------------------------------
comienzaConF :: Hobbit -> Bool
comienzaConF hobbit = head(nombre hobbit) == 'F'

--Determina la resistencia de un hobbit -------------------------------------------------------------------------------
poderDeHobbit :: Hobbit -> Int
poderDeHobbit hobbit | (deComarca hobbit == True) && comienzaConF hobbit =  max 0 (( calcPoderHobbitComarca hobbit + 10 ) - poderAnilloDeHobbit hobbit)
                     | (deComarca hobbit == True) && comienzaConF hobbit = max 0 (calcPoderHobbitComarca hobbit - poderAnilloDeHobbit hobbit)
                     | (deComarca hobbit == False) && comienzaConF hobbit = max 0 (( calcPoderHobbitNoComarca hobbit + 10 ) - poderAnilloDeHobbit hobbit)
                     | otherwise = max 0 (calcPoderHobbitNoComarca hobbit - poderAnilloDeHobbit hobbit)

--Permite que un hobbit cambie su anillo por otro
cambiarDeAnillo :: Hobbit -> Anillo -> Hobbit
cambiarDeAnillo hobbit otroAnillo = hobbit { anillo = otroAnillo }

desayuno :: Comidas
desayuno = UnaComida { nombreComida = "desayuno" ,hagregarNombre = "Errrp" , hagregarSalud = 5 , hagregarFuerza = 0}

segundoDesayuno :: Comidas
segundoDesayuno = UnaComida { nombreComida = "segundoDesayuno", hagregarNombre = "" , hagregarSalud = 0 , hagregarFuerza = 4}

merienda :: Comidas
merienda = UnaComida { nombreComida = "merienda", hagregarNombre = "Errrp" , hagregarSalud = 5 , hagregarFuerza = 4}


hobbitComer :: Hobbit -> Comidas -> ManzanasAragon -> Hobbit
hobbitComer hobbit comida manzanasAragon | nombreComida comida == "desayuno" = hobbit { nombre = hagregarNombre comida ++ nombre hobbit, salud = salud hobbit + hagregarSalud comida}
                                         | nombreComida comida == "segundoDesayuno" = hobbit { fuerza = fuerza hobbit + (hagregarFuerza comida * manzanasAragon)}
                                         | otherwise = hobbit { nombre = hagregarNombre comida ++ nombre hobbit, salud = salud hobbit + hagregarSalud comida, fuerza = fuerza hobbit + (hagregarFuerza comida * manzanasAragon) }


poderHobbitComido :: Hobbit -> Comidas -> ManzanasAragon -> Int
poderHobbitComido hobbit comida manzanasAragon = poderDeHobbit (hobbitComer hobbit comida manzanasAragon)


--Cual hobbit tiene mas resistencia luego de comer ---------------------------------------------------------------------
quienTieneMasResistencia :: Hobbit -> Hobbit -> Comidas -> ManzanasAragon -> String
quienTieneMasResistencia hobbit otroHobbit comidas manzanasAragon | poderHobbitComido hobbit comidas manzanasAragon > poderHobbitComido otroHobbit comidas manzanasAragon = nombre hobbit
                                                                  | otherwise = nombre otroHobbit
