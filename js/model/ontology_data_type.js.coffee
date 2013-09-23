class OntologyDataType extends OntologyBase
  
  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)
    @annotation_values = []

    @relations = []

  add_relation: (relation) ->
    @relations.push(relation)

  add_annotation_value: (annotation_value) ->
    @annotation_values.push(annotation_value)

jQuery.extend window,
  OntologyDataType: OntologyDataType