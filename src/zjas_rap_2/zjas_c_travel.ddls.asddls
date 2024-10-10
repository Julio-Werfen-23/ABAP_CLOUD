@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel - Consumption'
@Metadata.ignorePropagatedAnnotations: true

@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZJAS_C_TRAVEL
  provider contract transactional_query
  as projection on ZJAS_R_TRAVEL
{
  key TravelUUID,

      @Search.defaultSearchElement: true
      TravelID,

      @Search.defaultSearchElement: true
//      @Consumption.valueHelpDefinition.entity.name: '/DMO/I_Agency_StdVH'
//      @Consumption.valueHelpDefinition.entity.element: 'AgencyID'
      @ObjectModel.text.element: [ 'AgencyName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Agency_StdVH',
                                                     //Este "AgencyID" es el de la ayuda de busqueda
                                                     element: 'AgencyID'},
                                                     //Para obligar a elegir un codigo de la lista de la ayuda de busqueda
                                                     useForValidation: true
                                                     }]
      AgencyID,
      _Agency.Name       as AgencyName,

      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'CustomerName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer_StdVH',
                                                     element: 'CustomerID'},
                                                     //Para obligar a elegir un codigo de la lista de la ayuda de busqueda
                                                     useForValidation: true
                                                     }]
      CustomerID,
      _Customer.LastName as CustomerName,

      BeginDate,
      EndDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH',
                                                     //Este "AgencyID" es el de aqui, NO el de la ayuda de busqueda
                                                     element: 'Currency'},
                                                     //Para obligar a elegir un codigo de la lista de la ayuda de busqueda
                                                     useForValidation: true
                                                     }]
      CurrencyCode,
      
      Description,
      
      OverallStatus,
      _OverallStatus._Text.Text as OverallStatusText : localized,
      
//      NewElement,
      
//      LocalCreatedBy,
//      LocalCreatedAt, 
//      LocalLastChangedBy,
//      LastChangedAt,
      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt,
      
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      
      /* Associations */
      _Agency,
      _Booking : redirected to composition child ZJAS_C_BOOKING,
      _Currency,
      _Customer,
      _OverallStatus
}
