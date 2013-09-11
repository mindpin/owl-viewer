class OntologyIndividual
  
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)

    @sub_individuals = []
    @parent_individuals = []
    @domains = []
    @ranges = []

  add_sub_individual: (individual) ->
    @sub_individuals.push(individual)

  add_parent_annotation: (individual) ->
    @parent_individuals.push(individual)

  add_domains_thing: (domain) ->
    @domains.push(domain)

  add_ranges_thing: (range) ->
    @ranges.push(range)


jQuery.extend window,
  OntologyIndividual: OntologyIndividual
