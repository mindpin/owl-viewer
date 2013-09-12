class OntologyDataProperty
  
  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)

    @sub_data_properties = []
    @parent_data_properties = []
    @equivalence_data_properties = []
    @disjoint_data_properties = []
    @characteristics = []
    @domain_things = []
    @range_data_types = []

  add_sub_data_property: (property) ->
    @sub_data_properties.push(property)

  add_parent_data_property: (property) ->
    @parent_data_properties.push(property)

  add_equivalence_data_property: (property) ->
    @equivalence_data_properties.push(property)

  add_disjoint_data_property: (property) ->
    @disjoint_data_properties.push(property)

  add_characteristic: (characteristic) ->
    @characteristics.push(characteristic)

  add_domain_thing: (domain) ->
    @domain_things.push(domain)

  add_range_data_type: (data_type) ->
    @range_data_types.push(data_type)    



jQuery.extend window,
  OntologyDataProperty: OntologyDataProperty
