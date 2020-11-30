use GD2C2020;

----------------------------------------------
-- Dimensiones
----------------------------------------------

go
create proc varcharizard.creacion_dimensiones as begin

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
select distinct fecha, month(fecha), year(fecha) from VARCHARIZARD.Compra_Automovil
union
select distinct factura_fecha, month(factura_fecha), year(factura_fecha) from VARCHARIZARD.Factura_Automovil
union
select distinct fecha, month(fecha), year(fecha) from VARCHARIZARD.Compra_Autoparte
union
select distinct fecha, month(fecha), year(fecha) from VARCHARIZARD.Factura_Autoparte
;

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

-- dimension autoparte

create table varcharizard.BI_autoparte (
	id_autoparte int primary key,
	descripcion varchar(255)
)
insert into VARCHARIZARD.BI_autoparte
select autoparte_id, autoparte_descripcion from VARCHARIZARD.Autoparte;

end

-- Función para convertir el valor escalar de potencia en un valor definido dentro de un rango
go
create function varcharizard.rango_potencia (@potencia int) returns int as
begin
	if @potencia < 50 begin return 0 end
	else if @potencia >= 50 and @potencia <= 150 begin return 1 end
	else if @potencia > 151 and @potencia <= 300 begin return 2 end
	else if @potencia > 300 begin return 3 end
	return 0
end

go
create proc varcharizard.creacion_hechos as begin


----------------------------------------------
-- Tablas de hecho
----------------------------------------------

----------------------------------------------
-- venta automovil
----------------------------------------------
create table varcharizard.BI_venta_automovil (
	cliente_id int foreign key references varcharizard.BI_cliente,
	fecha date foreign key references varcharizard.BI_tiempo,
	sucursal_id int foreign key references varcharizard.BI_sucursal,
	modelo_id int foreign key references varcharizard.BI_modelo,
	fabricante_id int foreign key references varcharizard.BI_fabricante,
	tipo_automovil_id int foreign key references varcharizard.BI_tipo_automovil,
	tipo_caja_id int foreign key references varcharizard.BI_tipo_caja,
	tipo_motor int foreign key references varcharizard.BI_tipo_motor,
	tipo_transmision int foreign key references varcharizard.BI_tipo_transmision,
	id_potencia int foreign key references varcharizard.BI_potencia,
	factura_precio decimal(18,2),
	automovil_id bigint
)

insert into VARCHARIZARD.BI_venta_automovil
select fac.cliente_id, fac.factura_fecha, fac.sucursal_id, a.cod_modelo, m.cod_fabricante,
		m.cod_auto, m.cod_caja, m.tipo_motor_codigo, m.cod_transmision,
		varcharizard.rango_potencia(m.modelo_potencia) potencia_id,
		fac.factura_precio, fac.automovil_id
from VARCHARIZARD.Factura_Automovil fac
 join VARCHARIZARD.automovil a on fac.automovil_id = a.automovil_id
 join VARCHARIZARD.Modelo m on a.cod_modelo = m.modelo_id
;

----------------------------------------------
-- compra automovil
----------------------------------------------
create table varcharizard.BI_compra_automovil (
	cliente_id int foreign key references varcharizard.BI_cliente,
	fecha date foreign key references varcharizard.BI_tiempo,
	sucursal_id int foreign key references varcharizard.BI_sucursal,
	modelo_id int foreign key references varcharizard.BI_modelo,
	fabricante_id int foreign key references varcharizard.BI_fabricante,
	tipo_automovil_id int foreign key references varcharizard.BI_tipo_automovil,
	tipo_caja_id int foreign key references varcharizard.BI_tipo_caja,
	tipo_motor int foreign key references varcharizard.BI_tipo_motor,
	tipo_transmision int foreign key references varcharizard.BI_tipo_transmision,
	id_potencia int foreign key references varcharizard.BI_potencia,
	compra_precio decimal(18,2),
	automovil_id bigint
);

insert into varcharizard.BI_compra_automovil
select comp.cliente_id, comp.fecha, comp.sucursal_id, a.cod_modelo, m.cod_fabricante,
		m.cod_auto, m.cod_caja, m.tipo_motor_codigo, m.cod_transmision,
		varcharizard.rango_potencia(m.modelo_potencia) potencia_id,
		comp.precio, comp.automovil_id
