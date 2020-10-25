use GD2C2020;

CREATE schema VARCHARIZARD

CREATE PROCEDURE [VARCHARIZARD].[creacion_de_tablas]
AS

--Clientes
CREATE TABLE VARCHARIZARD.Cliente (
	cliente_id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL,
	apellido VARCHAR(255) NOT NULL,
	direccion VARCHAR(255),
	dni BIGINT NOT NULL,
	fecha_nacimiento DATE NOT NULL,
	email VARCHAR(255)
);

insert into VARCHARIZARD.Cliente (nombre, apellido, dni, direccion, fecha_nacimiento, email)
select distinct
	CLIENTE_NOMBRE nombre, 
	CLIENTE_APELLIDO apellido, 
	CLIENTE_DNI dni, 
	CLIENTE_DIRECCION direccion, 
	CLIENTE_FECHA_NAC fecha_nacimiento, 
	CLIENTE_MAIL email
from gd_esquema.Maestra
where CLIENTE_DNI IS NOT NULL
ORDER BY dni;

insert into VARCHARIZARD.Cliente (nombre, apellido, direccion, dni, fecha_nacimiento, email)
select distinct
	FAC_CLIENTE_NOMBRE nombre,
	FAC_CLIENTE_APELLIDO apellido,
	FAC_CLIENTE_DIRECCION direccion,
	FAC_CLIENTE_DNI dni,
	FAC_CLIENTE_FECHA_NAC fecha_nacimiento,
	FAC_CLIENTE_MAIL email
from gd_esquema.Maestra
where FAC_CLIENTE_DNI is not null;

--Fabricante
create table VARCHARIZARD.Fabricante (
	fabricante_id INT IDENTITY(1,1) PRIMARY KEY,
	fabricante_nombre VARCHAR(255) NOT NULL
)

insert into VARCHARIZARD.Fabricante (fabricante_nombre)
select distinct FABRICANTE_NOMBRE from gd_esquema.Maestra order by FABRICANTE_NOMBRE;

-- tipo caja
create table VARCHARIZARD.Tipo_Caja (
	caja_id INT IDENTITY(1,1) PRIMARY KEY,
	caja_desc VARCHAR(255) NOT NULL
)

insert into VARCHARIZARD.Tipo_Caja (caja_desc) values ('No especificado');
SET IDENTITY_INSERT VARCHARIZARD.Tipo_Caja ON;

insert into VARCHARIZARD.Tipo_Caja (caja_id, caja_desc)
select distinct TIPO_CAJA_CODIGO, TIPO_CAJA_DESC from gd_esquema.Maestra where TIPO_CAJA_CODIGO IS NOT NULL AND TIPO_CAJA_DESC IS NOT NULL order by TIPO_CAJA_CODIGO;
	
SET IDENTITY_INSERT VARCHARIZARD.Tipo_Caja OFF;

-- tipo auto
create table VARCHARIZARD.Tipo_Auto (
	tipo_auto_id INT IDENTITY(1,1) PRIMARY KEY,
	tipo_auto_desc VARCHAR(255) NOT NULL
);

insert into VARCHARIZARD.Tipo_Auto (tipo_auto_desc) values ('No especificado');
SET IDENTITY_INSERT VARCHARIZARD.Tipo_Auto ON;
insert into VARCHARIZARD.Tipo_Auto (tipo_auto_id, tipo_auto_desc)
select distinct TIPO_AUTO_CODIGO, TIPO_AUTO_DESC from gd_esquema.Maestra where TIPO_AUTO_CODIGO is not null and TIPO_AUTO_DESC is not null order by TIPO_AUTO_CODIGO;
SET IDENTITY_INSERT VARCHARIZARD.Tipo_Auto OFF;

-- tipo transmision
create table VARCHARIZARD.Tipo_Transmision (
	tipo_transmision_id INT IDENTITY(1,1) PRIMARY KEY,
	tipo_transmision_desc VARCHAR(255) NOT NULL
);

insert into VARCHARIZARD.Tipo_Transmision (tipo_transmision_desc) values ('No especificado');
SET IDENTITY_INSERT VARCHARIZARD.Tipo_Transmision ON;
insert into VARCHARIZARD.Tipo_Transmision (tipo_transmision_id, tipo_transmision_desc)
	select distinct TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC from gd_esquema.Maestra where TIPO_TRANSMISION_CODIGO is not null and TIPO_TRANSMISION_DESC is not null order by TIPO_TRANSMISION_CODIGO;
