class OntologyAnnotation extends OntologyBase

  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)

    @relations = []

  add_relation: (relation) ->
    @relations.push(relation)

jQuery.extend window,
  OntologyAnnotation: OntologyAnnotation