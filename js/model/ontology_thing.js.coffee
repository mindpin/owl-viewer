class OntologyThing extends OntologyBase
  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)
    
    @sub_things = []
    @parent_things = []
    @equivalence_things = []
    @disjoint_things = []
    @individuals = []
    @annotation_values = []
    @object_properties = []
    @data_properties = []

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

  add_object_property: (object_property) ->
    @object_properties.push(object_property)

  add_data_property: (data_property) ->
    @data_properties.push(data_property)

jQuery.extend window,
  OntologyThing: OntologyThing