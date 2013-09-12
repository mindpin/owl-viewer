class OntologyDataPropertyValue
  
  constructor: (data_property, data_type_value) ->
    @data_property = data_property
    @data_type_value = data_type_value


jQuery.extend window,
  OntologyDataPropertyValue: OntologyDataPropertyValue