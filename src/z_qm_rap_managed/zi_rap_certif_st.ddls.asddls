@AbapCatalog.sqlViewName: 'ZRAPV_CERT_ST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic - Status of Certificates'
define view ZI_RAP_CERTIF_ST
  as select from zrap_certif_st
{
  key state_uuid            as StateUuid,
      cert_uuid             as CertUuid,
      matnr                 as Matnr,
      version               as Version,
      status                as Status,
      status_old            as StatusOld,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
