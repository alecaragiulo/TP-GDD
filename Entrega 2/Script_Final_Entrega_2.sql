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
	CREATE TABLE Caracteristica (
		caracteristica_id INT IDENTITY(1,1) PRIMARY KEY,
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
		expensas NUMERIC,
	);


	------------------------
	CREATE TABLE Inmuebles_Caracteristicas (
		inmueble_id INT,
		caracteristica_id INT,
		PRIMARY KEY (inmueble_id, caracteristica_id),
		FOREIGN KEY (inmueble_id) REFERENCES Inmueble(inmueble_id),
		FOREIGN KEY (caracteristica_id) REFERENCES Caracteristica(caracteristica_id)
	);

	------------------------
	CREATE TABLE Anuncio (
		anuncio_id INT IDENTITY(1,1) PRIMARY KEY,
		fecha_publicacion DATETIME,
		agente_id INT REFERENCES Agente(agente_id),
		operacion_id INT REFERENCES Operacion(operacion_id),
		inmueble_id INT REFERENCES Inmueble(inmueble_id),
		anuncio_precio NUMERIC,
		moneda_id INT REFERENCES Moneda(moneda_id),
		periodo_id INT REFERENCES Periodo(periodo_id),
		estado_anuncio_id INT REFERENCES Estado_anuncio(estado_anuncio_id),
		fecha_finalizacion DATETIME,
		costo_publicacion NUMERIC,
		codigo numeric
	);

	--------------------------
	--------- VENTAS ---------
	--------------------------

	CREATE TABLE Comprador (
		comprador_id INT IDENTITY(1,1) PRIMARY KEY,
		nombre	VARCHAR(255),
		apellido	VARCHAR(255),
		dni		NUMERIC,
		fecha_registro DATETIME,
		telefono NUMERIC,
		mail VARCHAR(255),
		fecha_nacimiento DATETIME,
	);
	---------------------------
	CREATE TABLE Medio_Pago (
		medio_pago_id INT IDENTITY(1,1) PRIMARY KEY,
		medio	VARCHAR(255),
	);	
	---------------------------
	CREATE TABLE Venta (
		venta_id INT IDENTITY(1,1) PRIMARY KEY,
		anuncio_id INT REFERENCES Anuncio (anuncio_id),
		comprador_id INT REFERENCES Comprador (comprador_id),
		fecha_venta DATETIME,
		precio_venta NUMERIC,
		moneda_id INT REFERENCES Moneda (moneda_id),
		comision_inmobiliaria INT,
	);
	---------------------------

	CREATE TABLE Pago_Venta (
		pago_venta_id INT IDENTITY(1,1) PRIMARY KEY,
		venta_id INT REFERENCES Venta(venta_id),
		importe NUMERIC,
		moneda_id INT REFERENCES Moneda (moneda_id),
		medio_pago_id INT REFERENCES Medio_Pago (medio_pago_id),
		cotizacion NUMERIC
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
		anuncio_id INT REFERENCES Anuncio (anuncio_id),
		inquilino_id INT REFERENCES Inquilino (inquilino_id),
		fecha_inicio DATETIME,
		fecha_final DATETIME,
		duracion NUMERIC,
		deposito NUMERIC,
		comision NUMERIC,
		gastos_averiguaciones NUMERIC,
		estado_alquiler_id INT REFERENCES Estado_alquiler(estado_alquiler_id),
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
	CREATE TABLE Pago_Alquiler (
		pago_alquiler_id INT IDENTITY(1,1) PRIMARY KEY,
		alquiler_id INT REFERENCES Alquiler (alquiler_id),
		fecha_pago DATETIME,
		numero_periodo_pago NUMERIC,
		descripcion_periodo VARCHAR(255),
		fecha_inicio_periodo_pagado DATETIME,
		fecha_fin_periodo_pagado DATETIME,
		importe NUMERIC,
		medio_pago_id INT REFERENCES Medio_Pago (medio_pago_id),
	);

	------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------------------------										INSERTS																	--------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------------------------

	---------------------------
	--		INMUEBLES
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
	--		PAGOS
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


	---------------------------
	--		UBICACIONES
	---------------------------

	INSERT INTO Provincia (nombre)
		SELECT DISTINCT INMUEBLE_PROVINCIA FROM gd_esquema.Maestra WHERE INMUEBLE_PROVINCIA IS NOT NULL;

	INSERT INTO Localidad (nombre, provincia_id)
		SELECT DISTINCT M.INMUEBLE_LOCALIDAD, P.provincia_id
		FROM gd_esquema.Maestra AS M
		INNER JOIN Provincia AS P ON M.INMUEBLE_PROVINCIA = P.nombre
		WHERE M.INMUEBLE_LOCALIDAD IS NOT NULL
		UNION
		SELECT DISTINCT M.SUCURSAL_LOCALIDAD, P.provincia_id
		FROM gd_esquema.Maestra AS M
		INNER JOIN Provincia AS P ON M.SUCURSAL_PROVINCIA = P.nombre
		WHERE M.SUCURSAL_LOCALIDAD IS NOT NULL;


	INSERT INTO Barrio (nombre, localidad_id)
		SELECT DISTINCT M.INMUEBLE_BARRIO, L.localidad_id
		FROM gd_esquema.Maestra AS M
		INNER JOIN Provincia AS P ON M.INMUEBLE_PROVINCIA = P.nombre   
		INNER JOIN Localidad AS L ON M.INMUEBLE_LOCALIDAD = L.nombre
		WHERE M.INMUEBLE_BARRIO IS NOT NULL and L.provincia_id = P.provincia_id;

		
	---------------------------
	--		ANUNCIOS
	---------------------------

	INSERT INTO Sucursal(nombre,localidad_id,direccion,telefono)
		SELECT DISTINCT M.SUCURSAL_NOMBRE,L.localidad_id,M.SUCURSAL_DIRECCION,M.SUCURSAL_TELEFONO
		FROM gd_esquema.Maestra AS M
		INNER JOIN Provincia P on M.SUCURSAL_PROVINCIA = P.nombre
		INNER JOIN Localidad AS L ON M. SUCURSAL_LOCALIDAD = L.nombre AND L.provincia_id = P.provincia_id
		WHERE M.INMUEBLE_LOCALIDAD IS NOT NULL;

	INSERT INTO Agente(nombre,apellido,dni,fecha_registro,telefono,mail,fecha_nacimiento,sucursal_id)
		SELECT DISTINCT AGENTE_NOMBRE,AGENTE_APELLIDO,AGENTE_DNI,AGENTE_FECHA_REGISTRO,AGENTE_TELEFONO,AGENTE_MAIL,AGENTE_FECHA_NAC, S.sucursal_id
		FROM gd_esquema.Maestra M
		INNER JOIN Sucursal S ON M.SUCURSAL_NOMBRE = S.nombre;

	INSERT INTO Operacion(tipo)
		SELECT DISTINCT ANUNCIO_TIPO_OPERACION FROM gd_esquema.Maestra WHERE ANUNCIO_TIPO_OPERACION is not null;

	INSERT INTO Estado_Anuncio(tipo)
		SELECT DISTINCT ANUNCIO_ESTADO FROM gd_esquema.Maestra WHERE ANUNCIO_ESTADO is not null;

	INSERT INTO Periodo(tipo)
		SELECT DISTINCT  ANUNCIO_TIPO_PERIODO FROM gd_esquema.Maestra WHERE ANUNCIO_TIPO_PERIODO IS NOT NULL;

INSERT INTO Caracteristica(descripcion)
	VALUES ('Cable'),('Calefaccion'), ('Gas'),('WiFi'),('Cochera'),('Piscina'), ('Calefaccion central'), ('Aire acondicionado'),
	('Amoblamiento');


	SET IDENTITY_INSERT Inmueble ON
	INSERT INTO inmueble(inmueble_id,tipo_inmueble_id,descripcion,propietario_id,direccion,barrio_id,ambiente_id,
						superficie,disposicion_id,orientacion_id,estado_inmueble_id,antiguedad,expensas) 
	SELECT DISTINCT M.INMUEBLE_CODIGO, TI.tipo_inmueble_id, M.INMUEBLE_DESCRIPCION, P.propietario_id, M.INMUEBLE_DIRECCION, B.barrio_id, A.ambiente_id,
	M.INMUEBLE_SUPERFICIETOTAL, D.disposicion_id, O.orientacion_id, E.estado_inmueble_id, M.INMUEBLE_ANTIGUEDAD, M.INMUEBLE_EXPESAS
	FROM gd_esquema.Maestra M
	INNER JOIN Tipo_inmueble TI ON M.INMUEBLE_TIPO_INMUEBLE = TI.tipo
	INNER JOIN Propietario P ON M.PROPIETARIO_MAIL = P.mail AND M.PROPIETARIO_DNI = P.dni
	INNER JOIN Provincia Prov ON M.INMUEBLE_PROVINCIA = Prov.nombre
	INNER JOIN Localidad L ON M.INMUEBLE_LOCALIDAD = L.nombre AND Prov.provincia_id = L.provincia_id
	INNER JOIN Barrio B ON B.nombre = M.INMUEBLE_BARRIO AND L.localidad_id = B.localidad_id
	INNER JOIN Ambiente A ON A.tipo = M.INMUEBLE_CANT_AMBIENTES
	INNER JOIN Disposicion D ON D.tipo = M.INMUEBLE_DISPOSICION
	INNER JOIN Orientacion O ON O.tipo = M.INMUEBLE_ORIENTACION
	INNER JOIN Estado_inmueble E ON E.tipo = M.INMUEBLE_ESTADO
	where M.INMUEBLE_CODIGO IS NOT NULL;
	SET IDENTITY_INSERT Inmueble OFF


	INSERT INTO Inmuebles_Caracteristicas(inmueble_id, caracteristica_id)
	SELECT DISTINCT I.inmueble_id, C.caracteristica_id
	FROM gd_esquema.Maestra M, Inmueble I, Caracteristica C
	WHERE M.INMUEBLE_CODIGO = I.inmueble_id AND 
	(
		(C.descripcion = 'Cable' AND M.INMUEBLE_CARACTERISTICA_CABLE = 1)
		OR
		(C.descripcion = 'WiFi' AND M.INMUEBLE_CARACTERISTICA_WIFI = 1)
		OR
		(C.descripcion = 'Gas' AND M.INMUEBLE_CARACTERISTICA_GAS = 1)
		OR
		(C.descripcion = 'Calefaccion' AND M.INMUEBLE_CARACTERISTICA_CALEFACCION = 1)
	)


INSERT INTO comprador(nombre,apellido,dni,fecha_registro,telefono,mail,fecha_nacimiento)
	SELECT DISTINCT	 M.COMPRADOR_NOMBRE,M.COMPRADOR_APELLIDO,M.COMPRADOR_DNI,M.COMPRADOR_FECHA_REGISTRO,
					 M.COMPRADOR_TELEFONO,M.COMPRADOR_MAIL,M.COMPRADOR_FECHA_NAC
	FROM gd_esquema.Maestra M WHERE M.COMPRADOR_MAIL IS NOT NULL;

	---------------------------
	--		ALQUILERES
	---------------------------

	INSERT INTO Estado_alquiler(tipo) 
		SELECT DISTINCT ALQUILER_ESTADO as tipo FROM gd_esquema.Maestra WHERE ALQUILER_ESTADO IS NOT NULL;

	INSERT INTO Inquilino(nombre, apellido, dni, mail, telefono, fecha_nac, fecha_registro) 
		SELECT DISTINCT INQUILINO_NOMBRE, INQUILINO_APELLIDO, INQUILINO_DNI, 
						INQUILINO_MAIL, INQUILINO_TELEFONO, INQUILINO_FECHA_NAC, 
						INQUILINO_FECHA_REGISTRO 
		FROM gd_esquema.Maestra WHERE INQUILINO_DNI IS NOT NULL;


		SET IDENTITY_INSERT Anuncio ON
		INSERT INTO Anuncio(anuncio_id, fecha_publicacion, agente_id, operacion_id, inmueble_id, anuncio_precio, moneda_id, periodo_id,
		estado_anuncio_id, fecha_finalizacion, costo_publicacion)
		SELECT DISTINCT M.ANUNCIO_CODIGO, M.ANUNCIO_FECHA_PUBLICACION, A.agente_id, O.operacion_id, I.inmueble_id, M.ANUNCIO_PRECIO_PUBLICADO,
		Mo.moneda_id, Pe.periodo_id, E.estado_anuncio_id, M.ANUNCIO_FECHA_FINALIZACION, M.ANUNCIO_COSTO_ANUNCIO
		FROM gd_esquema.Maestra M
		INNER JOIN Agente A ON M.AGENTE_MAIL = A.mail
		INNER JOIN Operacion O ON O.tipo = M.ANUNCIO_TIPO_OPERACION
		INNER JOIN Propietario P ON M.PROPIETARIO_MAIL = P.mail AND M.PROPIETARIO_DNI = P.dni
		INNER JOIN Inmueble I ON I.inmueble_id = M.INMUEBLE_CODIGO AND I.propietario_id = P.propietario_id
		INNER JOIN Moneda Mo ON M.ANUNCIO_MONEDA = Mo.tipo
		INNER JOIN Periodo Pe ON Pe.tipo = M.ANUNCIO_TIPO_PERIODO
		INNER JOIN Estado_anuncio E ON E.tipo = M.ANUNCIO_ESTADO
		WHERE M.ANUNCIO_CODIGO IS NOT NULL;
		SET IDENTITY_INSERT Anuncio OFF

		SET IDENTITY_INSERT Alquiler ON
		INSERT INTO Alquiler(alquiler_id, anuncio_id, estado_alquiler_id, inquilino_id, comision, deposito, duracion, fecha_final,
		fecha_inicio, gastos_averiguaciones)
		SELECT DISTINCT M.ALQUILER_CODIGO, A.anuncio_id, E.estado_alquiler_id, I.inquilino_id, M.ALQUILER_COMISION,
		M.ALQUILER_DEPOSITO, M.ALQUILER_CANT_PERIODOS, M.ALQUILER_FECHA_FIN, M.ALQUILER_FECHA_INICIO, M.ALQUILER_GASTOS_AVERIGUA
		FROM gd_esquema.Maestra M
		INNER JOIN Anuncio A ON A.anuncio_id = M.ANUNCIO_CODIGO
		INNER JOIN Estado_alquiler E ON E.tipo = M.ALQUILER_ESTADO
		INNER JOIN Inquilino I ON I.dni = M.INQUILINO_DNI AND I.mail = M.INQUILINO_MAIL
		WHERE M.ALQUILER_CODIGO IS NOT NULL;
		SET IDENTITY_INSERT Alquiler OFF

		SET IDENTITY_INSERT Pago_Alquiler ON
		INSERT INTO Pago_Alquiler(pago_alquiler_id, alquiler_id, medio_pago_id, descripcion_periodo, fecha_fin_periodo_pagado,
		fecha_inicio_periodo_pagado, fecha_pago, importe, numero_periodo_pago)
		SELECT DISTINCT M.PAGO_ALQUILER_CODIGO, A.alquiler_id, MP.medio_pago_id, M.PAGO_ALQUILER_DESC, M.PAGO_ALQUILER_FEC_FIN,
		M.PAGO_ALQUILER_FEC_INI, M.PAGO_ALQUILER_FECHA, M.PAGO_ALQUILER_IMPORTE, M.PAGO_ALQUILER_NRO_PERIODO
		FROM gd_esquema.Maestra M
		INNER JOIN Alquiler A ON A.alquiler_id = M.ALQUILER_CODIGO
		INNER JOIN Medio_Pago MP ON M.PAGO_ALQUILER_MEDIO_PAGO = MP.MEDIO
		WHERE PAGO_ALQUILER_CODIGO IS NOT NULL;
		SET IDENTITY_INSERT Pago_Alquiler OFF

		INSERT INTO Detalle_importe(alquiler_id, numero_periodo_fin, numero_periodo_inicio, precio)
		SELECT DISTINCT A.alquiler_id, M.DETALLE_ALQ_NRO_PERIODO_FIN, M.DETALLE_ALQ_NRO_PERIODO_INI, M.DETALLE_ALQ_PRECIO
		FROM gd_esquema.Maestra M
		INNER JOIN Alquiler A ON A.alquiler_id = M.ALQUILER_CODIGO
		WHERE ALQUILER_CODIGO IS NOT NULL AND M.DETALLE_ALQ_NRO_PERIODO_FIN IS NOT NULL 
		AND M.DETALLE_ALQ_NRO_PERIODO_INI IS NOT NULL AND DETALLE_ALQ_PRECIO IS NOT NULL;

		SET IDENTITY_INSERT Venta ON
		INSERT INTO Venta(venta_id, anuncio_id, comprador_id, moneda_id, comision_inmobiliaria, fecha_venta, precio_venta)
		SELECT DISTINCT M.VENTA_CODIGO, A.anuncio_id, C.comprador_id, Mo.moneda_id, M.VENTA_COMISION, M.VENTA_FECHA, M.VENTA_PRECIO_VENTA
		FROM gd_esquema.Maestra M
		INNER JOIN Anuncio A ON A.anuncio_id = M.ANUNCIO_CODIGO
		INNER JOIN Comprador C ON C.dni = M.COMPRADOR_DNI AND C.mail = M.COMPRADOR_MAIL
		INNER JOIN Moneda Mo ON M.ANUNCIO_MONEDA = Mo.tipo
		WHERE M.VENTA_CODIGO IS NOT NULL;		
		SET IDENTITY_INSERT Venta OFF

		INSERT Pago_Venta(venta_id, moneda_id, medio_pago_id,importe,cotizacion)
		SELECT V.venta_id, Mo.moneda_id, MP.medio_pago_id, M.PAGO_VENTA_IMPORTE, M.PAGO_VENTA_COTIZACION
		FROM gd_esquema.Maestra M
		INNER JOIN Venta V ON M.VENTA_CODIGO = V.venta_id
		INNER JOIN Moneda Mo ON Mo.tipo = M.PAGO_VENTA_MONEDA
		INNER JOIN Medio_Pago MP ON MP.MEDIO = M.PAGO_VENTA_MEDIO_PAGO
COMMIT
END


EXEC GEDIENTOS_27.migrarDatos
