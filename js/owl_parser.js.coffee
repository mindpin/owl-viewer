class OwlParser
  constructor: (owl_text) ->
    @owl_text          = owl_text
    @annotation_parser = new AnnotationParser(this, @owl_text)
    @thing_parser      = new ThingParser(this, @owl_text)

  build: ->
    @_build_model()
    @_build_related()

  _build_model: ->
    @annotation_parser.build_model()
    @thing_parser.build_model()

  _build_related: ->
    @annotation_parser.build_related()
    @thing_parser.build_related()

jQuery.extend window,
  OwlParser: OwlParser
