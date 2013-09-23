class OntologyAnnotation extends OntologyBase

  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)

    @relations = []

    @annotation_values = []

  add_relation: (relation) ->
    @relations.push(relation)

  add_annotation_value: (annotation_value) ->
    @annotation_values.push(annotation_value)
    

jQuery.extend window,
  OntologyAnnotation: OntologyAnnotation