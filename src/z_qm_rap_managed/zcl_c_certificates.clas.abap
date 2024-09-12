CLASS zcl_c_certificates DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_c_certificates IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    TYPES tt_certificates TYPE TABLE OF zrap_certificate WITH DEFAULT KEY.

    DELETE FROM zrap_certificate.

*    DATA(ls_certificate) = VALUE tt_certificates( ( cert_uuid = '1' matnr = '1' )
*                                                  ( cert_uuid = '2' matnr = '2' )
*                                                  ( cert_uuid = '3' matnr = '3' ) ).
*
*    MODIFY zrap_certificate FROM TABLE @ls_certificate.

    out->write( 'Certificados cadastrados!' ).
  ENDMETHOD.
ENDCLASS.