SET IDENTITY_INSERT VARCHARIZARD.Tipo_Transmision OFF;

-- sucursal
create table VARCHARIZARD.Sucursal (
	sucursal_id INT IDENTITY(1,1) PRIMARY KEY,
	direccion VARCHAR(255),
	telefono VARCHAR(15), -- ver tipo de dato
	email VARCHAR(255),
	ciudad VARCHAR (255)
);

insert into VARCHARIZARD.Sucursal (direccion, telefono, email, ciudad)
	select distinct SUCURSAL_DIRECCION direccion, SUCURSAL_TELEFONO telefono, SUCURSAL_MAIL mail, SUCURSAL_CIUDAD ciudad 
	from gd_esquema.Maestra 
	where SUCURSAL_CIUDAD is not null order by SUCURSAL_MAIL;

-- modelo
create table VARCHARIZARD.Modelo (
	modelo_id BIGINT IDENTITY(1, 1) PRIMARY KEY,
	modelo_nombre VARCHAR(255),
	modelo_potencia INT,
	tipo_motor_codigo INT,
	cod_fabricante INT NOT NULL,
	cod_caja INT NOT NULL,
	cod_auto INT NOT NULL,
	cod_transmision INT NOT NULL
	FOREIGN KEY (cod_fabricante) references VARCHARIZARD.Fabricante,
	FOREIGN KEY (cod_caja) references VARCHARIZARD.Tipo_Caja,
	FOREIGN KEY (cod_auto) references VARCHARIZARD.Tipo_Auto,
	FOREIGN KEY (cod_transmision) references VARCHARIZARD.Tipo_Transmision,
);

SET IDENTITY_INSERT VARCHARIZARD.Modelo ON;
insert into VARCHARIZARD.Modelo (modelo_id, modelo_nombre, modelo_potencia, tipo_motor_codigo, cod_fabricante, cod_caja, cod_auto, cod_transmision)
select distinct ma.MODELO_CODIGO modelo_id, ma.MODELO_NOMBRE modelo_nombre,
	ma.MODELO_POTENCIA modelo_potencia, ma.TIPO_MOTOR_CODIGO tipo_motor_codigo,
	fa.fabricante_id cod_fabricante, ma.TIPO_CAJA_CODIGO cod_caja,
	ma.TIPO_AUTO_CODIGO cod_auto, ma.TIPO_TRANSMISION_CODIGO cod_transmision
from gd_esquema.Maestra ma 
	join VARCHARIZARD.Fabricante fa on ma.FABRICANTE_NOMBRE = fa.fabricante_nombre
where ma.TIPO_MOTOR_CODIGO is not null 
order by ma.MODELO_CODIGO;
SET IDENTITY_INSERT VARCHARIZARD.Modelo OFF;

-- automovil
create table VARCHARIZARD.automovil (
	automovil_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	patente VARCHAR(255), --se permiten nulos?
	nro_motor VARCHAR(255),
	nro_chasis VARCHAR(255),
	kilometraje INT,
	fecha_alta DATE,
	cod_modelo BIGINT,
	FOREIGN KEY (cod_modelo) REFERENCES VARCHARIZARD.Modelo
);

insert into VARCHARIZARD.automovil (patente, nro_motor, nro_chasis, kilometraje, fecha_alta, cod_modelo) 
select distinct AUTO_PATENTE patente, AUTO_NRO_MOTOR nro_motor, AUTO_NRO_CHASIS nro_chasis, AUTO_CANT_KMS kilometraje, AUTO_FECHA_ALTA fecha_alta, MODELO_CODIGO cod_modelo
from gd_esquema.Maestra
where AUTO_PATENTE is not null;

-- autoparte
create table VARCHARIZARD.Autoparte (
	autoparte_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	autoparte_descripcion VARCHAR(255) NOT NULL,
	cod_modelo BIGINT NOT NULL
	FOREIGN KEY (cod_modelo) REFERENCES VARCHARIZARD.Modelo
);

