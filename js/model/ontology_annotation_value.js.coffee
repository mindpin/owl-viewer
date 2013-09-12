class OntologyAnnotationValue
  
  constructor: (annotation, data_type_value) ->
    @annotation = annotation
    @data_type_value = data_type_value


jQuery.extend window,
  OntologyAnnotationValue: OntologyAnnotationValue