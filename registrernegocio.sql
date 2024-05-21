

create table DETALLE_VENTA(
IdDetalleVenta int primary key identity,
IdVenta int references VENTA(IdVenta),
IdProducto int references PRODUCTO(IdProducto),
PrecioVenta decimal (10,2),
Cantidad int,
SubTotal decimal (10,2),
FechadeRegistro datetime default getdate()
)

go

create table NEGOCIO(
IdNegocio int primary key,
Nombre varchar (60),
RUC varchar (60),
Direccion varchar (60),
Logo varbinary (max) NULL
)
