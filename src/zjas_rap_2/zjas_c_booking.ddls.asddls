@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking - Consumption'
@Metadata.ignorePropagatedAnnotations: true

@Metadata.allowExtensions: true
@Search.searchable: true

define view entity ZJAS_C_BOOKING
  as projection on ZJAS_R_BOOKING
{
  key BookingUUID,
      TravelUUID,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Booking_D',
                                                     element: 'BookingID'},
                                                     //Para obligar a elegir un codigo de la lista de la ayuda de busqueda
                                                     useForValidation: true
                                                     }]
      BookingID,
      BookingDate,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'CustomerName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer_StdVH',
                                                     element: 'CustomerID'},
                                                     //Para obligar a elegir un codigo de la lista de la ayuda de busqueda
                                                     useForValidation: true
                                                     }]
      CustomerID,
      _Customer.LastName as CustomerName,

      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'CarrierName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Flight_StdVH',
                                                     element: 'AirlineID'},
                                                     additionalBinding: [{ localElement: 'CurrencyCode',
                                                                           element: 'CurrencyCode',
                                                                           usage: #RESULT },
                                                                         { localElement: 'FlightPrice',
                                                                           element: 'FlightPrice',
                                                                           usage: #RESULT }],
                                                      useForValidation: true
                                                     }]
      AirlineID,
      _Carrier.Name      as CarrierName,

      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'CarrierName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Flight_StdVH',
                                                     element: 'ConnectionID'},
                                                     additionalBinding: [{ localElement: 'FlightDate',
                                                                           element: 'FlightDate',
                                                                           usage: #RESULT },
                                                                         { localElement: 'AirlineID',
                                                                           element: 'AirlineID',
                                                                           usage: #FILTER_AND_RESULT },
                                                                         { localElement: 'FlightPrice',
                                                                           element: 'FlightPrice',
                                                                           usage: #RESULT },
                                                                         { localElement: 'CurrencyCode',
                                                                           element: 'CurrencyCode',
                                                                           usage: #RESULT }],
                                                      useForValidation: true
                                                     }]
      ConnectionID,

      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'CarrierName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Flight_StdVH',
                                                     element: 'FlightDate'},
                                                     additionalBinding: [{ localElement: 'AirlineID',
                                                                           element: 'AirlineID',
                                                                           usage: #FILTER_AND_RESULT },
                                                                         { localElement: 'ConnectionID',
                                                                           element: 'ConecctionID',
                                                                           usage: #FILTER_AND_RESULT },
                                                                         { localElement: 'FlightPrice',
                                                                           element: 'FlightPrice',
                                                                           usage: #RESULT },
                                                                         { localElement: 'CurrencyCode',
                                                                           element: 'CurrencyCode',
                                                                           usage: #RESULT }],
                                                      useForValidation: true
                                                     }]
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Flight_StdVH',
                                                     element: 'Price'},
                                                     additionalBinding: [{ localElement: 'AirlineID',
                                                                           element: 'AirlineID',
                                                                           usage: #FILTER_AND_RESULT },
                                                                         { localElement: 'ConnectionID',
                                                                           element: 'ConecctionID',
                                                                           usage: #FILTER_AND_RESULT },
                                                                         { localElement: 'FlightDate',
                                                                           element: 'FlightDate',
                                                                           usage: #RESULT },
                                                                         { localElement: 'CurrencyCode',
                                                                           element: 'CurrencyCode',
                                                                           usage: #RESULT }],
                                                      useForValidation: true
                                                     }]
      FlightPrice,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH',
                                               //Este "AgencyID" es el de aqui, NO el de la ayuda de busqueda
                                               element: 'Currency'},
                                               //Para obligar a elegir un codigo de la lista de la ayuda de busqueda
                                               useForValidation: true
                                               }]
      CurrencyCode,
      
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Booking_Status_VH',
                                                     element: 'BookingStatus'},
                                           useForValidation: true }]      
      BookingStatus,
      //BookingStatusText,
      _BookingStatus._Text.Text as BookingStatusText : localized,
      LocalLastChangedAt,
      /* Associations */
      _BookingStatus,
      _BookingSupplement : redirected to composition child ZJAS_C_BKSUPPL,
      _Carrier,
      _Connection,
      _Customer,
      _Travel            : redirected to parent ZJAS_C_TRAVEL
}
