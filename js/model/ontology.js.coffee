class Ontology
  constructor: (name) ->
    @name = name

  build_ontology: (equivalents, disjoints, individuals) ->
    @equivalents = equivalents
    @disjoints = disjoints
    @individuals = individuals