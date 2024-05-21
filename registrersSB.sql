



SELECT IdCategoria,Descripcion,Estado from CATEGORIA
insert into CATEGORIA(Descripcion,Estado) values('Peluqueria',1)
insert into CATEGORIA(Descripcion,Estado) values('Spa',1)
insert into CATEGORIA(Descripcion,Estado) values('Salon',1)
insert into CATEGORIA(Descripcion,Estado) values('Boutique',1)



insert into PRODUCTO(Codigo,Nombre,Descripcion,IdCategoria) values ('101010', 'Esmalte para uñas', 'Marca: Revlon Modelo: Classic Nail Enamel',4)

select * from USUARIO
select * from CATEGORIA
select * from PRODUCTO
select * from VENTA where NumeroDocumento = '00001'
select * from DETALLE_VENTA where IdVenta = 1

update PRODUCTO set Stock = Stock - @cantidad where IdProducto = @idproducto

/* Para ver si s registro*/
select * from  COMPRA where NumeroDocumento = '00001'
/*busqueda en detalle de compra*/
select * from DETALLE_COMPRA where IdCompra = 1


CREATE PROC SP_REGISTRARUSUARIO(
@Documento varchar (50),
@NombreCompleto varchar (100),
@Correo varchar (100), 
@Clave varchar (100),
@IdRol int,
@Estado bit,
@IdUsuarioResultado int output,
@Mensaje varchar (500) output
)
as
begin
	set @IdUsuarioResultado = 0
	set @Mensaje = ''

	if not exists(select * from USUARIO where Documento = @Documento)
	begin
		insert into USUARIO(Documento,NombreCompleto,Correo,Clave,IdRol,Estado) values
		(@Documento,@NombreCompleto,@Correo,@Clave,@IdRol,@Estado)

		set @IdUsuarioResultado = SCOPE_IDENTITY()
		

		end
		else
			set @Mensaje = 'No se puede repetir el documento para más de un usuario'


end
go

CREATE PROC SP_EDITARUSUARIO(
@IdUsuario int,
@Documento varchar (50),
@NombreCompleto varchar (100),
@Correo varchar (100), 
@Clave varchar (100),
@IdRol int,
@Estado bit,
@Respuesta bit output,
@Mensaje varchar (500) output
)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''

	if not exists(select * from USUARIO where Documento = @Documento and IdUsuario != @IdUsuario)
	begin
		update USUARIO set 
		Documento = @Documento,
		NombreCompleto= @NombreCompleto,
		Correo = @Correo,
		Clave = @Clave,
		IdRol = @IdRol,
		Estado = @Estado
		where IdUsuario = @IdUsuario

		set @Respuesta = 1
		

		end
		else
			set @Mensaje = 'No se puede repetir el documento para más de un usuario'


end

go


CREATE PROC SP_ELIMINARUSUARIO(
@IdUsuario int,
@Respuesta bit output,
@Mensaje varchar (500) output
)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''
	declare @pasoreglas bit = 1

	IF EXISTS (SELECT * FROM COMPRA C 
	INNER JOIN USUARIO U ON U.IdUsuario = C.IdUsuario
	WHERE u.IdUsuario = @IdUsuario
	)

	begin
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar. El usuario se encuentra relacionado a una COMPRA\n'
	end

	IF EXISTS (SELECT * FROM VENTA V 
	INNER JOIN USUARIO U ON U.IdUsuario = V.IdUsuario
	WHERE u.IdUsuario = @IdUsuario
	)

	begin
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar. El usuario se encuentra relacionado a una VENTA\n'
	end

	if(@pasoreglas = 1)
	begin
		delete from USUARIO where IdUsuario = @IdUsuario
		set @Respuesta = 1
		end

end



/* ----------------- Procedimientos categoria ------------------ */

