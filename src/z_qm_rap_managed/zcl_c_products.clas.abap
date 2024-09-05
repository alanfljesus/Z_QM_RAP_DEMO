CLASS zcl_c_products DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_c_products IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    TYPES tt_products TYPE TABLE OF zrap_product WITH DEFAULT KEY.

    DATA(ls_product) = VALUE tt_products( ( matnr = '1' description = 'Celular'    language = 'P' )
                                          ( matnr = '2' description = 'Televisão'  language = 'P' )
                                          ( matnr = '3' description = 'Computador' language = 'P' )
                                          ( matnr = '1' description = 'Phone'      language = 'E' )
                                          ( matnr = '2' description = 'Television' language = 'E' )
                                          ( matnr = '3' description = 'Computer'   language = 'E' ) ).

    MODIFY zrap_product FROM TABLE @ls_product.

    out->write( 'Produtos cadastrados!' ).
  ENDMETHOD.
ENDCLASS.
