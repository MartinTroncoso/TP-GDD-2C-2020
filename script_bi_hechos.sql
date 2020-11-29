use GD2C2020;

create function varcharizard.rango_potencia (@potencia int) returns int as
begin
	if @potencia < 50 begin return 0 end
	else if @potencia >= 50 and @potencia <= 150 begin return 1 end
	else if @potencia > 151 and @potencia <= 300 begin return 2 end
	else if @potencia > 300 begin return 3 end
	return 0
end

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




