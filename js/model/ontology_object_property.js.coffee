class OntologyObjectProperty
  
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)


jQuery.extend window,
  OntologyObjectProperty: OntologyObjectProperty