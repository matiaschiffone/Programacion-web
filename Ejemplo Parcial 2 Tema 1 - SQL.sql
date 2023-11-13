-- 1

-- Creando la nueva tabla
CREATE TABLE factura_cabecera
(
	id int primary key not null,
	fecha_emision datetime,
	monto decimal(4,2),
)

-- Agrega campo nuevo en solicitud_qr
alter table solicitud_qr add factura_cabecera_id int;

-- Agrega la FK en solicitud_qr
alter table solicitud_qr 
add constraint fk_solicitud_qr_factura_cabecera
foreign key (factura_cabecera_id)
references factura_cabecera.id;
-- references factura_cabecera (id);
--> agregar foreign key

--Agregar check para que solo se ingrese un solo id por registro
ALTER TABLE solicitud_qr
ADD CONSTRAINT check_id CHECK (
    (id_pc is NOT null AND id_dispositivo is null and factura_cabecera_id is null)
 OR (id_pc is null AND id_dispositivo is NOT null and factura_cabecera_id is null)
 OR (id_pc is null AND id_dispositivo is null and factura_cabecera_id is NOT null)
);

/*
create table solicitud_qr
(
	id_solicita int
	, qr varchar(500)
	, fec_solicitud datetime
	, fec_cancelacion datetime
	, id_pc int
	, id_dispositivo int
)
*/

--
-- 2
/*
 Necesitamos hacer un trigger sobre la tabla solicitud_qr  para que al
 momento de insertar verifique que se cumpla la condición de hasta registros
 en la misma hora de lo contrario hacer un rollback.
 Esto mismo debemos hacer al momento de modificar una fecha y hora para ver
 que se mantenga la condicion de hasta 3 de lo contrario cancelar la operación
*/
GO
CREATE TRIGGER tr_insert_solicitud_no_mas_de_tres
on solicitud_qr for insert
AS
begin
	declare @fec_solcitud_insert datetime
	declare @id_pc int, @id_dispositivo int, @factura_cabecera_id int

	select 
		@fec_solcitud_insert = fec_solicitud,
		@id_pc = isnull(id_pc,0),
		@id_dispositivo = isnull(id_dispositivo, 0),
		@factura_cabecera_id = isnull(factura_cabecera_id, 0)
	from inserted

	if( 
		(
		select COUNT(*) from solicitud_qr 
		where 
			abs(DATEDIFF(MINUTE, @fec_solcitud_insert, fec_solicitud)) < 60
			and @id_pc = isnull(id_pc,0)
			and @id_dispositivo = isnull(id_dispositivo,0)
			and @factura_cabecera_id = isnull(factura_cabecera_id,0)
		) > 3
	)
	begin
		rollback
		RAISERROR ('SUPERA LA CANTIDAD DE REGISTROS PARA MISMA HORA', 1, 1); 
	end
	
	declare @cantidad_registros int
	select @cantidad_registros = COUNT(*) from solicitud_qr 
	where YEAR(@fec_solcitud_insert) = YEAR(fec_solicitud)
	and Month(@fec_solcitud_insert) = month(fec_solicitud)
	and day(@fec_solcitud_insert) = day(fec_solicitud)
	and datepart(hour, @fec_solcitud_insert) = datepart(hour, fec_solicitud)
	and @id_pc = isnull(id_pc,0)
	and @id_dispositivo = isnull(id_dispositivo,0)
	and @factura_cabecera_id = isnull(factura_cabecera_id,0)

	if( @cantidad_registros > 3 )
	begin
		rollback
		RAISERROR ('SUPERA LA CANTIDAD DE REGISTROS PARA MISMA HORA', 16, 1); 
	end

end
GO

-- 3
-- El resultado que se obtien
/*
-- El resultado me muestra OPCION 1, cuando para el dia la cantidad maxima para un id_pc es superior a la cantidad maxima para un id_positivio

*/

-- 4
/*
4)	Si quisiera generar un procedure que contenga al query anterior, pero que en lugar 
de imprimir opción 1 o 2, retorne un 1 o 2 según el caso. Desarrolle el procedure que 
resultaría e indique un ejemplo de cómo ejecutarlo. No es necesario que copie todo el 
código sino las partes que modificaría (1 punto).
*/
--DESARROLLO DE SP
CREATE PROCEDURE NOMBRE
AS
BEGIN
	declare @cant1 int, @cant2 int, @xx int, @yy int 
  -- DEJO TODO HASTA DEJANDO FUERA EL IF FINAL
  if @cant1 > @cant2
   return 1
else
   return 2
END
GO

--EJEMPLO DE EJECUTARLO SP
declare @resultado int
exec @resultado = NOMBRE

select @resultado resultado

if @resultado = 1
   print ('opcion 1')
else
   print('opcion 2')
GO

CREATE PROCEDURE NOMBRE2
	@resultado int output
AS
BEGIN
	declare @cant1 int, @cant2 int, @xx int, @yy int 
  -- DEJO TODO HASTA DEJANDO FUERA EL IF FINAL
  if @cant1 > @cant2
   set @resultado = 1
else
   set @resultado = 2
END
GO

declare @resultado2 int
exec NOMBRE2 @resultado2 output

 select @resultado2 resultado

if @resultado2 = 1
   print ('opcion 1')
else
   print('opcion 2')
