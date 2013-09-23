class OntologyObjectProperty extends OntologyBase
  
  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)

    @characteristics = []

    @relations = []

  add_relation: (relation) ->
    @relations.push(relation)

  add_characteristic: (characteristic) ->
    @characteristics.push(characteristic)

jQuery.extend window,
  OntologyObjectProperty: OntologyObjectProperty