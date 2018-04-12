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

-- Frodo y su anillo
frodo :: Hobbit
frodo = UnHobbit { nombre = "Frodo", estatura = 106, salud = 10, fuerza = 50, deComarca = True, anillo = anilloUnico }

anilloUnico :: Anillo
anilloUnico = UnAnillo { peso = 12, frase = "Un Anillo para gobernarlos a todos. Un Anillo para encontrarlos, un Anillo para atraerlos a todos y atarlos en las tinieblas." }

-- Otro hobbit y su anilo
aradun :: Hobbit
aradun = UnHobbit { nombre = "Aradun", estatura = 100, salud = 15, fuerza = 82, deComarca = False, anillo = anilloDeAradun }

anilloDeAradun :: Anillo
anilloDeAradun = UnAnillo { peso = 5, frase = "No soy hombre de plegarias, pero si estas en el cielo, Salvame Superman." }

-- Otro anillo
anilloExtranio :: Anillo
anilloExtranio = UnAnillo { peso = 10, frase = "Actuamos en las sombras, para servir a la luz. Nada es verdad, todo esta permitido. Somos Asesinos." }

-- Calcula poder de anillo
poderDeAnillo :: Anillo -> Int
poderDeAnillo anillo = peso anillo * length(frase anillo)

-- Calcula resistencia de un hobbit de la comarca
calcPoderHobbitComarca :: Hobbit -> Int
calcPoderHobbitComarca hobbit = (estatura hobbit * salud hobbit + fuerza hobbit )

-- Calcula la resistencia de un hobbit que no pertenese a la comarca
calcPoderHobbitNoComarca :: Hobbit -> Int
calcPoderHobbitNoComarca hobbit = (salud hobbit * fuerza hobbit)

-- Determina si el nombre del hobbit comieza con False
comienzaConF :: Hobbit -> Bool
comienzaConF hobbit = head(nombre hobbit) == 'F'

-- Determina el poder del anillo de un hobbit
poderAnilloDeHobbit :: Hobbit -> Int
poderAnilloDeHobbit = poderDeAnillo.anillo

-- Determina la resistencia total de un hobbit 
poderDeHobbit :: Hobbit -> Int
poderDeHobbit hobbit | (deComarca hobbit == True) && comienzaConF hobbit =  max 0 (( calcPoderHobbitComarca hobbit + 10 ) - poderAnilloDeHobbit hobbit)
                     | (deComarca hobbit == True) && comienzaConF hobbit = max 0 (calcPoderHobbitComarca hobbit - poderAnilloDeHobbit hobbit)
                     | (deComarca hobbit == False) && comienzaConF hobbit = max 0 (( calcPoderHobbitNoComarca hobbit + 10 ) - poderAnilloDeHobbit hobbit)
                     | otherwise = max 0 (calcPoderHobbitNoComarca hobbit - poderAnilloDeHobbit hobbit)

--Permite que un hobbit cambie su anillo por otro
cambiarDeAnillo :: Hobbit -> Anillo -> Hobbit
cambiarDeAnillo hobbit otroAnillo = hobbit { anillo = otroAnillo }

-- Comidas
desayuno :: Comidas
desayuno = UnaComida { nombreComida = "desayuno" ,hagregarNombre = "Errrp" , hagregarSalud = 5 , hagregarFuerza = 0}

segundoDesayuno :: Comidas
segundoDesayuno = UnaComida { nombreComida = "segundoDesayuno", hagregarNombre = "" , hagregarSalud = 0 , hagregarFuerza = 4}

merienda :: Comidas
merienda = UnaComida { nombreComida = "merienda", hagregarNombre = "Errrp" , hagregarSalud = 5 , hagregarFuerza = 4}

-- Estadisticas de hobbit luego de merendar
hobbitMerienda :: Hobbit -> ManzanasAragon -> Hobbit
hobbitMerienda hobbit manzanasAragon = hobbit { nombre = "Errrp" ++ nombre hobbit, salud = salud hobbit + 5, fuerza = fuerza hobbit + (4 * manzanasAragon) }

poderHobbitComido :: Hobbit -> ManzanasAragon -> Int
poderHobbitComido hobbit  = (poderDeHobbit).(hobbitMerienda hobbit)

-- Determinar que hobbit tiene mas resistencia luego de merendar
quienTieneMasResistencia :: Hobbit -> Hobbit -> ManzanasAragon -> String
quienTieneMasResistencia hobbit otroHobbit manzanasAragon | poderHobbitComido hobbit manzanasAragon > poderHobbitComido otroHobbit manzanasAragon = nombre hobbit
                                                          | otherwise = nombre otroHobbit
