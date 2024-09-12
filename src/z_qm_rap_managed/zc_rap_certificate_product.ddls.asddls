@EndUserText.label: 'Consumption - Certificates'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_RAP_CERTIFICATE_PRODUCT
  as projection on ZI_RAP_CERTIFICATE_PRODUCT
{
  key CertUuid,
      Matnr,
      Description,
      Version,
      CertStatus,
      CertCe,
      CertGs,
      CertFcc,
      CertIso,
      CertTuev,
      LocalLastChangedAt,
      Icon,
      /* Associations */
      _Product,
      _Stats: redirected to composition child ZC_RAP_CERTIF_ST_PRODUCT
}
