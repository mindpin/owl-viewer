class OntologyClass extends OntologyBase
  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)

    @relations = []
    
    @annotation_values = []
    @object_properties = []
    @data_properties = []

  add_relation: (relation) ->
    @relations.push(relation)

  add_annotation_value: (annotation_value) ->
    @annotation_values.push(annotation_value)

  add_object_property: (object_property) ->
    @object_properties.push(object_property)

  add_data_property: (data_property) ->
    @data_properties.push(data_property)

jQuery.extend window,
  OntologyClass: OntologyClass