--Procedimiento para guardar categoria--
CREATE PROC SP_RegistrarCategoria(
@Descripcion varchar (50),
@Estado bit,
@Resultado int output,
@Mensaje varchar (500) output
)as
begin
	SET @Resultado = 0
	IF NOT EXISTS (select * from CATEGORIA where Descripcion = @Descripcion)
	begin
		insert into  CATEGORIA(Descripcion,Estado) values (@Descripcion,@Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	ELSE
		set @Mensaje = 'No se puede repetir la descripción de una categoria'
end

go

--Procedimiento para editar la categoria--
CREATE PROC SP_EditarCategoria(
@IdCategoria int,
@Descripcion varchar (50),
@Estado bit,
@Resultado bit output,
@Mensaje varchar (500) output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (select * from CATEGORIA where Descripcion = @Descripcion and IdCategoria != @IdCategoria)
	
		update CATEGORIA set
		Descripcion = @Descripcion,
		Estado = @Estado
		where IdCategoria = @IdCategoria
	ELSE
	begin
		SET @Resultado = 0
		set @Mensaje = 'No se puede repetir la descripción de una categoria'
	end

end


go

--Procedimiento para eliminar la categoria--
CREATE PROC SP_EliminarCategoria(
@IdCategoria int,
@Resultado bit output,
@Mensaje varchar (500) output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (
	select * from CATEGORIA	c
	inner join PRODUCTO p on p.IdCategoria = c.IdCategoria
	where c.IdCategoria = @IdCategoria
	)begin
		delete top(1) from CATEGORIA where IdCategoria = @IdCategoria
	end

	ELSE
	begin
		SET @Resultado = 0
		set @Mensaje = 'La categoria se encuentra relacionada a un producto'
	end

end

go


/* -------------------- PROCESO PARA PRODCUTOS --------------*/
CREATE PROC sp_RegistrarProducto(
@Codigo varchar (50),
@Nombre varchar (30),
@Descripcion varchar (30),
@IdCategoria int,
@Estado bit,
@Resultado bit output,
@Mensaje varchar (500) output
)as
begin
	SET @Resultado = 0
	IF not exists (select * from PRODUCTO where Codigo = @Codigo)
	begin
		insert into PRODUCTO(Codigo,Nombre,Descripcion,IdCategoria,Estado) values (@Codigo,@Nombre,@Descripcion,@IdCategoria,@Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	ELSE
		SET @Mensaje = 'Ya existe un producto con el mismo codigo'

end

GO

select * from PRODUCTO

----------MODIFICAR PRODU -----------

create procedure SP_ModificarProducto(
@IdProducto int,
@Codigo varchar (20),
@Nombre varchar (30),
@Descripcion varchar (100),
@IdCategoria int,
@Estado bit,
@Resultado bit output,
@Mensaje varchar (500) output
)
as
begin
	SET @Resultado = 1
	IF not exists (select * from PRODUCTO where Codigo = @Codigo and IdProducto != @IdProducto

		update PRODUCTO set
		codigo = @Codigo,
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		IdCategoria = @IdCategoria,
		Estado = @Estado
		where IdProducto = @IdProducto

	ELSE

	begin
		SET @Resultado = 0
		SET @Mensaje = 'Ya existe un producto con el mismo codigo'
	end
end

go

--------ELIMINAR PRODU----------

CREATE PROC SP_EliminarProducto(
@IdProducto int,
@Respuesta bit output,
@Mensaje varchar (500) output
)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''
	declare @pasoreglas bit = 1

	IF exists (select * from DETALLE_COMPRA dc
	inner join PRODUCTO p on p.IdProducto = dc.IdProducto
	where p.IdProducto = @IdProducto
	)
	BEGIN
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar porque se encuentra relacionado a una COMPRA\n'
	END

	IF exists (select * from DETALLE_VENTA dv
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	where p.IdProducto = @IdProducto
	)
	BEGIN
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar porque se encuentra relacionado a una VENTA\n'
	END

	if(@pasoreglas = 1)
	begin
		delete from PRODUCTO WHERE IdProducto = @IdProducto
		set @Respuesta = 1
	end

	end

	go




	/* ----------------PROCEDIMIENTO REGISTRO CLIENTES -------------- */
	CREATE PROC SP_RegistrarCliente(
	@Documento varchar (50),
	@NombreCompleto varchar (50),
	@Correo varchar (50),
	@Telefono varchar (50),
	@Estado bit,
	@Resultado int output,
	@Mensaje varchar (500) output
	)as
	begin
		SET @Resultado = 0
		DECLARE @IDPERSONA INT
		if not exists (select * from CLIENTE where Documento = @Documento)
		begin
			insert into CLIENTE(Documento,NombreCompleto,Correo,Telefono,Estado) values (
			@Documento,@NombreCompleto,@Correo,@Telefono,@Estado)

			set @Resultado = SCOPE_IDENTITY()
		end
		else
			set @Mensaje = 'El numero de documento ya existe'
end
go

/*-------------EDITAR CLIENTE--------*/
CREATE PROC SP_ModificarCliente (
@IdCliente int,
@Documento varchar (50),
@NombreCompleto varchar (50),
@Correo varchar (50),
@Telefono varchar (50),
@Estado bit,
@Resultado int output,
@Mensaje varchar (500) output
)as
begin
	SET @Resultado = 1
	DECLARE @IDPERSONA INT
	if not exists (select * from CLIENTE where Documento = @Documento and IdCliente != @IdCliente)
	begin
		update CLIENTE set
		Documento = @Documento,
		NombreCompleto = @NombreCompleto,
		Correo = @Correo,
		Telefono = @Telefono,
		Estado = @Estado
		where IdCliente = @IdCliente
	end
	else
	begin
		SET @Resultado = 0
		set @Mensaje = 'El numero de documento ya existe'
	end
end

go


/*********** REGRITAR PROVEEDORES *********/
create PROC SP_RegistrarProveedor(
@Documento varchar (50),
@RazonSocial varchar (50),
@Correo varchar (50),
@Telefono varchar (50),
@Estado bit,
@Resultado int output,
@Mensaje varchar (500) output
)
as
begin
	SET @Resultado = 0
	DECLARE @IDPERSONA INT
	IF not exists (select * from PROVEEDOR where Documento = @Documento)
	begin
		insert into PROVEEDOR(Documento,RazonSocial,Correo,Telefono,Estado) values (
		@Documento,@RazonSocial,@Correo,@Telefono,@Estado)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'El numero de documento ya existe'
end

GO

/*********** MODIFICAR ESTADO **********/
create PROC SP_ModificarProveedor(
@IdProveedor int,
@Documento varchar (50),
@RazonSocial varchar (50),
@Correo varchar (50),
@Telefono varchar (50),
@Estado bit,
@Resultado bit output,
@Mensaje varchar (500) output
)as
begin
	SET @Resultado = 1
	DECLARE @IDPERSONA INT
	IF not exists (select * from PROVEEDOR where Documento = @Documento and IdProveedor != @IdProveedor)
	begin
		update PROVEEDOR set
		Documento = @Documento,
		RazonSocial = @RazonSocial,
		Correo = @Correo,
		Telefono = @Telefono,
		Estado = @Estado
		where IdProveedor = @IdProveedor
	end
	else
	begin
		SET @Resultado = 0
		set @Mensaje = 'El documento ya existe'
		end
end

go


/*******ELIMINAR PROVEEDOR ******/
create proc SP_EliminarProveedor(
@IdProveedor int,
@Resultado bit output,
@Mensaje varchar (500) output
)as
begin
	SET @Resultado = 1
	IF not exists (select * from PROVEEDOR p 
	inner join COMPRA c on p.IdProveedor = c.IdProveedor
	where p.IdProveedor = @IdProveedor
	)
	begin
		delete top(1) from PROVEEDOR where IdProveedor = @IdProveedor
		end
		else
		begin
		SET @Resultado = 0
		set @Mensaje = 'El proveedor se encuentra relacionado a una compra'
	end

end
go

select IdProveedor,Documento,RazonSocial,Correo,Telefono,Estado from PROVEEDOR

select* from PROVEEDOR

select * from NEGOCIO

insert into NEGOCIO(IdNegocio,Nombre,RUC,Direccion) values (1,'Saint Salon','101010','Av. Colorines 400')
go


/* PROCESOS PARA REGISTRAR UNA COMPRA*/

CREATE TYPE [dbo].[Detalle_Compra] AS TABLE(
	[IdProducto] int NULL,
	[PrecioCompra] decimal (18,2) NULL,
	[PrecioVenta] decimal (18,2) NULL,
	[Cantidad] int NULL,
	[MontoTotal] decimal (18,2) NULL
)
GO


--00001
--00002

select count(*) +1 from COMPRA

CREATE PROCEDURE SP_RegistrarCompra(
@IdUsuario int,
@IdProveedor int,
@TipoDocumento varchar (500),
@NumeroDocumento varchar (500),
@MontoTotal decimal (18,2),
@DetalleCompra [Detalle_Compra] READONLY,
@Resultado bit output,
@Mensaje varchar (500) output
)
as
begin
	begin try
		declare @idcompra int = 0
		set @Resultado = 1
		set @Mensaje = ''

		begin transaction registro
			
			insert into COMPRA(IdUsuario,IdProveedor,TipoDocumento,NumeroDocumento,MontoTotal)
			values (@IdUsuario,@IdProveedor,@TipoDocumento,@NumeroDocumento,@MontoTotal)

			set @idcompra = SCOPE_IDENTITY()

			insert into DETALLE_COMPRA(IdCompra,IdProducto,PrecioCompra,PrecioVenta,Cantidad,MontoTotal)
			select @idcompra,IdProducto,PrecioCompra,PrecioVenta,Cantidad,MontoTotal from @DetalleCompra

			update p set p.Stock = p.Stock + dc.Cantidad,
			p.PrecioCompra = dc.PrecioCompra,
			p.PrecioVenta = dc.PrecioVenta
			from PRODUCTO p
			inner join @DetalleCompra dc on dc.IdProducto = p.IdProducto

		commit transaction registro


	end try

	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch


end

go


/*DETALLES COMPRA*/
select c.IdCompra,
u.NombreCompleto,
pr.Documento,pr.RazonSocial,
c.TipoDocumento,c.NumeroDocumento,c.MontoTotal,CONVERT(char(10),c.FechaRegistro,103)[FechaRegistro]
from COMPRA c
inner join USUARIO u on u.IdUsuario = c.IdUsuario
inner join PROVEEDOR pr on pr.IdProveedor = c.IdProveedor
where c.NumeroDocumento = '00001'


select p.Nombre,dc.PrecioCompra,dc.Cantidad,dc.MontoTotal
from DETALLE_COMPRA dc
inner join PRODUCTO p on p.IdProducto = dc.IdProducto
where dc.IdCompra = 1


/* Procesos para registrar un venta*/
CREATE TYPE [dbo].[EDetalle_Venta] AS TABLE (
	[IdProducto] int NULL,
	[PrecioVenta] decimal (18,2) NULL,
	[Cantidad] int NULL,
	[SubTotal] decimal (18,2)NULL

)

GO

/*REGISTRAR VENTA*/
create procedure usp_RegistrarVenta(
@IdUsuario int,
@TipoDocumento varchar(500),
@NumeroDocumento varchar(500),
@DocumentoCliente varchar(500),
@NombreCliente varchar(500),
@MontoPago decimal(18,2),
@MontoCambio decimal(18,2),
@MontoTotal decimal(18,2),
@DetalleVenta [EDetalle_Venta] READONLY,                                      
@Resultado bit output,
@Mensaje varchar(500) output
)
as
begin
	
	begin try

		declare @idventa int = 0
		set @Resultado = 1
		set @Mensaje = ''

		begin  transaction registro

		insert into VENTA(IdUsuario,TipoDocumento,NumeroDocumento,DocumentoCliente,NombreCliente,MontoPago,MontoCambio,MontoTotal)
		values(@IdUsuario,@TipoDocumento,@NumeroDocumento,@DocumentoCliente,@NombreCliente,@MontoPago,@MontoCambio,@MontoTotal)

		set @idventa = SCOPE_IDENTITY()

		insert into DETALLE_VENTA(IdVenta,IdProducto,PrecioVenta,Cantidad,SubTotal)
		select @idventa,IdProducto,PrecioVenta,Cantidad,SubTotal from @DetalleVenta

		commit transaction registro

	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch

end

go


/*venta*/
select v.IdVenta,u.NombreCompleto,
v.DocumentoCliente,v.NombreCliente,
v.TipoDocumento,v.NumeroDocumento,
v.MontoPago,v.MontoCambio,v.MontoTotal,
CONVERT(char(10),v.FechaRegistro,103)[FechaRegistro]
from VENTA v
inner join USUARIO u on u.IdUsuario = v.IdUsuario
where v.NumeroDocumento = '00001'

/*detalle productos en la venta*/
select 
p.Nombre,dv.PrecioVenta,dv.Cantidad,dv.SubTotal
from DETALLE_VENTA dv
inner join PRODUCTO p on p.IdProducto = dv.IdProducto
where dv.IdVenta = 1