class OwlParser
  constructor: (owl_text) ->
    @owl_text          = owl_text
    @owl_doc           = jQuery(@owl_text)
    @annotation_parser = new AnnotationParser(this)
    @thing_parser      = new ThingParser(this)
    @individual_parser = new IndividualParser(this)
    @object_property_parser = new ObjectPropertyParser(this)
    @data_property_parser   = new DataPropertyParser(this)
    @data_type_parser       = new DataTypeParser(this)
    @parsers = [
      @annotation_parser,
      @thing_parser,
      @individual_parser,
      @object_property_parser,
      @data_property_parser,
      @data_type_parser
    ]

  build: ->
    @_build_model()
    @_build_related()

  get_model_by_iri: (iri)->
    for parser in @parsers
      model = parser.get_model_by_iri(iri)
      return model if !!model
    return null

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
