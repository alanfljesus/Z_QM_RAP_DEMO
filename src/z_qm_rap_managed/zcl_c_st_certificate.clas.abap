CLASS zcl_c_st_certificate DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_c_st_certificate IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    TYPES tt_certificates_st TYPE TABLE OF zrap_certif_st WITH DEFAULT KEY.

    DATA(ls_certificate_status) = VALUE tt_certificates_st( ( state_uuid = '1' cert_uuid = '1' matnr = '1' )
                                                            ( state_uuid = '2' cert_uuid = '2' matnr = '2' )
                                                            ( state_uuid = '3' cert_uuid = '3' matnr = '3' )
                                                            ( state_uuid = '4' cert_uuid = '3' matnr = '3' ) ).

    MODIFY zrap_certif_st FROM TABLE @ls_certificate_status.

    out->write( 'Certificados Status Cadastrados!' ).
  ENDMETHOD.
ENDCLASS.
