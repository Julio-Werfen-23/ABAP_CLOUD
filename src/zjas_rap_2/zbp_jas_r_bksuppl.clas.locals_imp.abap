CLASS lhc_BookingSupplements DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR BookingSupplements RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR BookingSupplements RESULT result.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR BookingSupplements~calculateTotalPrice.

    METHODS setBookingSupplNumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR BookingSupplements~setBookingSupplNumber.

    METHODS validateBookSupplPrice FOR VALIDATE ON SAVE
      IMPORTING keys FOR BookingSupplements~validateBookSupplPrice.

    METHODS validateCurrencyCode FOR VALIDATE ON SAVE
      IMPORTING keys FOR BookingSupplements~validateCurrencyCode.

    METHODS validateSupplement FOR VALIDATE ON SAVE
      IMPORTING keys FOR BookingSupplements~validateSupplement.

ENDCLASS.

CLASS lhc_BookingSupplements IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD calculateTotalPrice.
  ENDMETHOD.

  METHOD setBookingSupplNumber.
  ENDMETHOD.

  METHOD validateBookSupplPrice.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateSupplement.
  ENDMETHOD.

ENDCLASS.
