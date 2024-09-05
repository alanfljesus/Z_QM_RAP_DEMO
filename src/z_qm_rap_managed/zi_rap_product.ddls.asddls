@AbapCatalog.sqlViewName: 'ZRAPV_PROD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic - Products'
define view ZI_RAP_PRODUCT
  as select from zrap_product
{
  key matnr       as Matnr,
  key language    as Language,
      description as Description
}
