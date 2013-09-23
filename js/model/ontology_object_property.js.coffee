class OntologyObjectProperty extends OntologyBase
  
  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)

    @characteristics = []
    @annotation_values = []

    @relations = []

  add_relation: (relation) ->
    @relations.push(relation)

  add_characteristic: (characteristic) ->
    @characteristics.push(characteristic)

  add_annotation_value: (annotation_value) ->
    @annotation_values.push(annotation_value)


jQuery.extend window,
  OntologyObjectProperty: OntologyObjectProperty