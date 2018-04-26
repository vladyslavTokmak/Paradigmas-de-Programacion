module TP where

-- Punto 3.1
-- 3.1.1
data Microprocesador = UnMicro {
    acumA:: Int,
    acumB :: Int,
    memoriaDatos :: [Int],
    progCounter :: Int,
    etiquetaError :: String } deriving Show

-- 3.1.2

-- una memoria vacía son 1024 ceros
xt8088 = UnMicro {acumA = 0 , acumB = 0 , memoriaDatos = take 1024 (cycle [0]) , progCounter = 0, etiquetaError = "" }


-- Punto 3.2

-- 3.2.1
nop :: Microprocesador->Microprocesador
nop micro = micro { progCounter = aumentarPC micro}

aumentarPC :: Microprocesador->Int
aumentarPC micro = (progCounter micro) + 1

aumentarContador = nop


--3.2.2
tresNop :: Microprocesador->Microprocesador
tresNop = (nop.nop.nop)

-- En el caso de que se ingrese por consola directamente, seria de la siguiente manera:
-- TP> (nop.nop.nop) xt8088
-- UnMicro {a = 0, b = 0, memoriaDatos = [], progCounter = 3, etiquetaError = ""}

-- El concepto que interviene es el de composicion de funciones, el cual nos permite aplicar tres veces NOP
-- al microprocesador, ya que si simplemente ingresamos NOP por consola y le damos a Enter tres veces, 
-- el contador queda en 1 

-- Punto 3.3

-- 3.3.1
-- Evitar repetir código: reusen la función aumentarContador.
-- cambiar nombres a y b
-- sacar parentesis

lodv :: Int->Microprocesador->Microprocesador
lodv val micro = micro { acumA = val, progCounter = aumentarPC micro}

swap :: Microprocesador->Microprocesador
swap micro = aumentarContador micro {acumA = acumB micro , acumB = acumA micro}

add :: Microprocesador->Microprocesador
add micro = micro {acumA = acumA micro + acumB micro , acumB = 0 , progCounter = aumentarPC micro}

-- 3.3.2
sumarDosNumeros :: Int->Int->Microprocesador->Microprocesador
sumarDosNumeros num1 num2 micro = (add . lodv num2 . swap . lodv num1) micro


-- Punto 3.4

-- 3.4.1

str :: Int->Int->Microprocesador->Microprocesador
str addr val micro = micro {memoriaDatos = colocarEnLista addr val (memoriaDatos micro), progCounter = aumentarPC micro}

colocarEnLista :: Int->Int->[Int]->[Int]
colocarEnLista addr val lista = (take (addr-1) lista) ++ [val] ++ (drop addr lista)

divide :: Microprocesador->Microprocesador
divide micro |acumB micro == 0 = micro {etiquetaError = "DIVISION BY ZERO" , progCounter = aumentarPC micro}
             |otherwise = micro {acumA = div (acumA micro) (acumB micro) , acumB = 0, progCounter = aumentarPC micro}

indiceMemoria :: Int->Microprocesador->Int
indiceMemoria posicion micro = memoriaDatos micro !! posicion - 1

lod :: Int->Microprocesador->Microprocesador
lod posicion micro = micro {acumA = indiceMemoria posicion micro, progCounter = aumentarPC micro}

-- 3.4.2
dividir :: Int -> Int -> Microprocesador->Microprocesador
dividir num1 num2 micro = (divide. lod 1.swap.lod 2.str 2 num2.str 1 num1) micro

-- 5.1

at8086 = UnMicro {acumA = 0 , acumB = 0 , memoriaDatos = [1..20] , progCounter = 0, etiquetaError = "" }
fp20 = UnMicro {acumA = 7 , acumB = 24 , memoriaDatos = take 1024 (cycle [0]) , progCounter = 0, etiquetaError = "" }

programCounter :: Microprocesador->Int
programCounter = progCounter 

acumuladorA :: Microprocesador->Int
acumuladorA = acumA 

acumuladorB :: Microprocesador->Int
acumuladorB = acumB

memoria :: Microprocesador->[Int]
memoria = memoriaDatos

mensajeError :: Microprocesador->String
mensajeError = etiquetaError





