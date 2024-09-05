@AbapCatalog.sqlViewName: 'ZRAPV_CERTIF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic - Certificates'
define view ZI_RAP_CERTIFICATE
  as select from zrap_certificate
{
  key cert_uuid             as CertUuid,
      matnr                 as Matnr,
      version               as Version,
      cert_status           as CertStatus,
      cert_ce               as CertCe,
      cert_gs               as CertGs,
      cert_fcc              as CertFcc,
      cert_iso              as CertIso,
      cert_tuev             as CertTuev,
      local_last_changed_at as LocalLastChangedAt
}
