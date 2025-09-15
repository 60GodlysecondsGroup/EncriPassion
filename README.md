# EncriPassion

TRABAJO PARA GESTION DE BASES Y OPERACION DE BASES DE DATOS 
PROFESOR : PEDRO

OBJETIVOS: 
 1. Crear una GUI que permita el registro y inicio de sesion, estos datos tienen que ingresar a la base de datos y ser encriptados en ella.
 2. Debe tener una opcion de "ojito" que permita ver la contraseña encriptada, Imagino haciendo uso de una solicitud a la base de datos con las intrucciones correctas

La idea es el manejo de datos confidenciales 

Att. Juanes

# Uso Funciones de la Bases de Datos:

## f_login():
    Objetivo:
        Iniciar Sesion Con técnicas de Encriptacion 'crypt'
    Sintaxis: 
        f_login(parametro_nombre, parametro_password);
    Proceso:
        Los dos parametros deben ser Correctos para retornar TRUE.
        Sí no, Retornará un RAISE EXCEPTION
## f_login2():
    Objetivo:
        Iniciar Sesion Con técnicas de Encriptacion 'crypt'.
        Optimizar la funcion, Simplificando la lógica gracias al uso de EXISTS
    Sintaxis:
        f_login(parametro_nombre, parametro_password);
    Proceso:
        Los dos parametros deben ser Correctos para retornar TRUE.
        Sí no, Retornará FALSE
## f_show():
    Objetivo:
        Mostrar Registros Encriptados o DesEncriptados Según se Requiera
    Sintaxis:
        f_show(parametro_Numero);
    Proceso:
        Sí parametro_Numero = 1, Retornará Datos Encriptados
        Sí parametro_Numero = 2, Retornará Datos DesEncriptados


