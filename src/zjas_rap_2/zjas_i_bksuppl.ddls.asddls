@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suplement - Interface'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZJAS_I_BKSUPPL
  as projection on ZJAS_R_BKSUPPL
{
  key BooksupplUUID,
      TravelUUID,
      BookingUUID,
      BookingSupplementID,
      SupplementID,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookSupplPrice,
      CurrencyCode,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true   
      LocalLastChangedAt,
      /* Associations */
      _Booking : redirected to parent ZJAS_I_BOOKING,
      _Product,
      _SupplementText,
      _Travel : redirected to ZJAS_I_TRAVEL
}
