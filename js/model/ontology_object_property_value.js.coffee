class OntologyObjectPropertyValue
  
  constructor: (object_property, individual) ->
    @object_property = object_property
    @individual = individual


jQuery.extend window,
  OntologyObjectPropertyValue: OntologyObjectPropertyValue