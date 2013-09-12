class OntologyIndividual
  
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)

    @same_individuals = []
    @different_individuals = []
    @things = []
    @annotation_values = []

  add_same_individual: (individual) ->
    @same_individuals.push(individual)

  add_different_individual: (individual) ->
    @different_individuals.push(individual)

  add_thing: (thing) ->
    @things.push(thing)

  add_annotation_value: (annotation_value) ->
    @annotation_values.push(annotation_value)


jQuery.extend window,
  OntologyIndividual: OntologyIndividual
