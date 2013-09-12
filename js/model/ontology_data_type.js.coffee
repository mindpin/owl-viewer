class OntologyDataType
  
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)
    @annotation_values = []

  add_annotation_value: (annotation_value) ->
    @annotation_values.push(annotation_value)

jQuery.extend window,
  OntologyDataType: OntologyDataType