SET IDENTITY_INSERT VARCHARIZARD.Autoparte ON;
insert into VARCHARIZARD.Autoparte (autoparte_id, autoparte_descripcion, cod_modelo)
	select distinct AUTO_PARTE_CODIGO autoparte_id, AUTO_PARTE_DESCRIPCION autoparte_descripcion, MODELO_CODIGO cod_modelo
	from gd_esquema.Maestra 
	where AUTO_PARTE_CODIGO is not null 
	order by AUTO_PARTE_CODIGO;
SET IDENTITY_INSERT VARCHARIZARD.Autoparte OFF;

-- compra automovil

create table VARCHARIZARD.Compra_Automovil (
	compra_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	fecha DATE NOT NULL,
	precio DECIMAL(18,2) NOT NULL,
	cliente_id INT NOT NULL,
	sucursal_id INT NOT NULL,
	automovil_id BIGINT NOT NULL
	FOREIGN KEY (cliente_id) REFERENCES VARCHARIZARD.Cliente,
	FOREIGN KEY (sucursal_id) REFERENCES VARCHARIZARD.Sucursal,
	FOREIGN KEY (automovil_id) REFERENCES VARCHARIZARD.automovil
);

SET IDENTITY_INSERT VARCHARIZARD.Compra_Automovil ON;

INSERT INTO VARCHARIZARD.Compra_Automovil (compra_id, fecha, precio, cliente_id, sucursal_id, automovil_id)
select distinct ma.COMPRA_NRO compra_id, ma.COMPRA_FECHA fecha, ma.COMPRA_PRECIO precio, cl.cliente_id cliente_id, su.sucursal_id, au.automovil_id
from gd_esquema.Maestra ma
	join VARCHARIZARD.Cliente cl on ma.CLIENTE_NOMBRE = cl.nombre and ma.CLIENTE_APELLIDO = cl.apellido and ma.CLIENTE_DNI = cl.dni
	join VARCHARIZARD.Sucursal su on ma.SUCURSAL_CIUDAD = su.ciudad and ma.SUCURSAL_DIRECCION = su.direccion and ma.SUCURSAL_TELEFONO = su.telefono
	join VARCHARIZARD.automovil au on ma.AUTO_PATENTE = au.patente
where COMPRA_NRO is not null and AUTO_PATENTE is not null 
order by COMPRA_NRO;

SET IDENTITY_INSERT VARCHARIZARD.Compra_Automovil OFF;

-- compra autoparte

create table VARCHARIZARD.Compra_Autoparte (
	nro_compra BIGINT IDENTITY(1,1) PRIMARY KEY,
	fecha DATE NOT NULL,
	cliente_id INT NOT NULL,
	sucursal_id INT NOT NULL,
	FOREIGN KEY (cliente_id) REFERENCES VARCHARIZARD.Cliente,
	FOREIGN KEY (sucursal_id) REFERENCES VARCHARIZARD.Sucursal
	);

create table VARCHARIZARD.Compra_Autoparte_Item (
	id_compra_item BIGINT IDENTITY(1,1) PRIMARY KEY,
	compra_id BIGINT NOT NULL,
	autoparte_id BIGINT NOT NULL,
	precio DECIMAL(18,2) NOT NULL,
	cantidad INTEGER NOT NULL,
	FOREIGN KEY (compra_id) REFERENCES VARCHARIZARD.Compra_Autoparte,
	FOREIGN KEY (autoparte_id) REFERENCES VARCHARIZARD.Autoparte,
	);

SET IDENTITY_INSERT VARCHARIZARD.Compra_Autoparte ON
insert into VARCHARIZARD.Compra_Autoparte (nro_compra, fecha, cliente_id, sucursal_id)
select distinct COMPRA_NRO nro_compra, COMPRA_FECHA fecha, cl.cliente_id cliente_id, su.sucursal_id
from gd_esquema.Maestra	ma
	join VARCHARIZARD.Cliente cl on ma.CLIENTE_NOMBRE = cl.nombre and ma.CLIENTE_APELLIDO = cl.apellido and ma.CLIENTE_DNI = cl.dni
	join VARCHARIZARD.Sucursal su on ma.SUCURSAL_CIUDAD = su.ciudad and ma.SUCURSAL_DIRECCION = su.direccion
