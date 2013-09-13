class DataTypeParser
  @DEFAULT_IRIS = [
    "rdf:PlainLiteral",
    "xsd:anyURI",
    "xsd:base64Binary",
    "xsd:boolean",
    "xsd:byte",
    "xsd:dateTime",
    "xsd:dateTimeStamp",
    "xsd:decimal",
    "xsd:double",
    "xsd:float",
    "xsd:hexBinary",
    "xsd:int",
    "xsd:integer",
    "xsd:language",
    "xsd:Literal",
    "xsd:long",
    "xsd:Name",
    "xsd:NCName",
    "xsd:negativeInteger",
    "xsd:NMTOKEN",
    "xsd:nonNegativeInteger",
    "xsd:nonPositiveInteger",
    "xsd:normalizedString",
    "xsd:positiveInteger",
    "xsd:rational",
    "xsd:real",
    "xsd:short",
    "xsd:string",
    "xsd:token",
    "xsd:unsignedByte",
    "xsd:unsignedInt",
    "xsd:unsignedLong",
    "xsd:unsignedShort",
    "xsd:XMLLiteral"
  ]

  constructor: (owl_parser, owl_text) ->
    @owl_parser = owl_parser
    @owl_text   = owl_text

  build_model: ->
    @_parse_model()

  build_related: ->

  get_model_by_iri: (bug_iri)->
    iri = @_get_fix_bug_iri(bug_iri)
    return null if !@data_types || @data_types.length == 0
    dts = @data_types.filter (dt)=>
      dt.iri == iri
    dt = dts[0]
    return dt if !!dt
    return @_get_default_mode_by_iri(iri)

  #######################
  _get_default_mode_by_iri: (iri)->
    i = DataTypeParser.DEFAULT_IRIS.indexOf(iri)
    return null if i == -1
    @_build_model(iri)

  _parse_model: ->
    jQuery(@owl_text).find('Declaration Datatype').each (i, dom)=>
      iri = jQuery(dom).attr('IRI')
      @_build_model(iri)

  _build_model: (iri)->
    dt = new OntologyDataType(iri)
    @data_types = [] if !@data_types
    @data_types.push(dt)

  _get_fix_bug_iri: (iri)->
    reg = iri.match(/&(\S+);(\S+)/)
    return "#{reg[1]}:#{reg[2]}" if !!reg

    reg = iri.match(/\S+(#\S+)/)
    return reg[1] if !!reg

    return iri

jQuery.extend window,
  DataTypeParser: DataTypeParser