class AnnotationParser
  @DEFAULT_IRIS = [
    "owl:backwardCompatibleWith",
    "rdfs:comment",
    "owl:deprecate,d",
    "owl:incompati,bleWith",
    "rdfs:isDefine,dBy",
    "rdfs:label",
    "owl:priorVe,rsion",
    "rdfs:seeAlso",
    "owl:versionInfo"
  ]

  constructor: (owl_parser, owl_text) ->
    @owl_parser = owl_parser
    @owl_text   = owl_text

  build_model: ->
    @_parse_model()
    @_parse_sub_and_parent_model()

  build_related: ->
    @_parse_related_domain_thing()
    @_parse_related_range_thing()
    @_parse_related_annotation_value()

  get_model_by_iri: (iri)->
    return null if !@annotations || @annotations.length == 0
    ans = @annotations.filter (an)=>
      an.iri == iri
    an = ans[0]
    return an if !!an
    return @_get_default_mode_by_iri(iri)
    
  #######################
  _get_default_mode_by_iri: (iri)->
    i = AnnotationParser.DEFAULT_IRIS.indexOf(iri)
    return null if i == -1
    @_build_model(iri)
    
  _parse_model: ->
    jQuery(@owl_text).find('Declaration AnnotationProperty').each (i,dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_model(iri)

  _parse_sub_and_parent_model: ->
    jQuery(@owl_text).find('SubAnnotationPropertyOf').each (i,dom)=>
      ele        = jQuery(dom)
      as         = ele.find('AnnotationProperty')
      sub_iri    = jQuery(as[0]).attr('IRI')
      parent_iri = jQuery(as[1]).attr('IRI')
      @_build_sub_and_parent_model(sub_iri, parent_iri)

  _parse_related_domain_thing: ->
    jQuery(@owl_text).find('AnnotationPropertyDomain').each (i,dom)=>
      ele            = jQuery(dom)
      annotation_iri = ele.find('AnnotationProperty').attr('IRI')
      thing_iri      = ele.find('IRI').val()
      @_build_related_domain_thing(annotation_iri, thing_iri)

  _parse_related_range_thing: ->
    jQuery(@owl_text).find('AnnotationPropertyRange').each (i,dom)=>
      ele            = jQuery(dom)
      annotation_iri = ele.find('AnnotationProperty').attr('IRI')
      thing_iri      = ele.find('IRI').val()
      @_build_related_range_thing(annotation_iri, thing_iri)

  _parse_related_annotation_value: ->
    jQuery(@owl_text).find('AnnotationAssertion').each (i, dom)=>
      ele            = jQuery(dom)
      annotation_iri = ele.find('AnnotationProperty').attr('IRI')
      model_iri      = ele.find('IRI').val()
      data_type_iri  = ele.find('Literal').attr('datatypeIRI')
      value          = ele.find('Literal').val()
      @_build_related_annotation_value(model_iri, annotation_iri, data_type_iri, value)

  _build_model: (iri)->
    annotation   = new OntologyAnnotation(iri)
    @annotations = [] if !@annotations
    @annotations.push(annotation)

  _build_sub_and_parent_model: (sub_iri, parent_iri)->
    sub    = @get_model_by_iri(sub_iri)
    parent = @get_model_by_iri(parent_iri)
    parent.add_sub_annotation(sub)
    sub.add_parent_annotation(parent)

  _build_related_domain_thing: (annotation_iri, thing_iri)->
    annotation = @get_model_by_iri(annotation_iri)
    thing      = @owl_parser.thing_parser.get_model_by_iri(thing_iri)
    annotation.add_domain_thing(thing)

  _build_related_range_thing: (annotation_iri, thing_iri)->
    annotation = @get_model_by_iri(annotation_iri)
    thing      = @owl_parser.thing_parser.get_model_by_iri(thing_iri)
    annotation.add_range_thing(thing)

  _build_related_annotation_value: (model_iri, annotation_iri, data_type_iri, value)->
    model      = @owl_parser.get_model_by_iri(model_iri)
    annotation = @get_model_by_iri(annotation_iri)
    data_type  = @owl_parser.data_type_parser.get_model_by_iri(data_type_iri)
    dtv        = new OntologyDatatypeValue(data_type, value)
    av         = new OntologyAnnotationValue(annotation, dtv)
    model.add_annotation_value(av)

jQuery.extend window,
  AnnotationParser: AnnotationParser