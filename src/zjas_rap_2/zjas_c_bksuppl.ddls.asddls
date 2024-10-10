@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suplement - Consumption'
@Metadata.ignorePropagatedAnnotations: true

@Metadata.allowExtensions: true
@Search.searchable: true

define view entity ZJAS_C_BKSUPPL
  as projection on ZJAS_R_BKSUPPL
{
  key BooksupplUUID,
      TravelUUID,
      BookingUUID,
      
      @Search.defaultSearchElement: true
      BookingSupplementID,
      
      @ObjectModel.text.element: [ 'SupplementDescription' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Supplement_StdVH',
                                                     element: 'SupplementID'},
                                                     additionalBinding: [{ localElement: 'BookSupplPrice',
                                                                           element: 'Price',
                                                                           usage: #RESULT },
                                                                         { localElement: 'CurrencyCode',
                                                                           element: 'CurrencyCode',
                                                                           usage: #RESULT }],
                                                      useForValidation: true
                                                     }]
      SupplementID,
      _SupplementText.Description as SupplementDescription : localized,
      
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookSupplPrice,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH',
                                                     element: 'Currency'},
                                                     //Para obligar a elegir un codigo de la lista de la ayuda de busqueda
                                                     useForValidation: true
                                                    }]
      CurrencyCode,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      /* Associations */
      _Booking : redirected to parent ZJAS_C_BOOKING,
      _Product,
      _SupplementText,
      _Travel : redirected to ZJAS_C_TRAVEL
}
