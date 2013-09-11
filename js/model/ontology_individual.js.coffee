class OntologyIndividual
  
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)

    @same_individuals = []
    @different_individuals = []
    @things = []

  add_same_individual: (individual) ->
    @same_individuals.push(individual)

  add_different_individual: (individual) ->
    @different_individuals.push(individual)

  add_thing: (thing) ->
    @things.push(thing)


jQuery.extend window,
  OntologyIndividual: OntologyIndividual
