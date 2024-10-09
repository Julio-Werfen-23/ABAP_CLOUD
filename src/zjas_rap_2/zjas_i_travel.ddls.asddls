@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel - Interface'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZJAS_I_TRAVEL
  provider contract transactional_interface
  as projection on ZJAS_R_TRAVEL
{
  key TravelUUID,
      TravelID,
      AgencyID,
      CustomerID,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      Description,
      OverallStatus,
      
      LocalLastChangedAt,

      /* Associations */
      _Agency,
      _Booking,
      _Currency,
      _Customer,
      _OverallStatus
}
