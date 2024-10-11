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

    DATA max_booking_supplement_id TYPE /dmo/booking_id.
    DATA bookings_supplements_update TYPE TABLE FOR UPDATE zjas_r_travel\\BookingSupplements.

    READ ENTITIES OF zjas_r_travel IN LOCAL MODE
            ENTITY BookingSupplements BY \_Booking
            FIELDS ( BookingUUID )
            WITH CORRESPONDING #( keys )
            RESULT DATA(bookings).

    LOOP AT bookings INTO DATA(booking).

      READ ENTITIES OF zjas_r_travel IN LOCAL MODE
            ENTITY Booking BY \_BookingSupplement
            FIELDS ( BookingSupplementID )
            WITH VALUE #( ( %tky = booking-%tky ) )
            RESULT DATA(bookingsupplements).

      max_booking_supplement_id = '00'.

      LOOP AT bookingsupplements INTO DATA(bookingsupplement).
        IF bookingsupplement-BookingSupplementID > max_booking_supplement_id.
          max_booking_supplement_id = bookingsupplement-BookingSupplementID.
        ENDIF.
      ENDLOOP.

      LOOP AT bookingsupplements INTO bookingsupplement WHERE BookingSupplementID IS INITIAL.
        max_booking_supplement_id += 1.

        APPEND VALUE #( %tky = bookingsupplement-%tky
                        BookingSupplementID = max_booking_supplement_id ) TO bookings_supplements_update.
      ENDLOOP.

      MODIFY ENTITIES OF zjas_r_travel IN LOCAL MODE
                ENTITY BookingSupplements
                UPDATE FIELDS ( BookingSupplementID )
                WITH bookings_supplements_update.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateBookSupplPrice.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateSupplement.
  ENDMETHOD.

ENDCLASS.
