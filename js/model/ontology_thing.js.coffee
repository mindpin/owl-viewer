class OntologyThing
  constructor: (name) ->
    @name = name
    @sub_things = []
    @parent_things = []
    @equivalence_things = []
    @disjoint_things = []
    @individuals = []

  build_ontology: (equivalents, disjoints, individuals) ->
    @equivalents = equivalents
    @disjoints = disjoints
    @individuals = individuals

  add_sub_thing: (thing) ->
    @sub_things.push(thing)

  add_parent_thing: (thing) ->
    @parent_things.push(thing)

  add_equivalence_thing: (thing) ->
    @equivalence_things.push(thing)

  add_disjoint_thing: (thing) ->
    @disjoint_things.push(thing)

  add_individual: (individual) ->
    @individuals.push(individual)