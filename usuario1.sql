


select u.IdUsuario,u.Documento,u.NombreCompleto,u.Correo,u.Clave,u.Estado,r.IdRol, r.Descripcion from usuario u
inner join rol r on r.IdRol = u.IdRol

update USUARIO set estado = 0 where idusuario = 3


insert into ROL (Descripcion)
values ('ADMINISTRADOR')

insert into ROL (Descripcion)
values ('EMPLEADO')

insert USUARIO(Documento,NombreCompleto,Correo,Clave,IdRol,Estado)
values

('20','EMPLEADO','@GMAIL.COM','456',3,1)


select * from ROL

select *from PERMISO

select p.IdRol,p.NombreMenu from PERMISO p
inner join ROL r on r.IdRol = p.IdRol
inner join USUARIO u on u.IdRol = r.IdRol
where u.IdUsuario = 1


insert into PERMISO (IdRol,NombreMenu) values 
(1,'MenuUsuario'),
(1,'MenuServicios'),
(1,'MenuCitas'),
(1,'MenuVentas'),
(1,'MenuClientes'),
(1,'MenuProveedores')

insert into PERMISO (IdRol,NombreMenu) values 
(2,'MenuUsuario'),
(2,'MenuServicios'),
(2,'MenuCitas'),
(2,'MenuVentas'),
(2,'MenuClientes'),
(2,'MenuProveedores')

insert into PERMISO (IdRol,NombreMenu) values 
(3,'MenuCitas'),
(3,'MenuVentas'),
(3,'MenuClientes'),
(3,'MenuProveedores')