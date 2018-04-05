determinarTipoAnio::Int->Bool

determinarTipoAnio anio = ( (mod anio 4 == 0) || ( (mod anio 100 == 0) && (mod anio 400 == 0) ) )

saberTipoAnio::Int->String

saberTipoAnio anio = if determinarTipoAnio anio then "Este anio es bisiesto" else "Este anio no es bisiesto"

saberDiasDeAnio::Int->String

saberDiasDeAnio anio = if determinarTipoAnio anio then "Este anio tiene 366 dias" else "Este anio tiene 365 dias"
