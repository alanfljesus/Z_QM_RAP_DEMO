@AbapCatalog.sqlViewName: 'ZRAPC_C_ST_P'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Composite - Certificate Status With Product'
define view ZI_RAP_CERTIF_ST_PRODUCT
  as select from ZI_RAP_CERTIF_ST
  association        to parent ZI_RAP_CERTIFICATE_PRODUCT as _Certif  on $projection.CertUuid = _Certif.CertUuid
  association [1..1] to ZI_RAP_PRODUCT                    as _Product on $projection.Matnr = _Product.Matnr
{
  key StateUuid,
      CertUuid,
      Matnr,
      _Product.Description as Description,
      Version,
      Status,
      StatusOld,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      _Certif
}
