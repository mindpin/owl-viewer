class DataTypeParser extends BaseParser
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

  constructor: (owl_parser) ->
    @owl_parser = owl_parser
    @models = []

  build_model: ->
    @_parse_model()

  build_related: ->

  get_model_by_iri: (bug_iri)->
    iri = @_get_fix_bug_iri(bug_iri)
    dts = @models.filter (dt)=>
      dt.iri == iri
    dt = dts[0]
    return dt if !!dt
    return @_get_default_mode_by_iri(iri)

  #######################
  _get_default_mode_by_iri: (iri)->
    i = DataTypeParser.DEFAULT_IRIS.indexOf(iri)
    return null if i == -1
    return @_build_model(iri)

  _parse_model: ->
    @owl_parser.owl_doc.find('Declaration Datatype').each (i, dom)=>
      iri = jQuery(dom).attr('IRI')
      @_build_model(iri)

  _build_model: (iri)->
    dt = new OntologyDataType(iri)
    @models.push(dt)
    return dt

jQuery.extend window,
  DataTypeParser: DataTypeParser