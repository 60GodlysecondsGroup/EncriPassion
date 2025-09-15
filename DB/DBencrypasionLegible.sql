-- LLamado de Extension pgcrypto
CREATE EXTENSION IF NOT EXISTS pgcrypto;

/*
Creacion Tabla Usuarios
pwd -> Encriptada gracias a la funcion crypt
*/
CREATE TABLE USERS(
	id_user INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	nombre TEXT,
	pwd TEXT
);

/*
Creacion Tabla Show_users
email y celular encriptada gracias a la extencion pgcryto
*/
CREATE TABLE SHOW_USER(
	cedula INTEGER,
	nombre TEXT,
	email BYTEA,
	celular BYTEA
);

-- Funcion LogIn
CREATE OR REPLACE FUNCTION f_Login(
	v_nombre TEXT,
	v_pwd TEXT
)
-- Retornar Verdadero o Falso
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
DECLARE
	-- Objetivo: Verificar que exista el registro segun los parametros nombre y pwd
	v_verificador INTEGER;
BEGIN
	-- Query Consultar el Registro Correspondiente
	SELECT U.id_user
	-- Obtencion Id_User en variable v_verificador
	INTO v_verificador
	FROM USERS AS U
	WHERE U.nombre = v_nombre
	/*
	Comparar Passwords Encriptadas
	parametro_1 -> Dato de Llegada (Dato que va a ser encriptado)
	parametro_2 -> Dato ya Encriptado
	Sintaxis: crypt(parametro_1, parametro_2)
	*/
	AND U.pwd = crypt(v_pwd, U.pwd);

	-- Condicional Para Saber Si los Datos Fueron Coincidentes o No
	IF v_verificador IS NULL THEN
		-- Informar al Sistema del Error
		RAISE EXCEPTION 'USUSARIO O CONTRASEÑA INCORRECTO';
	END IF;

	-- Retornar True (Proceso Exitoso)
	RETURN TRUE;
END;
$$ ;

/*
Objetivo -> Optimizar Funcion LogIn
*/
CREATE OR REPLACE FUNCTION f_login2(
	v_nombre TEXT,
	v_pwd TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
BEGIN
	/*
		EXISTS -> Retorna True o False Segun la SubConsulta
	*/
	RETURN EXISTS (
		SELECT 
		/*
		 No Importa Que Atributo se Solicite, Solo Se va a tener en cuenta el True o False,
		 Retornar '1' Es Ligeramente mas Eficiente
		 Se puede Poner '*'
		*/
		1
		FROM USERS AS U
		WHERE U.nombre = v_nombre
		AND U.pwd = crypt(v_pwd, U.pwd)
	);
END;
$$ ;

/*
Objetivo -> Retornar Query con Datos Encriptados o DesEncriptados
*/
CREATE OR REPLACE FUNCTION f_show(v_switch INTEGER)
RETURNS TABLE (
	cedula INTEGER,
	nombre TEXT,
	email TEXT,
	celular TEXT
)
LANGUAGE plpgsql AS $$
BEGIN 
		IF v_switch = 1 THEN
			RETURN QUERY 
				SELECT
				SU.CEDULA,
				SU.NOMBRE,
				/*
				Mostrar Data Encriptada
				encode(Dato, 'base64')
				'base64' -> algoritmo que pasa Datos BYTEA a TEXT
				*/
				encode(SU.EMAIL, 'base64'),
				encode(SU.CELULAR, 'base64')
				FROM SHOW_USER AS SU;
		ELSEIF v_switch = 2 THEN
			RETURN QUERY
				SELECT
				SU.CEDULA,
				SU.NOMBRE,
				/*
				Mostrar Data Desencriptada
				pgp_sym_decrypt(Dato, Clave)
				Uso de Misma Clave con la cual se Encripto anteriormente
				*/
				pgp_sym_decrypt(SU.EMAIL, 'PassDesEncriptador'),
				pgp_sym_decrypt(SU.CELULAR, 'PassDesEncriptador')
				FROM SHOW_USER AS SU;
		END IF;
END;
$$ ;


-- Pruebas

-- Insertar Data en SHOW_USER
INSERT INTO SHOW_USER(CEDULA, NOMBRE, EMAIL, CELULAR)
VALUES (123, 'Cristian', pgp_sym_encrypt('bsk@gmail.com', 'PassDesEncriptador'), pgp_sym_encrypt('310310', 'PassDesEncriptador'));

-- Insertar Data en USERS
INSERT INTO USERS(NOMBRE, PWD)
VALUES('Cristian', crypt('123', gen_salt('bf')));

-- Consulta con Data Encriptada
SELECT
SU.CEDULA,
SU.NOMBRE,
encode(SU.EMAIL, 'base64'),
encode(SU.CELULAR, 'base64')
FROM SHOW_USER AS SU;

-- Consulta con Data Desencriptada
SELECT
SU.CEDULA,
SU.NOMBRE,
pgp_sym_decrypt(SU.EMAIL, 'PassDesEncriptador'),
pgp_sym_decrypt(SU.CELULAR, 'PassDesEncriptador')
FROM SHOW_USER AS SU;

-- Uso de Funcion f_show()
SELECT * FROM f_show(2);

-- Uso de Funcion f_login()
SELECT f_login('Cristian', '123');
-- Uso de Funcion Optimizada f_login2()
SELECT f_login2('Cristian', '123');

