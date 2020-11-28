use GD2C2020;

-- DIMENSION CLIENTE
create table varcharizard.BI_cliente (
	cliente_id int primary key,
	fecha_nacimiento date not null
	)
insert into VARCHARIZARD.BI_cliente
select cliente_id, fecha_nacimiento from VARCHARIZARD.Cliente;

-- DIMENSION TIEMPO
create table varcharizard.BI_tiempo (
	fecha date primary key,
	mes int not null,
	anio int not null
)
insert into VARCHARIZARD.BI_tiempo
select distinct fecha, month(fecha), year(fecha) from VARCHARIZARD.Compra_Automovil;

-- DIMENSION SUCURSAL
create table varcharizard.BI_sucursal (
	sucursal_id int primary key,
	descripcion varchar(255)
	)
insert into VARCHARIZARD.BI_sucursal 
select sucursal_id, (direccion + ', ' + ciudad) from VARCHARIZARD.Sucursal;

-- dimension modelo
create table varcharizard.BI_modelo (
	modelo_id int primary key,
	descripcion varchar(255)
);
insert into VARCHARIZARD.BI_modelo
select modelo_id, modelo_nombre from VARCHARIZARD.Modelo;

-- dimension fabricante
create table varcharizard.BI_fabricante (
	fabricante_id int primary key,
	descripcion varchar(255)
);
insert into VARCHARIZARD.BI_fabricante
select fabricante_id, fabricante_nombre from VARCHARIZARD.Fabricante;

-- dimension tipo automovil
create table varcharizard.BI_tipo_automovil (
	tipo_automovil_id int primary key,
	descripcion varchar(255)
);
insert into VARCHARIZARD.BI_tipo_automovil
select tipo_auto_id, tipo_auto_desc from VARCHARIZARD.Tipo_Auto;

-- dimension tipo caja
create table varcharizard.BI_tipo_caja (
	tipo_caja_id int primary key,
	descripcion varchar(255)
);
insert into VARCHARIZARD.BI_tipo_caja
select caja_id, caja_desc from VARCHARIZARD.Tipo_Caja;

--dimension tipo motor
create table varcharizard.BI_tipo_motor (
	tipo_motor int primary key
	)
insert into VARCHARIZARD.BI_tipo_motor select distinct tipo_motor_codigo from VARCHARIZARD.Modelo;

-- dimension tipo transmision
create table varcharizard.BI_tipo_transmision (
	tipo_transmision int primary key,
	descripcion varchar(255)
	)
insert into VARCHARIZARD.BI_tipo_transmision
select tipo_transmision_id, tipo_transmision_desc from VARCHARIZARD.Tipo_Transmision;

-- dimension potencia
create table varcharizard.BI_potencia (
	id_potencia int primary key,
	descripcion varchar(255)
	)
insert into varcharizard.BI_potencia values (1, '50-150cv');
insert into varcharizard.BI_potencia values (2, '151-300cv');
insert into varcharizard.BI_potencia values (3, '>300cv');

----