where COMPRA_NRO is not null and AUTO_PARTE_CODIGO is not null;
SET IDENTITY_INSERT VARCHARIZARD.Compra_Autoparte OFF;

insert into VARCHARIZARD.Compra_Autoparte_Item (compra_id, autoparte_id, precio, cantidad)
select distinct COMPRA_NRO, AUTO_PARTE_CODIGO, COMPRA_PRECIO, COMPRA_CANT
from gd_esquema.Maestra
where AUTO_PARTE_CODIGO is not null and COMPRA_NRO is not null
ORDER BY COMPRA_NRO;


-- factura automovil
CREATE TABLE VARCHARIZARD.Factura_Automovil (
	factura_nro BIGINT IDENTITY(1,1) PRIMARY KEY,
	factura_fecha DATE NOT NULL,
	factura_precio DECIMAL(18,2) NOT NULL,
	automovil_id BIGINT NOT NULL,
	sucursal_id INT NOT NULL,
	cliente_id INT NOT NULL,
	FOREIGN KEY (automovil_id) REFERENCES VARCHARIZARD.automovil,
	FOREIGN KEY (sucursal_id) REFERENCES VARCHARIZARD.Sucursal,
	FOREIGN KEY (cliente_id) REFERENCES VARCHARIZARD.Cliente
);


--temp factura autmovil
create table VARCHARIZARD.factura_automovil_temp (
	factura_nro BIGINT,
	automovil_id BIGINT
);
insert into VARCHARIZARD.factura_automovil_temp (factura_nro, automovil_id)
select ma.FACTURA_NRO factura_nro, au.automovil_id automovil_id
from gd_esquema.Maestra ma
join VARCHARIZARD.automovil au on ma.AUTO_PATENTE = au.patente
where ma.FACTURA_NRO IS NOT NULL AND ma.AUTO_PATENTE IS NOT NULL;

-- temp factura sucursal
create table VARCHARIZARD.factura_sucursal_temp (
	factura_nro BIGINT,
	sucursal_id INT
);
insert into VARCHARIZARD.factura_sucursal_temp (factura_nro, sucursal_id)
select ma.FACTURA_NRO factura_nro, su.sucursal_id sucursal_id
from gd_esquema.Maestra ma
join VARCHARIZARD.Sucursal su on ma.FAC_SUCURSAL_CIUDAD = su.ciudad AND MA.FAC_SUCURSAL_DIRECCION = su.direccion
where ma.FACTURA_NRO IS NOT NULL AND ma.AUTO_PATENTE IS NOT NULL;

-- factura cliente temp
create table VARCHARIZARD.factura_cliente_temp (
	factura_nro BIGINT,
	cliente_id INT
);
insert into VARCHARIZARD.factura_cliente_temp (factura_nro, cliente_id)
select ma.FACTURA_NRO factura_nro, cl.cliente_id cliente_id
from gd_esquema.Maestra ma
join VARCHARIZARD.Cliente cl on ma.CLIENTE_DNI = cl.dni and ma.CLIENTE_APELLIDO = cl.apellido and ma.CLIENTE_NOMBRE = cl.nombre
where ma.FACTURA_NRO IS NOT NULL AND ma.AUTO_PATENTE IS NOT NULL;

SET IDENTITY_INSERT VARCHARIZARD.Factura_Automovil ON;
insert into VARCHARIZARD.Factura_Automovil (factura_nro, factura_fecha, factura_precio, automovil_id, sucursal_id, cliente_id)
select ma.FACTURA_NRO factura_nro, ma.FACTURA_FECHA factura_fecha, ma.PRECIO_FACTURADO factura_precio, au.automovil_id automovil_id, su.sucursal_id sucursal_id, cl.cliente_id cliente_id
from gd_esquema.Maestra ma
join VARCHARIZARD.factura_automovil_temp au on ma.FACTURA_NRO = au.factura_nro
join VARCHARIZARD.factura_sucursal_temp su on ma.FACTURA_NRO = su.factura_nro
join VARCHARIZARD.factura_cliente_temp cl on ma.FACTURA_NRO = cl.factura_nro
where ma.FACTURA_NRO IS NOT NULL AND ma.AUTO_PATENTE IS NOT NULL;

