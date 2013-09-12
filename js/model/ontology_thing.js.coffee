class OntologyThing
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)

    @sub_things = []
    @parent_things = []
    @equivalence_things = []
    @disjoint_things = []
    @individuals = []
    @annotation_values = []

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

  add_annotation_value: (annotation_value) ->
    @annotation_values.push(annotation_value)

jQuery.extend window,
  OntologyThing: OntologyThing