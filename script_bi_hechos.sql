use GD2C2020;

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
)

create table varcharizard.BI_venta_autoparte(
	autoparte_id bigint foreign key references varcharizard.BI_autoparte,
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
	factura_precio decimal(18,2)
)

CREATE TABLE varcharizard.BI_compra_autoparte(
	autoparte_id bigint foreign key references varcharizard.BI_autoparte,
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
	factura_precio decimal(18,2)	
)

create function varcharizard.rango_potencia (@potencia int) returns int as
begin
	if @potencia < 50 begin return 0 end
	else if @potencia >= 50 and @potencia <= 150 begin return 1 end
	else if @potencia > 151 and @potencia <= 300 begin return 2 end
	else if @potencia > 300 begin return 3 end
	return 0
end

insert into VARCHARIZARD.BI_venta_automovil
select fac.cliente_id, fac.factura_fecha, fac.sucursal_id, a.cod_modelo, m.cod_fabricante,
		m.cod_auto, m.cod_caja, m.tipo_motor_codigo, m.cod_transmision,
		varcharizard.rango_potencia(m.modelo_potencia) potencia_id,
		fac.factura_precio
from VARCHARIZARD.Factura_Automovil fac
 join VARCHARIZARD.automovil a on fac.automovil_id = a.automovil_id
 join VARCHARIZARD.Modelo m on a.cod_modelo = m.modelo_id
;
