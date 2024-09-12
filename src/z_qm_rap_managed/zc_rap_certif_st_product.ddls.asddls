@EndUserText.label: 'Consumption - Certificates Status'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_RAP_CERTIF_ST_PRODUCT
  as projection on ZI_RAP_CERTIF_ST_PRODUCT
{
  key StateUuid,
      CertUuid,
      Matnr,
      Description,
      Version,
      Status,
      StatusOld,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Certif: redirected to parent ZC_RAP_CERTIFICATE_PRODUCT
}
