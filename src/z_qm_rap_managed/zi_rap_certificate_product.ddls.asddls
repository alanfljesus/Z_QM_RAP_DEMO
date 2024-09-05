@AbapCatalog.sqlViewName: 'ZRAPC_C_P'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Composite - Certificate With Product'
define root view ZI_RAP_CERTIFICATE_PRODUCT
  as select from ZI_RAP_CERTIFICATE
  composition [1..*] of ZI_RAP_CERTIF_ST_PRODUCT as _Stats
  association [1..1] to ZI_RAP_PRODUCT as _Product on $projection.Matnr = _Product.Matnr
{
  key CertUuid,
      Matnr,
      _Product[ Language = $session.system_language ].Description as Description,
      Version,
      CertStatus,
      CertCe,
      CertGs,
      CertFcc,
      CertIso,
      CertTuev,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      _Product,
      _Stats
}
