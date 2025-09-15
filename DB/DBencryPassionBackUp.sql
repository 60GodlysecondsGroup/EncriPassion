--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-09-15 17:40:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 258 (class 1255 OID 16873)
-- Name: f_login(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_login(v_nombre text, v_pwd text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.f_login(v_nombre text, v_pwd text) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 16878)
-- Name: f_login2(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_login2(v_nombre text, v_pwd text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.f_login2(v_nombre text, v_pwd text) OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 16872)
-- Name: f_show(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_show(v_switch integer) RETURNS TABLE(cedula integer, nombre text, email text, celular text)
    LANGUAGE plpgsql
    AS $$
BEGIN 
		IF v_switch = 1 THEN
			RETURN QUERY 
				SELECT
				SU.CEDULA,
				SU.NOMBRE,
				encode(SU.EMAIL, 'base64'),
				encode(SU.CELULAR, 'base64')
				FROM SHOW_USER AS SU;
		ELSEIF v_switch = 2 THEN
			RETURN QUERY
				SELECT
				SU.CEDULA,
				SU.NOMBRE,
				pgp_sym_decrypt(SU.EMAIL, 'PassDesEncriptador'),
				pgp_sym_decrypt(SU.CELULAR, 'PassDesEncriptador')
				FROM SHOW_USER AS SU;
		END IF;
END;
$$;


ALTER FUNCTION public.f_show(v_switch integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16867)
-- Name: show_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.show_user (
    cedula integer,
    nombre text,
    email bytea,
    celular bytea
);


ALTER TABLE public.show_user OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16860)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id_user integer NOT NULL,
    nombre text,
    pwd text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16859)
-- Name: users_id_user_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN id_user ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4935 (class 0 OID 16867)
-- Dependencies: 220
-- Data for Name: show_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.show_user VALUES (123, 'Cristian', '\xc30d040703026017e425de6701677cd23e0191646ea3732ac3277798ea215fd5eec243500fde8e1e6d7cf110a938fc43a1761bbb73f5a555a2a3d9062f5974502c2ca17f4be919d32ac0c9446552d9', '\xc30d04070302782df2f4bf27aa9c6ed23701ac46427873da6268b45d4a5da7bd0be84244f241cc4c98061b7a128773df471d3de4bdbee1a1a2c981e6c9b15442ad1688fbdd6ca4d1');


--
-- TOC entry 4934 (class 0 OID 16860)
-- Dependencies: 219
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users OVERRIDING SYSTEM VALUE VALUES (2, 'Cristian', '$2a$06$frlHGGFLvi/212oa0KTGrO/XCTqQi2zoFejZhY6DB4w/yQDGL7LAe');


--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 218
-- Name: users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_user_seq', 2, true);


--
-- TOC entry 4787 (class 2606 OID 16866)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


-- Completed on 2025-09-15 17:40:43

--
-- PostgreSQL database dump complete
--

