class DataTypeParser

  constructor: (owl_parser, owl_text) ->
    @owl_parser = owl_parser
    @owl_text   = owl_text

  build_model: ->
    @_parse_model()

  build_related: ->

  _parse_model: ->
    jQuery(@owl_text).find('Declaration Datatype').each (i, dom)->
      iri = jQuery(dom).attr('IRI')
      @_build_model(iri)

  _build_model: (iri)->
    dt = new OntologyDatatype(iri)
    @data_types = [] if !@data_types
    @data_types.push(dt)

  get_model_by_iri: (iri)->
    return null if !@data_types || @data_types.length == 0
    dts = @data_types.filter (dt)=>
      dt.iri == iri

    return dts[0]

jQuery.extend window,
  DataTypeParser: DataTypeParser