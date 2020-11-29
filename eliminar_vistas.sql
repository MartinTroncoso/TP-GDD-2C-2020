use GD2C2020;

drop view VARCHARIZARD.precioPromedioAutoparte;
drop view VARCHARIZARD.ganaciasSucursalPorMes;
drop view VARCHARIZARD.maximaCantidadStockPorSucursal;
drop view VARCHARIZARD.cantidadDeAutomoviles;
drop view VARCHARIZARD.precioPromedioAutomoviles;
drop view VARCHARIZARD.gananciaMensualPorSucursal;
drop view VARCHARIZARD.promedioTiempoStockAutomovil;

drop table varcharizard.BI_venta_automovil;
drop table varcharizard.BI_compra_automovil;
drop table varcharizard.BI_venta_autoparte;
drop table varcharizard.BI_compra_autoparte;

drop table varcharizard.BI_cliente;
drop table varcharizard.BI_tiempo;
drop table varcharizard.BI_sucursal;
drop table varcharizard.BI_modelo;
drop table varcharizard.BI_fabricante;
drop table varcharizard.BI_tipo_automovil;
drop table varcharizard.BI_tipo_caja;
drop table varcharizard.BI_tipo_motor;
drop table varcharizard.BI_tipo_transmision;
drop table varcharizard.BI_potencia;
drop table varcharizard.BI_autoparte;

drop proc varcharizard.creacion_dimensiones;
drop proc varcharizard.creacion_hechos;

drop function varcharizard.rango_potencia;