from VARCHARIZARD.Compra_Automovil comp
 join VARCHARIZARD.automovil a on comp.automovil_id = a.automovil_id
 join VARCHARIZARD.Modelo m on a.cod_modelo = m.modelo_id
;

----------------------------------------------
-- venta autoparte
----------------------------------------------

create table varcharizard.BI_venta_autoparte(
	autoparte_id int foreign key references varcharizard.BI_autoparte,
	cliente_id int foreign key references varcharizard.BI_cliente,
	fecha date foreign key references varcharizard.BI_tiempo,
	sucursal_id int foreign key references varcharizard.BI_sucursal,
	modelo_id int foreign key references varcharizard.BI_modelo,
	fabricante_id int foreign key references varcharizard.BI_fabricante,
	tipo_automovil_id int foreign key references varcharizard.BI_tipo_automovil,
	tipo_caja_id int foreign key references varcharizard.BI_tipo_caja,
	tipo_motor int foreign key references varcharizard.BI_tipo_motor,
	tipo_transmision int foreign key references varcharizard.BI_tipo_transmision,
	id_potencia int foreign key references varcharizard.BI_potencia,
	factura_precio decimal(18,2),
	cantidad int
)

insert into VARCHARIZARD.BI_venta_autoparte
select aut.autoparte_id, fac.cliente_id, fac.fecha, fac.sucursal_id, aut.cod_modelo, m.cod_fabricante,
		m.cod_auto, m.cod_caja, m.tipo_motor_codigo, m.cod_transmision, varcharizard.rango_potencia(m.modelo_potencia) potencia,
		it.precio_facturado, it.cantidad
from VARCHARIZARD.Factura_Autoparte fac
	join VARCHARIZARD.Factura_Autoparte_Item it on fac.factura_nro = it.factura_nro
	join VARCHARIZARD.Autoparte aut on it.autoparte_id = aut.autoparte_id
	join VARCHARIZARD.Modelo m on aut.cod_modelo = m.modelo_id
;

----------------------------------------------
-- compra autoparte
----------------------------------------------

CREATE TABLE varcharizard.BI_compra_autoparte(
	autoparte_id int foreign key references varcharizard.BI_autoparte,
	cliente_id int foreign key references varcharizard.BI_cliente,
	fecha date foreign key references varcharizard.BI_tiempo,
	sucursal_id int foreign key references varcharizard.BI_sucursal,
	modelo_id int foreign key references varcharizard.BI_modelo,
	fabricante_id int foreign key references varcharizard.BI_fabricante,
	tipo_automovil_id int foreign key references varcharizard.BI_tipo_automovil,
	tipo_caja_id int foreign key references varcharizard.BI_tipo_caja,
	tipo_motor int foreign key references varcharizard.BI_tipo_motor,
	tipo_transmision int foreign key references varcharizard.BI_tipo_transmision,
	id_potencia int foreign key references varcharizard.BI_potencia,
	compra_precio decimal(18,2),
	cantidad int
)

insert into VARCHARIZARD.BI_compra_autoparte
select aut.autoparte_id, comp.cliente_id, comp.fecha, comp.sucursal_id, aut.cod_modelo, m.cod_fabricante,
		m.cod_auto, m.cod_caja, m.tipo_motor_codigo, m.cod_transmision, varcharizard.rango_potencia(m.modelo_potencia) potencia,
		it.precio, it.cantidad
from VARCHARIZARD.Compra_Autoparte comp
	join VARCHARIZARD.Compra_Autoparte_Item it on comp.nro_compra = it.compra_id
	join VARCHARIZARD.Autoparte aut on it.autoparte_id = aut.autoparte_id
	join VARCHARIZARD.Modelo m on aut.cod_modelo = m.modelo_id
;

end

go
exec varcharizard.creacion_dimensiones;
go
exec varcharizard.creacion_hechos;


-----------------------------------
-- Vistas autoparte
-----------------------------------

