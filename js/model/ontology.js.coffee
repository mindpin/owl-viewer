class Ontology

  constructor: (owl_parser) ->
    @annotations       = owl_parser.annotation_parser.models
    @classes            = owl_parser.class_parser.models
    @individuals       = owl_parser.individual_parser.models
    @object_properties = owl_parser.object_property_parser.models
    @data_properties   = owl_parser.data_property_parser.models
    @data_types        = owl_parser.data_type_parser.models
    @_build_top_attr()

  _build_top_attr: () ->
    @top_classes = @classes.filter (clazz) ->
      clazz.is_top()
    @top_individuals = @individuals.filter (individual) ->
      individual.is_top()

jQuery.extend window,
  Ontology: Ontology