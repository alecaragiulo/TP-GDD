USE [GD2C2023]
GO

CREATE SCHEMA [GEDIENTOS_27]
GO

CREATE PROCEDURE GEDIENTOS_27.migrarDatos
AS
BEGIN 
	BEGIN TRANSACTION
	------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------------------------										CREATES																------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------------------------

	----------------------------
	--------- ANUNCIOS ---------
	----------------------------
	CREATE TABLE Provincia (
		provincia_id INT IDENTITY(1,1) PRIMARY KEY,
		nombre	VARCHAR(255)
	);
	---------------------------
	CREATE TABLE Localidad (
		localidad_id INT IDENTITY(1,1) PRIMARY KEY,
		nombre	VARCHAR(255),
		provincia_id INT REFERENCES Provincia(provincia_id)
	);
	---------------------------
	CREATE TABLE Barrio (
		barrio_id INT IDENTITY(1,1) PRIMARY KEY,
		nombre	VARCHAR(255),
		localidad_id INT REFERENCES Localidad(localidad_id)
	);
	---------------------------
	CREATE TABLE Sucursal (
		sucursal_id INT IDENTITY(1,1) PRIMARY KEY,
		nombre VARCHAR(255),
		localidad_id INT REFERENCES Localidad(localidad_id),
		direccion VARCHAR(255),
		telefono NUMERIC
	);
	---------------------------
	CREATE TABLE Agente (
		agente_id INT IDENTITY(1,1) PRIMARY KEY,
		nombre VARCHAR(255),
		apellido VARCHAR(255),
		dni NUMERIC,
		fecha_registro DATETIME,
		telefono NUMERIC,
		mail VARCHAR(255),
		fecha_nacimiento DATETIME,
		sucursal_id INT REFERENCES Sucursal(sucursal_id) 
	);
	---------------------------
	CREATE TABLE Operacion (
		operacion_id INT IDENTITY(1,1) PRIMARY KEY,
		tipo	VARCHAR(255),
	);
	---------------------------
	CREATE TABLE Estado_anuncio (
		estado_anuncio_id INT IDENTITY(1,1) PRIMARY KEY,
		tipo	VARCHAR(255),
	);
	---------------------------
	CREATE TABLE Moneda (
		moneda_id INT IDENTITY(1,1) PRIMARY KEY,
		tipo	VARCHAR(255)
	);
	---------------------------
	CREATE TABLE Periodo (
		periodo_id INT IDENTITY(1,1) PRIMARY KEY,
		tipo	VARCHAR(255),
	);

	----------------------------
	--------- INMBUEBLE --------
	----------------------------
	CREATE TABLE Tipo_inmueble (
		tipo_inmueble_id INT IDENTITY(1,1) PRIMARY KEY,
		tipo	VARCHAR(255)
	);
	---------------------------
	CREATE TABLE Propietario (
		propietario_id INT IDENTITY(1,1) PRIMARY KEY,
		nombre VARCHAR(255),
		apellido VARCHAR(255),
		dni NUMERIC,
		fecha_registro DATETIME,
		telefono NUMERIC,
		mail VARCHAR(255),
		fecha_nacimiento DATETIME
	);

	---------------------------

	CREATE TABLE Estado_inmueble (
		estado_inmueble_id INT IDENTITY(1,1) PRIMARY KEY,
		tipo	VARCHAR(255)
	);
	---------------------------
	CREATE TABLE Ambiente (
		ambiente_id INT IDENTITY(1,1) PRIMARY KEY,
		tipo	VARCHAR(255)
	);
	---------------------------
	CREATE TABLE Caracteristicas (
		caracteristicas_id INT IDENTITY(1,1) PRIMARY KEY,
		descripcion	VARCHAR(255)
	);
	---------------------------
	CREATE TABLE Orientacion (
		orientacion_id INT IDENTITY(1,1) PRIMARY KEY,
		tipo	VARCHAR(255),
	);
	---------------------------
	CREATE TABLE Disposicion (
		disposicion_id INT IDENTITY(1,1) PRIMARY KEY,
		tipo	VARCHAR(255),
	);
	---------------------------
	CREATE TABLE Inmueble (
		inmueble_id INT IDENTITY(1,1) PRIMARY KEY,
		tipo_inmueble_id INT REFERENCES Tipo_inmueble(tipo_inmueble_id),
		descripcion VARCHAR(255),
		propietario_id INT REFERENCES Propietario(propietario_id),
		direccion VARCHAR(255),
		barrio_id INT REFERENCES Barrio(barrio_id),
		ambiente_id INT REFERENCES Ambiente(ambiente_id), 
		superficie NUMERIC,
		disposicion_id INT REFERENCES Disposicion(disposicion_id),
		orientacion_id INT REFERENCES Orientacion(orientacion_id),
		estado_inmueble_id INT REFERENCES Estado_inmueble(estado_inmueble_id),
		antiguedad NUMERIC,
		caracteristica_id INT REFERENCES Caracteristicas(caracteristicas_id), 
		expensas NUMERIC
	);

	---------------------------
	CREATE TABLE Inmueble_Ambiente (
		inmueble_id INT,
		ambiente_id INT,
		PRIMARY KEY (inmueble_id, ambiente_id),
		FOREIGN KEY (inmueble_id) REFERENCES Inmueble(inmueble_id),
		FOREIGN KEY (ambiente_id) REFERENCES Ambiente(ambiente_id)
	);

	------------------------
	CREATE TABLE Inmuebles_Caracteristicas (
		inmuebles_id INT,
		caracteristicas_id INT,
		PRIMARY KEY (inmuebles_id, caracteristicas_id),
		FOREIGN KEY (inmuebles_id) REFERENCES Inmueble(inmueble_id),
		FOREIGN KEY (caracteristicas_id) REFERENCES Caracteristicas(caracteristicas_id)
	);

	------------------------
	CREATE TABLE Anuncios (
		anuncio_id INT IDENTITY(1,1) PRIMARY KEY,
		fecha_publicacion DATETIME,
		agente_id INT REFERENCES Agente(agente_id),
		operacion_id INT REFERENCES Operacion(operacion_id),
		inmueble_id INT REFERENCES Inmueble(inmueble_id),
		anuncio_precio NUMERIC,
		moneda_id INT REFERENCES Moneda(moneda_id),
		periodo_id DATETIME,
		estado_anuncio_id INT REFERENCES Estado_anuncio(estado_anuncio_id),
		fecha_finalizacion DATETIME,
		costo_publicacion NUMERIC,
		precio_publicacion_inmueble NUMERIC
	);

	--------------------------
	--------- VENTAS ---------
	--------------------------

	CREATE TABLE Comprador (
		comprador_id INT IDENTITY(1,1) PRIMARY KEY,
		nombre	VARCHAR(255),
		apellido	VARCHAR(255),
		dni		NUMERIC,
	);
	---------------------------
	CREATE TABLE Medio_Pago (
		medio_pago_id INT IDENTITY(1,1) PRIMARY KEY,
		medio	VARCHAR(255),
	);
	---------------------------
	CREATE TABLE Pago (
		pago_id INT IDENTITY(1,1) PRIMARY KEY,
		importe NUMERIC,
		moneda_id INT REFERENCES Moneda (moneda_id),
		medio_pago_id INT REFERENCES Medio_Pago (medio_pago_id),
		cotizacion NUMERIC
	);
	---------------------------
	CREATE TABLE Ventas (
		venta_id INT IDENTITY(1,1) PRIMARY KEY,
		anuncio_id INT REFERENCES Anuncios (anuncio_id),
		comprador_id INT REFERENCES Comprador (comprador_id),
		fecha_venta DATETIME,
		precio_venta NUMERIC,
		moneda_id INT REFERENCES Moneda (moneda_id),
		comision_inmobiliaria INT,
		pago_id INT REFERENCES Pago (pago_id),
	);

	----------------------------
	--------- ALQUILER ---------
	----------------------------

	CREATE TABLE Estado_alquiler (
		estado_alquiler_id INT IDENTITY(1,1) PRIMARY KEY,
		tipo	VARCHAR(255),
	);
	---------------------------
	CREATE TABLE Inquilino (
		inquilino_id	INT IDENTITY(1,1) PRIMARY KEY,
		nombre	VARCHAR(255),
		apellido	VARCHAR(255),
		dni		NUMERIC,
		mail	VARCHAR(255),
		telefono	NUMERIC(18,0),
		fecha_nac	DATETIME,
		fecha_registro	DATETIME

	);

	---------------------------
	CREATE TABLE Alquiler (
		alquiler_id INT IDENTITY(1,1) PRIMARY KEY, 
		anuncio_id INT REFERENCES Anuncios (anuncio_id),
		inquilino_id INT REFERENCES Inquilino (inquilino_id),
		fecha_inicio DATETIME,
		fecha_final DATETIME,
		duracion NUMERIC,
		deposito NUMERIC,
		comision NUMERIC,
		gastos_averiguaciones NUMERIC,
		estado_alquiler_id INT REFERENCES Estado_alquiler (estado_alquiler_id),
	);

	---------------------------
	CREATE TABLE Detalle_importe (
		detalle_importe_id INT IDENTITY(1,1) PRIMARY KEY,
		alquiler_id INT REFERENCES Alquiler (alquiler_id),
		numero_periodo_inicio NUMERIC,
		numero_periodo_fin NUMERIC,
		precio NUMERIC,
	);

	---------------------------
	CREATE TABLE Gestion_Pago_Alquileres (
		gestion_pago_alquileres_id INT IDENTITY(1,1) PRIMARY KEY,
		alquiler_id INT REFERENCES Alquiler (alquiler_id),
		fecha_pago DATETIME,
		numero_periodo_pago NUMERIC,
		descripcion_periodo VARCHAR(255),
		fecha_inicio_periodo_pagado DATETIME,
		fecha_fin_periodo_pagado DATETIME,
		importe NUMERIC,
		medio_pago_id INT REFERENCES Medio_pago (medio_pago_id),
	);

	------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------------------------										INSERTS																	--------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------------------------

	---------------------------
	--		INMUEBLE
	---------------------------

	INSERT INTO Estado_inmueble(tipo) 
		SELECT DISTINCT INMUEBLE_ESTADO FROM gd_esquema.Maestra WHERE INMUEBLE_ESTADO IS NOT NULL;

	INSERT INTO Ambiente(tipo)
		SELECT DISTINCT INMUEBLE_CANT_AMBIENTES FROM gd_esquema.Maestra WHERE INMUEBLE_CANT_AMBIENTES IS NOT NULL;

	INSERT INTO Disposicion(tipo)
		SELECT DISTINCT INMUEBLE_DISPOSICION FROM gd_esquema.Maestra WHERE INMUEBLE_DISPOSICION IS NOT NULL;

	INSERT INTO Orientacion(tipo)
		SELECT DISTINCT INMUEBLE_ORIENTACION FROM gd_esquema.Maestra WHERE INMUEBLE_ORIENTACION IS NOT NULL;

	INSERT INTO Propietario(nombre, apellido, dni, mail, telefono, fecha_nacimiento, fecha_registro)
		SELECT DISTINCT PROPIETARIO_NOMBRE, PROPIETARIO_APELLIDO, PROPIETARIO_DNI, 
						PROPIETARIO_MAIL, PROPIETARIO_TELEFONO, PROPIETARIO_FECHA_NAC, 
						PROPIETARIO_FECHA_REGISTRO FROM gd_esquema.Maestra;

	INSERT INTO Tipo_inmueble(tipo)
		SELECT DISTINCT INMUEBLE_TIPO_INMUEBLE FROM gd_esquema.Maestra WHERE INMUEBLE_TIPO_INMUEBLE IS NOT NULL;

	---------------------------
	--		ALQUILER
	---------------------------

	INSERT INTO Estado_alquiler(tipo) 
		SELECT DISTINCT ALQUILER_ESTADO as tipo FROM gd_esquema.Maestra WHERE ALQUILER_ESTADO IS NOT NULL;

	INSERT INTO Inquilino(nombre, apellido, dni, mail, telefono, fecha_nac, fecha_registro) 
		SELECT DISTINCT INQUILINO_NOMBRE, INQUILINO_APELLIDO, INQUILINO_DNI, 
						INQUILINO_MAIL, INQUILINO_TELEFONO, INQUILINO_FECHA_NAC, 
						INQUILINO_FECHA_REGISTRO 
		FROM gd_esquema.Maestra WHERE INQUILINO_DNI IS NOT NULL;

	-- FALTA INSERTAR FK DE ALQUILER ASOC
	INSERT INTO Detalle_importe(numero_periodo_fin, numero_periodo_inicio, precio)
		SELECT DISTINCT DETALLE_ALQ_NRO_PERIODO_FIN, 
						DETALLE_ALQ_NRO_PERIODO_INI, 
						DETALLE_ALQ_PRECIO
		FROM gd_esquema.Maestra;

	INSERT INTO Gestion_Pago_Alquileres(gestion_pago_alquileres_id, fecha_pago, numero_periodo_pago, descripcion_periodo, fecha_inicio_periodo_pagado, fecha_fin_periodo_pagado, importe)
		SELECT DISTINCT PAGO_ALQUILER_CODIGO, PAGO_ALQUILER_FECHA, 
						PAGO_ALQUILER_NRO_PERIODO, PAGO_ALQUILER_DESC, 
						PAGO_ALQUILER_FEC_INI, PAGO_ALQUILER_FEC_FIN, 
						PAGO_ALQUILER_IMPORTE
		FROM gd_esquema.Maestra WHERE PAGO_ALQUILER_CODIGO IS NOT NULL;

	---------------------------
	--		PAGO
	---------------------------

	INSERT INTO Medio_Pago(medio)
		SELECT DISTINCT PAGO_ALQUILER_MEDIO_PAGO FROM gd_esquema.Maestra WHERE PAGO_ALQUILER_MEDIO_PAGO IS NOT NULL
		UNION
		SELECT DISTINCT PAGO_VENTA_MEDIO_PAGO FROM gd_esquema.Maestra WHERE PAGO_VENTA_MEDIO_PAGO IS NOT NULL;

	INSERT INTO Moneda(tipo)
		SELECT DISTINCT ANUNCIO_MONEDA FROM gd_esquema.Maestra WHERE ANUNCIO_MONEDA IS NOT NULL
		UNION
		SELECT DISTINCT VENTA_MONEDA FROM gd_esquema.Maestra WHERE VENTA_MONEDA IS NOT NULL
		UNION
		SELECT DISTINCT PAGO_VENTA_MONEDA FROM gd_esquema.Maestra WHERE PAGO_VENTA_MONEDA IS NOT NULL;

	INSERT INTO Pago(importe, cotizacion)
		SELECT DISTINCT PAGO_VENTA_IMPORTE, PAGO_VENTA_COTIZACION FROM gd_esquema.Maestra 
		UNION
		SELECT DISTINCT PAGO_ALQUILER_IMPORTE, null FROM gd_esquema.Maestra; -- VER EL TEMA DE LA COTIZACION EN UN PAGO DE ALQUILER

	---------------------------
	--		UBICACIONES
	---------------------------

	INSERT INTO Provincia (nombre)
		SELECT DISTINCT INMUEBLE_PROVINCIA FROM gd_esquema.Maestra WHERE INMUEBLE_PROVINCIA IS NOT NULL;

	INSERT INTO Localidad (nombre, provincia_id)
		SELECT DISTINCT M.INMUEBLE_LOCALIDAD, P.provincia_id
		FROM gd_esquema.Maestra AS M
		INNER JOIN Provincia AS P ON M.INMUEBLE_PROVINCIA = P.nombre
		WHERE M.INMUEBLE_LOCALIDAD IS NOT NULL;

	INSERT INTO Barrio (nombre, localidad_id)
		SELECT DISTINCT M.INMUEBLE_BARRIO, L.localidad_id
		FROM gd_esquema.Maestra AS M
		INNER JOIN Localidad AS L ON M.INMUEBLE_LOCALIDAD = L.nombre
		WHERE M.INMUEBLE_BARRIO IS NOT NULL;

		-- VERRRRRR UNION
	INSERT INTO Localidad (nombre, provincia_id)
		SELECT DISTINCT M.SUCURSAL_LOCALIDAD, P.provincia_id
		FROM gd_esquema.Maestra AS M
		INNER JOIN Provincia AS P ON M.SUCURSAL_PROVINCIA = P.nombre
		WHERE M.SUCURSAL_LOCALIDAD IS NOT NULL;

	---------------------------
	--		ANUNCIO
	---------------------------

	INSERT INTO Sucursal(nombre,localidad_id,direccion,telefono)
		SELECT DISTINCT M.SUCURSAL_NOMBRE,L.localidad_id,M.SUCURSAL_DIRECCION,M.SUCURSAL_TELEFONO
		FROM gd_esquema.Maestra AS M
		INNER JOIN Localidad AS L ON M. SUCURSAL_LOCALIDAD = L.nombre
		WHERE M.INMUEBLE_LOCALIDAD IS NOT NULL;

	INSERT INTO Agente(nombre,apellido,dni,fecha_registro,telefono,mail,fecha_nacimiento,sucursal_id)
		SELECT DISTINCT AGENTE_NOMBRE,AGENTE_APELLIDO,AGENTE_DNI,AGENTE_FECHA_REGISTRO,AGENTE_TELEFONO,AGENTE_MAIL,AGENTE_FECHA_NAC,S.sucursal_id
		from gd_esquema.Maestra M join Sucursal S on (M.SUCURSAL_NOMBRE = S.nombre);

	INSERT INTO Operacion(tipo)
		SELECT DISTINCT ANUNCIO_TIPO_OPERACION FROM gd_esquema.Maestra where ANUNCIO_TIPO_OPERACION is not null;

	INSERT INTO Estado_Anuncio(tipo)
		SELECT DISTINCT ANUNCIO_ESTADO FROM gd_esquema.Maestra where ANUNCIO_ESTADO is not null;

	COMMIT
END