--Precio promedio de cada autoparte, vendida y comprada.
go
create view VARCHARIZARD.precioPromedioAutoparte as
select aut.id_autoparte autoparte_id, aut.descripcion autoparte_descripcion,
( select sum(compra_precio*cantidad)/sum(cantidad) from VARCHARIZARD.BI_compra_autoparte compra where compra.autoparte_id = aut.id_autoparte) promedio_compra, 
( select sum(factura_precio*cantidad)/sum(cantidad) from VARCHARIZARD.BI_venta_autoparte venta where venta.autoparte_id = aut.id_autoparte) promedio_venta
from VARCHARIZARD.BI_autoparte aut
;

-- Ganancias (precio de venta – precio de compra) x Sucursal x mes
go
create view VARCHARIZARD.ganaciasSucursalPorMes as
select distinct suc.descripcion sucursal, t.mes,
(select sum(factura_precio*cantidad) from VARCHARIZARD.BI_venta_autoparte venta
	where venta.sucursal_id = suc.sucursal_id and month(venta.fecha) = t.mes) -
(select sum(compra_precio*cantidad) from VARCHARIZARD.BI_compra_autoparte compra
	where compra.sucursal_id = suc.sucursal_id and month(compra.fecha) = t.mes) ganancia
from VARCHARIZARD.BI_sucursal suc, VARCHARIZARD.BI_tiempo t
;

-- Promedio de tiempo en stock de cada autoparte
go
create view VARCHARIZARD.maximaCantidadStockPorSucursal as
select suc.sucursal_id, t.anio, sum(cantidad) cantidad_compras
from VARCHARIZARD.BI_compra_autoparte compra
	join VARCHARIZARD.BI_tiempo t on compra.fecha = t.fecha
	join VARCHARIZARD.BI_sucursal suc on compra.sucursal_id = suc.sucursal_id
	group by suc.sucursal_id, t.anio
;


--La de promedio de tiempo en stock de cada autoparte NO se realizó según instrucción de la cátedra.

-----------------------------------
-- Vistas automóvil
-----------------------------------

--Cantidad de automóviles, vendidos y comprados x sucursal y mes
go
create view VARCHARIZARD.cantidadDeAutomoviles as
select distinct suc.descripcion sucursal, t.mes,
	(select count(*) 
		from VARCHARIZARD.BI_venta_automovil venta 
		where venta.sucursal_id = suc.sucursal_id and month(venta.fecha) = t.mes) cantidad_vendida,
	(select count(*) 
		from VARCHARIZARD.BI_compra_automovil compra 
		where compra.sucursal_id = suc.sucursal_id and month(compra.fecha) = t.mes) cantidad_comprada
	from VARCHARIZARD.BI_sucursal suc, VARCHARIZARD.BI_tiempo t
;

--Precio promedio de automóviles, vendidos y comprados.
go
create view VARCHARIZARD.precioPromedioAutomoviles as
select 
(select sum(factura_precio)/count(*) from VARCHARIZARD.BI_venta_automovil) promedio_venta,
(select sum(compra_precio)/count(*) from VARCHARIZARD.BI_compra_automovil) promedio_compra
;

--Ganancias (precio de venta – precio de compra) x Sucursal x mes
go
create view VARCHARIZARD.gananciaMensualPorSucursal as
select distinct suc.descripcion sucursal, t.mes,
(select sum(factura_precio) from VARCHARIZARD.BI_venta_automovil venta
	where venta.sucursal_id = suc.sucursal_id and month(venta.fecha) = t.mes) -
(select sum(compra_precio) from VARCHARIZARD.BI_compra_automovil compra
	where compra.sucursal_id = suc.sucursal_id and month(compra.fecha) = t.mes) ganancia
from VARCHARIZARD.BI_sucursal suc, VARCHARIZARD.BI_tiempo t
;

--Promedio de tiempo en stock de cada modelo de automóvil
go
create view VARCHARIZARD.promedioTiempoStockAutomovil as
select m.descripcion modelo, sum(datediff(day, compra.fecha, venta.fecha))/count(*) dias_stock_promedio
from VARCHARIZARD.BI_venta_automovil venta, VARCHARIZARD.BI_compra_automovil compra
	join VARCHARIZARD.BI_modelo m on compra.modelo_id = m.modelo_id
where venta.automovil_id = compra.automovil_id
group by m.descripcion
;
