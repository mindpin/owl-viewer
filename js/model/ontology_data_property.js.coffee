class OntologyDataProperty
  
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)



jQuery.extend window,
  OntologyDataProperty: OntologyDataProperty
