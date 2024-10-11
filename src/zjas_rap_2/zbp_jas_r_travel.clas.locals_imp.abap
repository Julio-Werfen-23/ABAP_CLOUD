CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF travel_status,
        open     TYPE c LENGTH 1 VALUE 'O', "Open
        accepted TYPE c LENGTH 1 VALUE 'A', "Accepted
        rejected TYPE c LENGTH 1 VALUE 'X', "Rejected
      END OF travel_status.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS precheck_create FOR PRECHECK
      IMPORTING entities FOR CREATE Travel.

    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE Travel.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS deductDiscount FOR MODIFY
      IMPORTING keys FOR ACTION Travel~deductDiscount RESULT result.

    METHODS reCalcTotalPrice FOR MODIFY
      IMPORTING keys FOR ACTION Travel~reCalcTotalPrice.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS Resume FOR MODIFY
      IMPORTING keys FOR ACTION Travel~Resume.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Travel~calculateTotalPrice.

    METHODS setOverallStatusToOpen FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Travel~setOverallStatusToOpen.

    METHODS setTravelID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Travel~setTravelID.

    METHODS validateAgency FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateAgency.

    METHODS validateBookingFee FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateBookingFee.

    METHODS validateCurrencyCode FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCurrencyCode.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCustomer.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDates.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zjas_r_travel IN LOCAL MODE
         ENTITY Travel
         FIELDS ( OverallStatus )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels)
         FAILED failed.

    result = VALUE #( FOR travel IN travels
                        ( %tky = travel-%tky
                          %field-BookingFee = COND #( WHEN travel-OverallStatus = travel_status-accepted
                                                      THEN if_abap_behv=>fc-f-read_only
                                                      ELSE if_abap_behv=>fc-f-unrestricted )
                          %action-acceptTravel = COND #( WHEN travel-OverallStatus = travel_status-accepted
                                                         THEN if_abap_behv=>fc-o-disabled
                                                         ELSE if_abap_behv=>fc-o-enabled )
                          %action-rejectTravel = COND #( WHEN travel-OverallStatus = travel_status-rejected
                                                         THEN if_abap_behv=>fc-o-disabled
                                                         ELSE if_abap_behv=>fc-o-enabled )
                          %action-deductDiscount = COND #( WHEN travel-OverallStatus = travel_status-accepted
                                                         THEN if_abap_behv=>fc-o-disabled
                                                         ELSE if_abap_behv=>fc-o-enabled )
                          %assoc-_Booking = COND #( WHEN travel-OverallStatus = travel_status-rejected
                                                         THEN if_abap_behv=>fc-o-disabled
                                                         ELSE if_abap_behv=>fc-o-enabled )
                        ) ).






  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD precheck_create.
  ENDMETHOD.

  METHOD precheck_update.
  ENDMETHOD.

  METHOD acceptTravel.

    MODIFY ENTITIES OF zjas_r_travel IN LOCAL MODE
            ENTITY Travel
            UPDATE FIELDS ( OverallStatus )
            WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                            OverallStatus = travel_status-accepted ) ).

    READ ENTITIES OF zjas_r_travel IN LOCAL MODE
              ENTITY Travel
              ALL FIELDS WITH
              CORRESPONDING #( keys )
              RESULT DATA(travels).

    result = VALUE #( FOR travel IN travels ( %tky = travel-%tky
                                              %param = travel ) ).

  ENDMETHOD.

  METHOD deductDiscount.

    DATA travels_for_update TYPE TABLE FOR UPDATE zjas_r_travel.

    DATA(keys_with_valid_discount) = keys.

    LOOP AT keys_with_valid_discount ASSIGNING FIELD-SYMBOL(<key_discount>)
        WHERE %param-discount_percent IS INITIAL
        OR %param-discount_percent > 100
        OR %param-discount_percent <= 0.

      APPEND VALUE #( %tky = <key_discount>-%tky ) TO failed-travel.

      APPEND VALUE #( %tky = <key_discount>-%tky
                      %msg = NEW /dmo/cm_flight_messages(
                                                  textid = /dmo/cm_flight_messages=>discount_invalid
                                                severity = if_abap_behv_message=>severity-error )
                                     %element-totalprice = if_abap_behv=>mk-on
                                  %action-deductDiscount = if_abap_behv=>mk-on
                  ) TO reported-travel.
      DELETE keys_with_valid_discount.
    ENDLOOP.

    CHECK keys_with_valid_discount IS NOT INITIAL.

    READ ENTITIES OF zjas_r_travel IN LOCAL MODE
    ENTITY travel
    FIELDS ( BookingFee )
    WITH CORRESPONDING #( keys_with_valid_discount )
    RESULT DATA(travels).

    DATA percentage TYPE decfloat16.

    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
      DATA(discount_percent) = keys_with_valid_discount[ KEY id %tky = <travel>-%tky ]-%param-discount_percent.
      percentage = discount_percent / 100.
      DATA(reduced_fee) = <travel>-BookingFee * ( 1 - percentage ).

      APPEND VALUE #( %tky = <travel>-%tky
                      BookingFee = reduced_fee ) TO travels_for_update.

    ENDLOOP.


    MODIFY ENTITIES OF zjas_r_travel IN LOCAL MODE
         ENTITY Travel
         UPDATE FIELDS ( BookingFee )
         WITH travels_for_update.

    READ ENTITIES OF zjas_r_travel IN LOCAL MODE
        ENTITY Travel
        ALL FIELDS
        WITH CORRESPONDING #( travels )
        RESULT DATA(travels_with_discount).

    result = VALUE #( FOR travel IN travels_with_discount (  %tky = travel-%tky
                                                             %param = travel ) ).

  ENDMETHOD.

  METHOD reCalcTotalPrice.
  ENDMETHOD.

  METHOD rejectTravel.

    MODIFY ENTITIES OF zjas_r_travel IN LOCAL MODE
          ENTITY Travel
          UPDATE FIELDS ( OverallStatus )
          WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                          OverallStatus = travel_status-rejected ) ).

    READ ENTITIES OF zjas_r_travel IN LOCAL MODE
              ENTITY Travel
              ALL FIELDS WITH
              CORRESPONDING #( keys )
              RESULT DATA(travels).

    result = VALUE #( FOR travel IN travels ( %tky = travel-%tky
                                              %param = travel ) ).

  ENDMETHOD.

  METHOD Resume.
  ENDMETHOD.

  METHOD calculateTotalPrice.
  ENDMETHOD.

  METHOD setOverallStatusToOpen.

    READ ENTITIES OF zjas_r_travel IN LOCAL MODE
            ENTITY Travel
            FIELDS ( OverallStatus )
            WITH CORRESPONDING #( keys )
            RESULT DATA(travels).

    DELETE travels WHERE OverallStatus IS NOT INITIAL.

    CHECK travels IS NOT INITIAL.

    MODIFY ENTITIES OF zjas_r_travel IN LOCAL MODE
            ENTITY Travel
            UPDATE FIELDS ( OverallStatus )
            WITH VALUE #( FOR travel IN travels INDEX INTO i ( %tky = travel-%tky
                                                               OverallStatus = travel_status-open ) ).

  ENDMETHOD.

  METHOD setTravelID.
    READ ENTITIES OF zjas_r_travel IN LOCAL MODE
              ENTITY Travel
              FIELDS ( TravelID )
              WITH CORRESPONDING #( keys )
              RESULT DATA(travels).

    DELETE travels WHERE TravelID IS NOT INITIAL.

    CHECK travels IS NOT INITIAL.

    SELECT SINGLE FROM zjas_travel FIELDS MAX( travel_id )
    INTO @DATA(lv_max_travel_id).

    MODIFY ENTITIES OF zjas_r_travel IN LOCAL MODE
            ENTITY Travel
            UPDATE FIELDS ( TravelID )
            WITH VALUE #( FOR travel IN travels INDEX INTO i ( %tky = travel-%tky
                                                               TravelID = lv_max_travel_id + i ) ).

  ENDMETHOD.

  METHOD validateAgency.
  ENDMETHOD.

  METHOD validateBookingFee.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateCustomer.

    READ ENTITIES OF zjas_r_travel IN LOCAL MODE
    ENTITY travel
    FIELDS ( CustomerID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(travels).

    DATA customers TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY client customer_id.

    customers = CORRESPONDING #( travels DISCARDING DUPLICATES MAPPING customer_id = CustomerID EXCEPT * ).

    DELETE customers WHERE customer_id IS INITIAL.

    IF customers IS NOT INITIAL.

      SELECT FROM /dmo/customer AS ddbb
          INNER JOIN @customers AS http_req
          ON ddbb~customer_id = http_req~customer_id
          FIELDS ddbb~customer_id
          INTO TABLE @DATA(valid_customers).

    ENDIF.

    LOOP AT travels INTO DATA(travel).

      APPEND VALUE #( %tky        = travel-%tky
                      %state_area = 'VALIDATE_CUSTOMER' ) TO reported-travel.

      IF travel-CustomerID IS INITIAL.
        APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
        APPEND VALUE #( %tky = travel-%tky
                        %state_area = 'VALIDATE_CUSTOMER'
                        %msg = NEW /dmo/cm_flight_messages(
                                                    textid = /dmo/cm_flight_messages=>enter_customer_id
                                                  severity = if_abap_behv_message=>severity-error )
                                       %element-CustomerID = if_abap_behv=>mk-on
                    ) TO reported-travel.

      ELSEIF travel-CustomerID IS NOT INITIAL AND NOT line_exists( valid_customers[ customer_id = travel-CustomerID ] ).
        APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
        APPEND VALUE #( %tky = travel-%tky
                        %state_area = 'VALIDATE_CUSTOMER'
                        %msg = NEW /dmo/cm_flight_messages(
                                                    textid = /dmo/cm_flight_messages=>customer_unkown
                                                  severity = if_abap_behv_message=>severity-error )
                                       %element-CustomerID = if_abap_behv=>mk-on
                    ) TO reported-travel.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateDates.
  ENDMETHOD.

ENDCLASS.
