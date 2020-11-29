use GD2C2020;

CREATE VIEW precioPromedioAutoparte
AS SELECT SUM(precio)/SUM(comp.cantidad) promedioCompra, SUM(precio_facturado)/SUM(fact.cantidad)	promedioVenta
   FROM VARCHARIZARD.Compra_Autoparte_Item comp JOIN VARCHARIZARD.Factura_Autoparte_Item fact ON comp.autoparte_id = fact.autoparte_id ;

CREATE VIEW ganaciasSucursalPorMes
AS SELECT sucursal_id, SUM(precio_facturado - precio) ganancia, YEAR(fac2.fecha) anio, MONTH(fac2.fecha) mes
FROM VARCHARIZARD.Factura_Autoparte_Item fac1 JOIN VARCHARIZARD.Compra_Autoparte_Item com ON fac1.autoparte_id = com.autoparte_id
											  JOIN VARCHARIZARD.Factura_Autoparte fac2 ON fac1.factura_nro = fac2.factura_nro
GROUP BY  sucursal_id,YEAR(fac2.fecha), MONTH(fac2.fecha)
ORDER BY 3,4,1;

CREATE VIEW maximaCantidadStockPorSucursal 
AS SELECT sucursal_id, MAX(cantidad) maximaCantidadStock,YEAR(factura.fecha) anio
   FROM VARCHARIZARD.Factura_Autoparte_Item facturaItem JOIN VARCHARIZARD.Factura_Autoparte factura ON facturaItem.factura_nro = factura.factura_nro
   GROUP BY sucursal_id,YEAR(factura.fecha);
   
--La de promedio de tiempo en stock de cada autoparte NO hay que hacerla, según dijo un ayudante en el foro

create view cantidadDeAutomoviles as
select distinct suc.descripcion sucursal, t.mes,
	(select count(*) 
		from VARCHARIZARD.BI_venta_automovil venta 
		where venta.sucursal_id = suc.sucursal_id and month(venta.fecha) = t.mes) cantidad_vendida,
	(select count(*) 
		from VARCHARIZARD.BI_compra_automovil compra 
		where compra.sucursal_id = suc.sucursal_id and month(compra.fecha) = t.mes) cantidad_comprada
	from VARCHARIZARD.BI_sucursal suc, VARCHARIZARD.BI_tiempo t
;

create view precioPromedioAutomoviles as
select 
(select sum(factura_precio)/count(*) from VARCHARIZARD.BI_venta_automovil) promedio_venta,
(select sum(compra_precio)/count(*) from VARCHARIZARD.BI_compra_automovil) promedio_compra
;

create view gananciaMensual as
select distinct suc.descripcion sucursal, t.mes,
(select sum(factura_precio) from VARCHARIZARD.BI_venta_automovil venta
	where venta.sucursal_id = suc.sucursal_id and month(venta.fecha) = t.mes) -
(select sum(compra_precio) from VARCHARIZARD.BI_compra_automovil compra
	where compra.sucursal_id = suc.sucursal_id and month(compra.fecha) = t.mes) ganancia
from VARCHARIZARD.BI_sucursal suc, VARCHARIZARD.BI_tiempo t
;

--select datediff(day, compra.fecha, venta.fecha)
--select compra.fecha, venta.fecha, compra.modelo_id, venta.modelo_id
--from VARCHARIZARD.BI_venta_automovil venta, VARCHARIZARD.BI_compra_automovil compra
	--join VARCHARIZARD.BI_compra_automovil compra on venta.modelo_id = compra.modelo_id
--where venta.modelo_id = compra.modelo_id
;
