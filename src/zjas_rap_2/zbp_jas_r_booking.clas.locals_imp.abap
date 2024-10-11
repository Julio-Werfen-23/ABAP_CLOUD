CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Booking RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Booking RESULT result.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalPrice.

    METHODS setBookingDate FOR DETERMINE ON SAVE
      IMPORTING keys FOR Booking~setBookingDate.

    METHODS setBookingNumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR Booking~setBookingNumber.

    METHODS validateConnection FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateConnection.

    METHODS validateCurrencyCode FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateCurrencyCode.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateCustomer.

    METHODS validateFlightPrice FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateFlightPrice.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateStatus.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD calculateTotalPrice.
  ENDMETHOD.

  METHOD setBookingDate.
  ENDMETHOD.

  METHOD setBookingNumber.

    DATA max_booking_id TYPE /dmo/booking_id.
    DATA bookings_update TYPE TABLE FOR UPDATE zjas_r_travel\\Booking.

    READ ENTITIES OF zjas_r_travel IN LOCAL MODE
            ENTITY Booking BY \_Travel
            FIELDS ( TravelUUID )
            WITH CORRESPONDING #( keys )
            RESULT DATA(travels).

    LOOP AT travels INTO DATA(travel).

      READ ENTITIES OF zjas_r_travel IN LOCAL MODE
            ENTITY Travel BY \_Booking
            FIELDS ( BookingID )
            WITH VALUE #( ( %tky = travel-%tky ) )
            RESULT DATA(bookings).

      max_booking_id = '0000'.

      LOOP AT bookings INTO DATA(booking).
        IF booking-BookingID > max_booking_id.
          max_booking_id = booking-BookingID.
        ENDIF.
      ENDLOOP.

      LOOP AT bookings INTO booking WHERE BookingID IS INITIAL.
        max_booking_id += 1.

        APPEND VALUE #( %tky = booking-%tky
                        BookingID = max_booking_id ) TO bookings_update.
      ENDLOOP.

      MODIFY ENTITIES OF zjas_r_travel IN LOCAL MODE
                ENTITY Booking
                UPDATE FIELDS ( BookingID )
                WITH bookings_update.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateConnection.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateCustomer.
  ENDMETHOD.

  METHOD validateFlightPrice.
  ENDMETHOD.

  METHOD validateStatus.
  ENDMETHOD.

ENDCLASS.