SET IDENTITY_INSERT VARCHARIZARD.Factura_Automovil OFF;

drop table VARCHARIZARD.factura_automovil_temp;
drop table VARCHARIZARD.factura_cliente_temp;
drop table VARCHARIZARD.factura_sucursal_temp;

-- temp factura sucursal autoparte
create table VARCHARIZARD.factura_autoparte_sucursal_temp (
	factura_nro BIGINT,
	sucursal_id INT
);
insert into VARCHARIZARD.factura_autoparte_sucursal_temp (factura_nro, sucursal_id)
select ma.FACTURA_NRO factura_nro, su.sucursal_id sucursal_id
from gd_esquema.Maestra ma
join VARCHARIZARD.Sucursal su on ma.FAC_SUCURSAL_CIUDAD = su.ciudad AND MA.FAC_SUCURSAL_DIRECCION = su.direccion
where ma.FACTURA_NRO IS NOT NULL AND ma.AUTO_PARTE_CODIGO IS NOT NULL;

-- factura cliente temp autoparte
create table VARCHARIZARD.factura_autoparte_cliente_temp (
	factura_nro BIGINT,
	cliente_id INT
);
insert into VARCHARIZARD.factura_autoparte_cliente_temp (factura_nro, cliente_id)
select distinct ma.FACTURA_NRO factura_nro, cl.cliente_id cliente_id
from gd_esquema.Maestra ma
join VARCHARIZARD.Cliente cl on ma.FAC_CLIENTE_DNI = cl.dni and ma.FAC_CLIENTE_APELLIDO = cl.apellido and ma.FAC_CLIENTE_NOMBRE = cl.nombre
where ma.FACTURA_NRO IS NOT NULL AND ma.AUTO_PARTE_CODIGO IS NOT NULL;

-- autoparte
create table VARCHARIZARD.Factura_Autoparte(
	factura_nro BIGINT IDENTITY(1,1) PRIMARY KEY,
	sucursal_id INT NOT NULL,
	cliente_id INT NOT NULL,
	fecha DATE,
	FOREIGN KEY (sucursal_id) REFERENCES VARCHARIZARD.Sucursal,
	FOREIGN KEY (cliente_id) REFERENCES VARCHARIZARD.Cliente
)
SET IDENTITY_INSERT VARCHARIZARD.Factura_Autoparte ON;
insert into VARCHARIZARD.Factura_Autoparte (factura_nro, sucursal_id, cliente_id, fecha)
select distinct cl.factura_nro factura_nro, su.sucursal_id sucursal_id, cl.cliente_id cliente_id, ma.FACTURA_FECHA fecha
from VARCHARIZARD.factura_autoparte_cliente_temp cl
join VARCHARIZARD.factura_autoparte_sucursal_temp su on cl.factura_nro = su.factura_nro 
join gd_esquema.Maestra ma on ma.FACTURA_NRO = su.factura_nro
order by cl.factura_nro;
SET IDENTITY_INSERT VARCHARIZARD.Factura_Autoparte OFF;

-- autoparte item
create table VARCHARIZARD.Factura_Autoparte_Item (
	factura_item_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	factura_nro BIGINT,
	autoparte_id BIGINT,
	precio_facturado DECIMAL(18,2),
	cantidad INT,
	FOREIGN KEY (factura_nro) REFERENCES VARCHARIZARD.Factura_Autoparte,
	FOREIGN KEY (autoparte_id) REFERENCES VARCHARIZARD.Autoparte,
);
insert into VARCHARIZARD.Factura_Autoparte_Item (factura_nro, autoparte_id, precio_facturado, cantidad)
select fa.factura_nro factura_nro, ma.AUTO_PARTE_CODIGO autoparte_id, ma.PRECIO_FACTURADO precio_facturado, ma.CANT_FACTURADA cantidad
from VARCHARIZARD.Factura_Autoparte fa
join gd_esquema.Maestra ma on fa.factura_nro = ma.FACTURA_NRO;

drop table VARCHARIZARD.factura_autoparte_sucursal_temp;
drop table VARCHARIZARD.factura_autoparte_cliente_temp;

GO

EXEC [VARCHARIZARD].[creacion_de_tablas]
