class OntologyObjectProperty extends OntologyBase
  
  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)

    @sub_object_properties = []
    @parent_object_properties = []
    @equivalence_object_properties = []
    @inverse_object_properties = []
    @disjoint_object_properties = []
    @characteristics = []
    @domain_things = []
    @range_things = []
    @annotation_values = []

  add_sub_object_property: (property) ->
    @sub_object_properties.push(property)

  add_parent_object_property: (property) ->
    @parent_object_properties.push(property)

  add_equivalence_object_property: (property) ->
    @equivalence_object_properties.push(property)

  add_inverse_object_property: (property) ->
    @inverse_object_properties.push(property)

  add_disjoint_object_property: (property) ->
    @disjoint_object_properties.push(property)

  add_characteristic: (characteristic) ->
    @characteristics.push(characteristic)

  add_domain_thing: (domain) ->
    @domain_things.push(domain)

  add_range_thing: (range) ->
    @range_things.push(range)

  add_annotation_value: (annotation_value) ->
    @annotation_values.push(annotation_value)


jQuery.extend window,
  OntologyObjectProperty: OntologyObjectProperty