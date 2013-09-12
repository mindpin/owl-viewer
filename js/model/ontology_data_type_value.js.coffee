class OntologyDataTypeValue
  
  constructor: (data_type, value) ->
    @data_type = data_type
    @value = value


jQuery.extend window,
  OntologyDataTypeValue: OntologyDataTypeValue