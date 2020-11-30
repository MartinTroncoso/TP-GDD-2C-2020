use GD2C2020;

go
create proc varcharizard.creacion_vistas as

-----------------------------------
-- Vistas autoparte
-----------------------------------

-- Precio promedio de cada autoparte, vendida y comprada.
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

go
create view VARCHARIZARD.precioPromedioAutomoviles as
select 
(select sum(factura_precio)/count(*) from VARCHARIZARD.BI_venta_automovil) promedio_venta,
(select sum(compra_precio)/count(*) from VARCHARIZARD.BI_compra_automovil) promedio_compra
;

go
create view VARCHARIZARD.gananciaMensualPorSucursal as
select distinct suc.descripcion sucursal, t.mes,
(select sum(factura_precio) from VARCHARIZARD.BI_venta_automovil venta
	where venta.sucursal_id = suc.sucursal_id and month(venta.fecha) = t.mes) -
(select sum(compra_precio) from VARCHARIZARD.BI_compra_automovil compra
	where compra.sucursal_id = suc.sucursal_id and month(compra.fecha) = t.mes) ganancia
from VARCHARIZARD.BI_sucursal suc, VARCHARIZARD.BI_tiempo t
;

go
create view VARCHARIZARD.promedioTiempoStockAutomovil as
select m.descripcion modelo, sum(datediff(day, compra.fecha, venta.fecha))/count(*) dias_stock_promedio
from VARCHARIZARD.BI_venta_automovil venta, VARCHARIZARD.BI_compra_automovil compra
	join VARCHARIZARD.BI_modelo m on compra.modelo_id = m.modelo_id
where venta.automovil_id = compra.automovil_id
group by m.descripcion
;

go

exec varcharizard.creacion_vistas;
