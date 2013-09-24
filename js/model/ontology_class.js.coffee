class OntologyClass extends OntologyBase
  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)

    @relations = []
    
    @object_properties = []
    @data_properties = []

  add_relation: (relation) ->
    @relations.push(relation)

  add_object_property: (object_property) ->
    @object_properties.push(object_property)

  add_data_property: (data_property) ->
    @data_properties.push(data_property)

  is_top: () ->
    relations = @relations.filter (re) =>
      re.type == "parent-sub" && re.sub == this
      
    relations.length == 0

jQuery.extend window,
  OntologyClass: OntologyClass