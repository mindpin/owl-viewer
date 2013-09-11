class OntologyDataProperty
  
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)

    @sub_data_properties = []
    @parent_data_properties = []
    @equivalence_data_properties = []
    @disjoint_data_properties = []
    @domains = []
    @ranges = []

  add_sub_data_property: (property) ->
    @sub_data_properties.push(property)

  add_parent_data_property: (property) ->
    @parent_data_properties.push(property)

  add_equivalence_data_property: (property) ->
    @equivalence_data_properties.push(property)

  add_disjoint_data_property: (property) ->
    @disjoint_data_properties.push(property)

  add_domains_thing: (domain) ->
    @domains.push(domain)

  add_ranges_thing: (range) ->
    @ranges.push(range)



jQuery.extend window,
  OntologyDataProperty: OntologyDataProperty
