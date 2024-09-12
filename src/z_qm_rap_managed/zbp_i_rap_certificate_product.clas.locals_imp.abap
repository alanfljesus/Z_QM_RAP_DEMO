CLASS lhc_Certificate DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Certificate RESULT result.
    METHODS setinitialvalues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR certificate~setinitialvalues.
    METHODS checkmaterial FOR VALIDATE ON SAVE
      IMPORTING keys FOR certificate~checkmaterial.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR certificate RESULT result.

    METHODS archiveversion FOR MODIFY
      IMPORTING keys FOR ACTION certificate~archiveversion RESULT result.

    METHODS newversion FOR MODIFY
      IMPORTING keys FOR ACTION certificate~newversion RESULT result.

    METHODS releaseversion FOR MODIFY
      IMPORTING keys FOR ACTION certificate~releaseversion RESULT result.
ENDCLASS.


CLASS lhc_Certificate IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD setInitialValues.
    READ ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
         ENTITY Certificate
         FIELDS ( CertStatus )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_certificates).

    " ADICIONAR NOVOS VALORES AO CRIAR UM CERTIFICADO
    IF lt_certificates IS NOT INITIAL.
      MODIFY ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
             ENTITY Certificate
             UPDATE
             FIELDS ( Version CertStatus )
             WITH VALUE #( FOR ls_certificate IN lt_certificates
                           ( %tky       = ls_certificate-%tky
                             version    = 1
                             CertStatus = 1 ) ).
    ENDIF.

    DATA lt_state       TYPE TABLE FOR CREATE zi_rap_certificate_product\_Stats.
    DATA ls_state       LIKE LINE OF lt_state.
    DATA ls_state_value LIKE LINE OF ls_state-%target.

    LOOP AT lt_certificates INTO DATA(ls_certificates).

      ls_state-%key = ls_certificates-%key.
      ls_state_value-CertUuid = ls_certificates-CertUuid.
      ls_state-CertUuid = ls_state_value-CertUuid.

      ls_state_value-Version   = 1.
      ls_state_value-StatusOld = space.
      ls_state_value-Status    = 1.

      ls_state_value-%control-Version       = if_abap_behv=>mk-on.
      ls_state_value-%control-StatusOld     = if_abap_behv=>mk-on.
      ls_state_value-%control-Status        = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedAt = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedBy = if_abap_behv=>mk-on.

      APPEND ls_state_value TO ls_state-%target.

      APPEND ls_state TO lt_state.

      MODIFY ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
             ENTITY Certificate
             CREATE BY \_Stats
             FROM lt_state
             REPORTED DATA(ls_return_ass)
             MAPPED   DATA(ls_mapped_ass)
             FAILED   DATA(ls_failed_ass).
    ENDLOOP.
  ENDMETHOD.

  METHOD checkMaterial.
    READ ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
        ENTITY Certificate
        FIELDS ( CertStatus )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_certificates).

    CHECK lt_certificates IS NOT INITIAL.

    SELECT * FROM zrap_product
      INTO TABLE @DATA(lt_material).

    LOOP AT lt_certificates INTO DATA(ls_certificates).

      IF NOT ( ls_certificates-Matnr IS INITIAL OR line_exists( lt_material[ matnr = ls_certificates-Matnr ] ) ).
        APPEND VALUE #( %tky = ls_certificates-%tky ) TO failed-certificate.

        APPEND VALUE #( %tky        = ls_certificates-%tky
                        %state_area = 'MATERIAL_UNKNOWN'
                        %msg        = NEW zcx_certificate( severity = if_abap_behv_message=>severity-error
                                                           textid   = zcx_certificate=>material_unknown
                                                           attr1    = CONV string( ls_certificates-Matnr )  ) )
               TO reported-certificate.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.
  METHOD get_instance_features.
  ENDMETHOD.

  METHOD archiveVersion.
    " SELECIONAR OS DADOS DA GRID DO APP PARA O ACTION
    READ ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
    ENTITY Certificate
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_certificates).

    " ADICIONAR UM NOVO LOG DE STATUS
    DATA lt_state       TYPE TABLE FOR CREATE zi_rap_certificate_product\_Stats.
    DATA ls_state       LIKE LINE OF lt_state.
    DATA ls_state_value LIKE LINE OF ls_state-%target.

    LOOP AT lt_certificates INTO DATA(ls_certificates).

      ls_state-%key = ls_certificates-%key.
      ls_state_value-CertUuid = ls_certificates-CertUuid.
      ls_state-CertUuid = ls_state_value-CertUuid.

      ls_state_value-Version   = ls_certificates-Version.
      ls_state_value-StatusOld = ls_certificates-CertStatus.
      ls_state_value-Status    = 3.

      ls_state_value-%control-Version       = if_abap_behv=>mk-on.
      ls_state_value-%control-StatusOld     = if_abap_behv=>mk-on.
      ls_state_value-%control-Status        = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedAt = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedBy = if_abap_behv=>mk-on.

      APPEND ls_state_value TO ls_state-%target.

      APPEND ls_state TO lt_state.

      MODIFY ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
             ENTITY Certificate
             CREATE BY \_Stats
             FROM lt_state
             REPORTED DATA(ls_return_ass)
             MAPPED   DATA(ls_mapped_ass)
             FAILED   DATA(ls_failed_ass).
    ENDLOOP.

    " MODIFICAR PARA UMA NOVA VERSÃO O PAI
    MODIFY ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
           ENTITY Certificate
           UPDATE
           FIELDS ( Version CertStatus Matnr )
           WITH VALUE #( FOR ls_modify IN lt_certificates
                         ( %tky       = ls_modify-%tky
                           Version    = ls_modify-Version + 1
                           Matnr      = ls_modify-Matnr
                           CertStatus = 3 ) )
           FAILED failed
           REPORTED reported.

    " MENSAGEM DE SUCESSO
    reported-certificate = VALUE #( FOR ls_report IN lt_certificates
                                    ( %tky = ls_report-%tky
                                      %msg = new_message( id       = 'Z_CERTIFICATE_MSG'
                                                          number   = '002'
                                                          severity = if_abap_behv_message=>severity-success ) ) ).

    " RETORNO PARA UM REFRESH DO FRONTEND
    result = VALUE #( FOR certificate IN lt_certificates
                      ( %tky   = certificate-%tky
                        %param = certificate ) ).
  ENDMETHOD.

  METHOD newVersion.
    " SELECIONAR OS DADOS DA GRID DO APP PARA O ACTION
    READ ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
    ENTITY Certificate
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_certificates).

    " ADICIONAR UM NOVO LOG DE STATUS
    DATA lt_state       TYPE TABLE FOR CREATE zi_rap_certificate_product\_Stats.
    DATA ls_state       LIKE LINE OF lt_state.
    DATA ls_state_value LIKE LINE OF ls_state-%target.

    LOOP AT lt_certificates INTO DATA(ls_certificates).

      ls_state-%key = ls_certificates-%key.
      ls_state_value-CertUuid = ls_certificates-CertUuid.
      ls_state-CertUuid = ls_state_value-CertUuid.

      ls_state_value-Version   = ls_certificates-Version + 1.
      ls_state_value-StatusOld = ls_certificates-CertStatus.
      ls_state_value-Status    = 1.

      ls_state_value-%control-Version       = if_abap_behv=>mk-on.
      ls_state_value-%control-StatusOld     = if_abap_behv=>mk-on.
      ls_state_value-%control-Status        = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedAt = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedBy = if_abap_behv=>mk-on.

      APPEND ls_state_value TO ls_state-%target.

      APPEND ls_state TO lt_state.

      MODIFY ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
             ENTITY Certificate
             CREATE BY \_Stats
             FROM lt_state
             REPORTED DATA(ls_return_ass)
             MAPPED   DATA(ls_mapped_ass)
             FAILED   DATA(ls_failed_ass).
    ENDLOOP.

    " MODIFICAR PARA UMA NOVA VERSÃO O PAI
    MODIFY ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
           ENTITY Certificate
           UPDATE
           FIELDS ( Version CertStatus Matnr )
           WITH VALUE #( FOR ls_modify IN lt_certificates
                         ( %tky       = ls_modify-%tky
                           Version    = ls_modify-Version + 1
                           Matnr      = ls_modify-Matnr
                           CertStatus = ls_modify-CertStatus ) )
           FAILED failed
           REPORTED reported.

    " MENSAGEM DE SUCESSO
    reported-certificate = VALUE #( FOR ls_report IN lt_certificates
                                    ( %tky = ls_report-%tky
                                      %msg = new_message( id       = 'Z_CERTIFICATE_MSG'
                                                          number   = '002'
                                                          severity = if_abap_behv_message=>severity-success ) ) ).

    " RETORNO PARA UM REFRESH DO FRONTEND
    result = VALUE #( FOR certificate IN lt_certificates
                      ( %tky   = certificate-%tky
                        %param = certificate ) ).
  ENDMETHOD.

  METHOD releaseVersion.
    " SELECIONAR OS DADOS DA GRID DO APP PARA O ACTION
    READ ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
    ENTITY Certificate
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_certificates).

    " ADICIONAR UM NOVO LOG DE STATUS
    DATA lt_state       TYPE TABLE FOR CREATE zi_rap_certificate_product\_Stats.
    DATA ls_state       LIKE LINE OF lt_state.
    DATA ls_state_value LIKE LINE OF ls_state-%target.

    LOOP AT lt_certificates INTO DATA(ls_certificates).

      ls_state-%key = ls_certificates-%key.
      ls_state_value-CertUuid = ls_certificates-CertUuid.
      ls_state-CertUuid = ls_state_value-CertUuid.

      ls_state_value-Version   = ls_certificates-Version.
      ls_state_value-StatusOld = ls_certificates-CertStatus.
      ls_state_value-Status    = 2.

      ls_state_value-%control-Version       = if_abap_behv=>mk-on.
      ls_state_value-%control-StatusOld     = if_abap_behv=>mk-on.
      ls_state_value-%control-Status        = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedAt = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedBy = if_abap_behv=>mk-on.

      APPEND ls_state_value TO ls_state-%target.

      APPEND ls_state TO lt_state.

      MODIFY ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
             ENTITY Certificate
             CREATE BY \_Stats
             FROM lt_state
             REPORTED DATA(ls_return_ass)
             MAPPED   DATA(ls_mapped_ass)
             FAILED   DATA(ls_failed_ass).
    ENDLOOP.

    " MODIFICAR PARA UMA NOVA VERSÃO O PAI
    MODIFY ENTITIES OF zi_rap_certificate_product IN LOCAL MODE
           ENTITY Certificate
           UPDATE
           FIELDS ( Version CertStatus Matnr )
           WITH VALUE #( FOR ls_modify IN lt_certificates
                         ( %tky       = ls_modify-%tky
                           Version    = ls_modify-Version + 1
                           Matnr      = ls_modify-Matnr
                           CertStatus = 2 ) )
           FAILED failed
           REPORTED reported.

    " MENSAGEM DE SUCESSO
    reported-certificate = VALUE #( FOR ls_report IN lt_certificates
                                    ( %tky = ls_report-%tky
                                      %msg = new_message( id       = 'Z_CERTIFICATE_MSG'
                                                          number   = '002'
                                                          severity = if_abap_behv_message=>severity-success ) ) ).

    " RETORNO PARA UM REFRESH DO FRONTEND
    result = VALUE #( FOR certificate IN lt_certificates
                      ( %tky   = certificate-%tky
                        %param = certificate ) ).
  ENDMETHOD.
ENDCLASS.
