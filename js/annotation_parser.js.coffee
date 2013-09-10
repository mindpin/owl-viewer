class AnnotationParser
  constructor: (owl_parser, owl_text) ->
    @owl_parser = owl_parser
    @owl_text   = owl_text

  build_model: ->
    @_parse_annotation()
    @_parse_related_sub_and_parent_annotation()

  build_related: ->
    @_parse_related_domain_thing()
    @_parse_related_range_thing()

  get_annotation_by_iri: (iri)->
    return null if !@annotations || @annotations.length == 0
    ans = @annotations.filter (an)=>
      an.iri == iri

    return ans[0]

  #######################
  _parse_annotation: ->
    jQuery(@owl_text).find('Declaration AnnotationProperty').each (i,dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_annotation(iri)

  _parse_related_sub_and_parent_annotation: ->
    jQuery(@owl_text).find('SubAnnotationPropertyOf').each (i,dom)=>
      ele        = jQuery(dom)
      as         = ele.find('AnnotationProperty')
      sub_iri    = jQuery(as[0]).attr('IRI')
      parent_iri = jQuery(as[1]).attr('IRI')
      @_build_related_sub_and_parent_annotation(sub_iri, parent_iri)

  _parse_related_domain_thing: ->
    jQuery(@owl_text).find('AnnotationPropertyDomain').each (i,dom)=>
      ele            = jQuery(dom)
      annotation_iri = ele.find('AnnotationProperty').attr('IRI')
      thing_iri      = ele.find('IRI').value()
      @_build_related_domain_thing(annotation_iri, thing_iri)

  _parse_related_range_thing: ->
    jQuery(@owl_text).find('AnnotationPropertyRange').each (i,dom)=>
      ele            = jQuery(dom)
      annotation_iri = ele.find('AnnotationProperty').attr('IRI')
      thing_iri      = ele.find('IRI').value()
      @_build_related_range_thing(annotation_iri, thing_iri)

  _build_annotation: (iri)->
    annotation   = new OntologyAnnotation(iri)
    @annotations = [] if !@annotations
    @annotations.push(annotation)

  _build_related_sub_and_parent_annotation: (sub_iri, parent_iri)->
    sub    = @get_annotation_by_iri(sub_iri)
    parent = @get_annotation_by_iri(parent_iri)
    parent.add_sub_annotation(sub)
    sub.add_parent_annotation(parent)

  _build_related_domain_thing: (annotation_iri, thing_iri)->
    annotation = @get_annotation_by_iri(annotation_iri)
    thing      = @owl_parser.thing_parser.get_thing_by_iri(thing_iri)
    annotation.add_domain_thing(thing)

  _build_related_range_thing: (annotation_iri, thing_iri)->
    annotation = @get_annotation_by_iri(annotation_iri)
    thing      = @owl_parser.thing_parser.get_thing_by_iri(thing_iri)
    annotation.add_range_thing(thing)

jQuery.extend window,
  AnnotationParser: AnnotationParser