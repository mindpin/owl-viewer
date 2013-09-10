class OntologyIndividual
  
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)
