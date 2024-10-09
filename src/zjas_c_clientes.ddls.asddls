@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Clientes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZJAS_C_CLIENTES
  as select from zjas_tb_clientes as Clientes
    inner join   zjas_tb_clnt_lib as ClientesLibros on ClientesLibros.id_cliente = Clientes.id_cliente
{
  key ClientesLibros.id_libro   as IdLibro,
  key ClientesLibros.id_cliente as IdCliente,
  key Clientes.tipo_acceso      as Acceso,
      Clientes.nombre           as Nombre,
      Clientes.apellidos        as Apellidos,
      Clientes.email            as Email,
      Clientes.url              as Imagen
}
