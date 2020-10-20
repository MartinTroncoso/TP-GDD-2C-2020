use GD2C2020;

--Clientes
CREATE TABLE Cliente (
	cliente_id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL,
	apellido VARCHAR(255) NOT NULL,
	direccion VARCHAR(255),
	dni BIGINT NOT NULL,
	fecha_nacimiento DATE NOT NULL,
	email VARCHAR(255)
);

insert into Cliente (nombre, apellido, dni, direccion, fecha_nacimiento, email)
select distinct
	CLIENTE_NOMBRE nombre, 
	CLIENTE_APELLIDO apellido, 
	CLIENTE_DNI dni, 
	CLIENTE_DIRECCION direccion, 
	CLIENTE_FECHA_NAC fecha_nacimiento, 
	CLIENTE_MAIL email
from gd_esquema.Maestra
where 
CLIENTE_DNI IS NOT NULL
ORDER BY dni
;

--Fabricante
create table Fabricante (
	fabricante_id INT IDENTITY(1,1) PRIMARY KEY,
	fabricante_nombre VARCHAR(255) NOT NULL
)

insert into Fabricante (fabricante_nombre)
select distinct FABRICANTE_NOMBRE from gd_esquema.Maestra order by FABRICANTE_NOMBRE;

-- tipo caja
create table Tipo_Caja (
	caja_id INT IDENTITY(1,1) PRIMARY KEY,
	caja_desc VARCHAR(255) NOT NULL
)

insert into Tipo_Caja (caja_desc) values ('No especificado');
SET IDENTITY_INSERT Tipo_Caja ON;

insert into Tipo_Caja (caja_id, caja_desc)
	select distinct TIPO_CAJA_CODIGO, TIPO_CAJA_DESC from gd_esquema.Maestra where TIPO_CAJA_CODIGO IS NOT NULL AND TIPO_CAJA_DESC IS NOT NULL order by TIPO_CAJA_CODIGO;
	
SET IDENTITY_INSERT Tipo_Caja OFF;

-- tipo auto
create table Tipo_Auto (
	tipo_auto_id INT IDENTITY(1,1) PRIMARY KEY,
	tipo_auto_desc VARCHAR(255) NOT NULL
);
insert into Tipo_Auto (tipo_auto_desc) values ('No especificado');
SET IDENTITY_INSERT Tipo_Auto ON;
insert into Tipo_Auto (tipo_auto_id, tipo_auto_desc)
	select distinct TIPO_AUTO_CODIGO, TIPO_AUTO_DESC from gd_esquema.Maestra where TIPO_AUTO_CODIGO is not null and TIPO_AUTO_DESC is not null order by TIPO_AUTO_CODIGO;
SET IDENTITY_INSERT Tipo_Auto OFF;

-- tipo transmision
create table Tipo_Transmision (
	tipo_transmision_id INT IDENTITY(1,1) PRIMARY KEY,
	tipo_transmision_desc VARCHAR(255) NOT NULL
);
insert into Tipo_Transmision (tipo_transmision_desc) values ('No especificado');
SET IDENTITY_INSERT Tipo_Transmision ON;
insert into Tipo_Transmision (tipo_transmision_id, tipo_transmision_desc)
	select distinct TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC from gd_esquema.Maestra where TIPO_TRANSMISION_CODIGO is not null and TIPO_TRANSMISION_DESC is not null order by TIPO_TRANSMISION_CODIGO;
SET IDENTITY_INSERT Tipo_Transmision OFF;

-- sucursal
create table Sucursal (
	sucursal_id INT IDENTITY(1,1) PRIMARY KEY,
	direccion VARCHAR(255),
	telefono VARCHAR(15), -- ver tipo de dato
	email VARCHAR(255),
	ciudad VARCHAR (255)
	);

insert into Sucursal (direccion, telefono, email, ciudad)
	select distinct SUCURSAL_DIRECCION direccion, SUCURSAL_TELEFONO telefono, SUCURSAL_MAIL mail, SUCURSAL_CIUDAD ciudad 
	from gd_esquema.Maestra 
	where SUCURSAL_CIUDAD is not null order by SUCURSAL_MAIL;


-- modelo
create table Modelo (
	modelo_id BIGINT IDENTITY(1, 1) PRIMARY KEY,
	modelo_nombre VARCHAR(255),
	modelo_potencia INT,
	tipo_motor_codigo INT,
	cod_fabricante INT NOT NULL,
	cod_caja INT NOT NULL,
	cod_auto INT NOT NULL,
	cod_transmision INT NOT NULL
	FOREIGN KEY (cod_fabricante) references Fabricante,
	FOREIGN KEY (cod_caja) references Tipo_Caja,
	FOREIGN KEY (cod_auto) references Tipo_Auto,
	FOREIGN KEY (cod_transmision) references Tipo_Transmision,
	);

SET IDENTITY_INSERT Modelo ON;
insert into Modelo (modelo_id, modelo_nombre, modelo_potencia, tipo_motor_codigo, cod_fabricante, cod_caja, cod_auto, cod_transmision)
select distinct ma.MODELO_CODIGO modelo_id, ma.MODELO_NOMBRE modelo_nombre,
	ma.MODELO_POTENCIA modelo_potencia, ma.TIPO_MOTOR_CODIGO tipo_motor_codigo,
	fa.fabricante_id cod_fabricante, ma.TIPO_CAJA_CODIGO cod_caja,
	ma.TIPO_AUTO_CODIGO cod_auto, ma.TIPO_TRANSMISION_CODIGO cod_transmision
