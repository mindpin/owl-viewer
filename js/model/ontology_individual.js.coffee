class OntologyIndividual extends OntologyBase
  
  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)

    @same_individuals = []
    @different_individuals = []
    @relations = []
    @annotation_values = []
    @object_property_values = []
    @data_property_values = []

  add_relation: (relation) ->
    @relations.push(relation)

  add_same_individual: (individual) ->
    @same_individuals.push(individual)

  add_different_individual: (individual) ->
    @different_individuals.push(individual)

  add_annotation_value: (annotation_value) ->
    @annotation_values.push(annotation_value)

  add_object_property_value: (object_property_value) ->
    @object_property_values.push(object_property_value)

  add_data_property_value: (data_property_value) ->
    @data_property_values.push(data_property_value)


jQuery.extend window,
  OntologyIndividual: OntologyIndividual
