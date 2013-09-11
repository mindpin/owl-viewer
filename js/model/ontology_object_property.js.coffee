class OntologyObjectProperty
  
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)

    @sub_object_properties = []
    @parent_object_properties = []
    @inverse_object_properties = []
    @disjoint_object_properties = []
    @domains = []
    @ranges = []


  add_sub_object_property: (property) ->
    @sub_object_properties.push(property)

  add_parent_object_property: (property) ->
    @parent_object_properties.push(property)

  add_inverse_object_property: (property) ->
    @inverse_object_properties.push(property)

  add_disjoint_object_property: (property) ->
    @disjoint_object_properties.push(property)

  add_domains_thing: (domain) ->
    @domains.push(domain)

  add_ranges_thing: (range) ->
    @ranges.push(range)


jQuery.extend window,
  OntologyObjectProperty: OntologyObjectProperty