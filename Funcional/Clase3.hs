import Text.Show.Functions

-- Alias de tipo:
type  Discurso = String
type Plata = Int
type AnalizadorNumerico = Int -> Bool

venderAlfajores  :: Int -> Plata -> Plata
venderAlfajores cantidadPaquetes precioPaquete = cantidadPaquetes * precioPaquete

venderAlfajoresHaciendoPrecio  :: Int -> Plata -> Plata -> Plata
venderAlfajoresHaciendoPrecio cantidadPaquetes precioPaquete descuento = venderAlfajores cantidadPaquetes (precioPaquete-descuento)

diferencia :: Discurso -> Discurso -> Int
diferencia unDiscurso otroDiscurso = length unDiscurso - length otroDiscurso

entre :: Int -> Int -> Int -> Bool
entre chico grande medio = medio >= chico && medio <= grande

--esPar :: Int -> Bool
esPar :: AnalizadorNumerico
esPar = even

esImpar :: Int -> Bool
esImpar = not.esPar 

esCorto :: Discurso -> Bool
esCorto = (<50).length
--esCorto discurso = length discurso < 50

anioActual :: Int
anioActual = 2018

--(>) :: Int -> Int -> Bool

--absoluto = abs
--otherwise = True

absoluto :: Int -> Int
absoluto nro |  nro < 0 = 0 - nro
             |  otherwise = nro

signo :: Int -> String
signo nro | nro < 0 = "negativo"
          | nro > 0 = "positivo"
          | otherwise = "cero"


-- Un discurso es aceptable cuando la diferencia con "es una verdadera gangaaaa" está entre 5 y 10 (tanto más largo ó más corto)

-- Sin composición:
-- esAceptable discurso = entre 5 10 (abs (diferencia "es una verdadera gangaaaa" discurso))

-- Con composición y funciones auxiliares:
--esAceptable = entreCincoYDiez . abs . diferenciaGangaa

-- Con composición y sin funciones auxiliares: ¡Aplicación parcial!
esAceptable :: Discurso -> Bool
esAceptable = (entre 5 10) . abs . (diferencia "es una verdadera gangaaaa")

dobleDelSiguiente :: Int -> Int
dobleDelSiguiente = (*2).(+1)

comienzaConP :: String -> Bool
comienzaConP = (=='p').head

------------------------------------------------------
-- Tuplas:
-- quedaLejos si la calle es mozart ó la altura es mayor a 10000.
-- estaALaIzquierda si la altura es impar.

quedaLejos :: (String,Int) -> Bool
quedaLejos direccion = fst direccion == "Mozart" || snd direccion >= 10000
--quedaLejos (calle,altura) = calle == "Mozart" || altura >= 10000

-- Así el tipo tupla es más expresivo ¡con un alias de tipo!
type Direccion = (String,Int)
estaALaIzquierda :: Direccion -> Bool
estaALaIzquierda = esImpar.snd

type Fecha = (Int,Int,Int)
anio (a,m,d) = a
mes  (a,m,d) = m
dia (a,m,d) = d


-- Mis estructuras: (Data)
data Inquilino = UnInquilino {nombre::String, 
                          fechaNac::Fecha, 
                          tieneTrabajo::Bool} deriving Show

data Alquiler = UnAlquiler {fechaInicio::Fecha, 
                              fechaFin::Fecha,
                                 cuota::Int,
                             inquilino::Inquilino,
                             direccion::Direccion} deriving Show

gus :: Inquilino
gus = UnInquilino {nombre = "Gus", fechaNac = (1995,04,08), tieneTrabajo = True}

medrano :: Direccion
medrano = ("Medrano",951)

casaGus :: Alquiler
casaGus = UnAlquiler {fechaInicio = (2017,01,01), fechaFin = (2018,04,31), cuota = 13000, inquilino = gus , direccion = medrano}

esCaro :: Alquiler -> Bool
esCaro alquiler = cuota alquiler > 10000
-- Con composición:
-- esCaro = (>10000).cuota

terminoElAlquiler :: Alquiler -> Bool
terminoElAlquiler alquiler = anio (fechaFin alquiler) < anioActual

renovarCuota :: Alquiler -> Int -> Alquiler
renovarCuota alqui cuoti = alqui {cuota = cuoti, fechaFin = (anioActual+2, 1,1)}

-- Otra forma de hacerlo, indirecta:
-- renovarCuota alqui cuoti = UnAlquiler {fechaInicio=fechaInicio alqui, fechaFin = (anioActual + 2, 1, 1), cuota = cuoti, inquilino = inquilino alqui, direccion = direccion alqui}