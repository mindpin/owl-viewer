class OntologyClass extends OntologyBase
  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)
    
    @sub_classes = []
    @parent_classes = []
    @equivalence_classes = []
    @disjoint_classes = []
    @individuals = []
    @annotation_values = []
    @object_properties = []
    @data_properties = []

  add_sub_class: (clazz) ->
    @sub_classes.push(clazz)

  add_parent_class: (clazz) ->
    @parent_classes.push(clazz)

  add_equivalence_class: (clazz) ->
    @equivalence_classes.push(clazz)

  add_disjoint_class: (clazz) ->
    @disjoint_classes.push(clazz)

  add_individual: (individual) ->
    @individuals.push(individual)

  add_annotation_value: (annotation_value) ->
    @annotation_values.push(annotation_value)

  add_object_property: (object_property) ->
    @object_properties.push(object_property)

  add_data_property: (data_property) ->
    @data_properties.push(data_property)

jQuery.extend window,
  OntologyClass: OntologyClass