class OntologyObjectProperty
  
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)

    @sub_object_properties = []
    @parent_object_properties = []
    @inverse_object_properties = []
    @disjoint_object_properties = []
    @domain_things = []
    @range_things = []


  add_sub_object_property: (property) ->
    @sub_object_properties.push(property)

  add_parent_object_property: (property) ->
    @parent_object_properties.push(property)

  add_inverse_object_property: (property) ->
    @inverse_object_properties.push(property)

  add_disjoint_object_property: (property) ->
    @disjoint_object_properties.push(property)

  add_domain_things: (domain) ->
    @domain_things.push(domain)

  add_range_things: (range) ->
    @range_things.push(range)


jQuery.extend window,
  OntologyObjectProperty: OntologyObjectProperty