from gd_esquema.Maestra ma 
	join Fabricante fa on ma.FABRICANTE_NOMBRE = fa.fabricante_nombre
where ma.TIPO_MOTOR_CODIGO is not null 
order by ma.MODELO_CODIGO;
SET IDENTITY_INSERT Modelo OFF;


-- automovil
create table automovil (
	automovil_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	patente VARCHAR(255), --se permiten nulos?
	nro_motor VARCHAR(255),
	nro_chasis VARCHAR(255),
	kilometraje INT,
	fecha_alta DATE,
	cod_modelo BIGINT,
	FOREIGN KEY (cod_modelo) REFERENCES Modelo
	);

insert into automovil (patente, nro_motor, nro_chasis, kilometraje, fecha_alta, cod_modelo) 
select distinct AUTO_PATENTE patente, AUTO_NRO_MOTOR nro_motor, AUTO_NRO_CHASIS nro_chasis, AUTO_CANT_KMS kilometraje, AUTO_FECHA_ALTA fecha_alta, MODELO_CODIGO cod_modelo
from gd_esquema.Maestra
where AUTO_PATENTE is not null;


-- autoparte
create table Autoparte (
	autoparte_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	autoparte_descripcion VARCHAR(255) NOT NULL,
	cod_modelo BIGINT NOT NULL
	FOREIGN KEY (cod_modelo) REFERENCES Modelo
	);
	
SET IDENTITY_INSERT Autoparte ON;
insert into Autoparte (autoparte_id, autoparte_descripcion, cod_modelo)
	select distinct AUTO_PARTE_CODIGO autoparte_id, AUTO_PARTE_DESCRIPCION autoparte_descripcion, MODELO_CODIGO cod_modelo
	from gd_esquema.Maestra 
	where AUTO_PARTE_CODIGO is not null 
	order by AUTO_PARTE_CODIGO;
SET IDENTITY_INSERT Autoparte OFF;

-- compra automovil

create table Compra_Automovil (
	compra_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	fecha DATE NOT NULL,
	precio DECIMAL(18,2) NOT NULL,
	cliente_id INT NOT NULL,
	sucursal_id INT NOT NULL,
	automovil_id BIGINT NOT NULL
	FOREIGN KEY (cliente_id) REFERENCES Cliente,
	FOREIGN KEY (sucursal_id) REFERENCES Sucursal,
	FOREIGN KEY (automovil_id) REFERENCES automovil
	);

SET IDENTITY_INSERT Compra_Automovil ON;

INSERT INTO Compra_Automovil (compra_id, fecha, precio, cliente_id, sucursal_id, automovil_id)
select distinct ma.COMPRA_NRO compra_id, ma.COMPRA_FECHA fecha, ma.COMPRA_PRECIO precio, cl.cliente_id cliente_id, su.sucursal_id, au.automovil_id
from gd_esquema.Maestra ma
	join Cliente cl on ma.CLIENTE_NOMBRE = cl.nombre and ma.CLIENTE_APELLIDO = cl.apellido and ma.CLIENTE_DNI = cl.dni
	join Sucursal su on ma.SUCURSAL_CIUDAD = su.ciudad and ma.SUCURSAL_DIRECCION = su.direccion and ma.SUCURSAL_TELEFONO = su.telefono
	join automovil au on ma.AUTO_PATENTE = au.patente
where COMPRA_NRO is not null and AUTO_PATENTE is not null 
order by COMPRA_NRO;

SET IDENTITY_INSERT Compra_Automovil OFF
;

-- compra autoparte

create table Compra_Autoparte (
	nro_compra BIGINT IDENTITY(1,1) PRIMARY KEY,
	fecha DATE NOT NULL,
	cliente_id INT NOT NULL,
	sucursal_id INT NOT NULL,
	FOREIGN KEY (cliente_id) REFERENCES Cliente,
	FOREIGN KEY (sucursal_id) REFERENCES Sucursal
	);

create table Compra_Autoparte_Item (
	id_compra_item BIGINT IDENTITY(1,1) PRIMARY KEY,
	compra_id BIGINT NOT NULL,
	autoparte_id BIGINT NOT NULL,
	precio DECIMAL(18,2) NOT NULL,
	cantidad INTEGER NOT NULL,
	FOREIGN KEY (compra_id) REFERENCES Compra_Autoparte,
	FOREIGN KEY (autoparte_id) REFERENCES Autoparte,
	);

SET IDENTITY_INSERT Compra_Autoparte ON
insert into Compra_Autoparte (nro_compra, fecha, cliente_id, sucursal_id)
select distinct COMPRA_NRO nro_compra, COMPRA_FECHA fecha, cl.cliente_id cliente_id, su.sucursal_id
from gd_esquema.Maestra	ma
	join Cliente cl on ma.CLIENTE_NOMBRE = cl.nombre and ma.CLIENTE_APELLIDO = cl.apellido and ma.CLIENTE_DNI = cl.dni
	join Sucursal su on ma.SUCURSAL_CIUDAD = su.ciudad and ma.SUCURSAL_DIRECCION = su.direccion
where COMPRA_NRO is not null and AUTO_PARTE_CODIGO is not null;
SET IDENTITY_INSERT Compra_Autoparte OFF

insert into Compra_Autoparte_Item (compra_id, autoparte_id, precio, cantidad)
select distinct COMPRA_NRO, AUTO_PARTE_CODIGO, COMPRA_PRECIO, COMPRA_CANT
from gd_esquema.Maestra
where AUTO_PARTE_CODIGO is not null and COMPRA_NRO is not null
ORDER BY COMPRA_NRO;

