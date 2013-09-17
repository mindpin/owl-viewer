class Ontology

  constructor: (owl_parser) ->
    @annotations       = owl_parser.annotation_parser.annotations
    @things            = owl_parser.thing_parser.things
    @individuals       = owl_parser.individual_parser.individuals
    @object_properties = owl_parser.object_property_parser.object_properties
    @data_properties   = owl_parser.data_property_parser.data_properties
    @data_types        = owl_parser.data_type_parser.data_types

jQuery.extend window,
  Ontology: Ontology