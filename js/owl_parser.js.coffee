class OwlParser
  constructor: (owl_text) ->
    @owl_text          = owl_text
    @annotation_parser = new AnnotationParser(this, @owl_text)
    @thing_parser      = new ThingParser(this, @owl_text)
    @individual_parser = new IndividualParser(this, @owl_text)
    @object_property_parser = new ObjectPropertyParser(this, @owl_text)
    @data_property_parser   = new DataPropertyParser(this, @owl_text)
    @data_type_parser       = new DataTypeParser(this, @owl_text)

  build: ->
    @_build_model()
    @_build_related()

  _build_model: ->
    @annotation_parser.build_model()
    @thing_parser.build_model()
    @individual_parser.build_model()
    @object_property_parser.build_model()
    @data_property_parser.build_model()
    @data_type_parser.build_model()

  _build_related: ->
    @annotation_parser.build_related()
    @thing_parser.build_related()
    @individual_parser.build_related()
    @object_property_parser.build_related()
    @data_property_parser.build_related()
    @data_type_parser.build_related()

jQuery.extend window,
  OwlParser: OwlParser
