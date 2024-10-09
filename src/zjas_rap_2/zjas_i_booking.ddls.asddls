@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking - Interface'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZJAS_I_BOOKING
  as projection on ZJAS_R_BOOKING
{
  key BookingUUID,
      TravelUUID,
      BookingID,
      BookingDate,
      CustomerID,
      AirlineID,
      ConnectionID,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode' 
      FlightPrice,
      CurrencyCode,
      BookingStatus,
      //BookingStatusText,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true   
      LocalLastChangedAt,
      /* Associations */
      _BookingStatus,
      _BookingSupplement : redirected to composition child ZJAS_I_BKSUPPL,
      _Carrier,
      _Connection,
      _Customer,
      _Travel : redirected to parent ZJAS_I_TRAVEL
}
