class OwlParser
  constructor: (owl_text) ->
    @owl_text = owl_text

  build_ontology: ->
    @_parse_annotation()
    @_parse_thing()
    @_parse_sub_and_parent_annotation_related()
    @_parse_domain_thing_related()
    @_parse_range_thing_related()

  get_annotation_by_iri: (iri)->
    return null if !@annotations || @annotations.length == 0
    ans = @annotations.filter (an)=>
      an.iri == iri

    return ans[0]

  get_thing_by_iri: (iri)->
    return null if !@things || @things.length == 0
    things = @things.filter (thing)=>
      thing.iri == iri

    return things[0]

  _parse_annotation: ->
    jQuery(@owl_text).find('Declaration AnnotationProperty').each (i,dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_annotation(iri)

  _parse_thing: ->
    jQuery(@owl_text).find('Declaration Class').each (i,dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_thing(iri)

  _parse_sub_and_parent_annotation_related: ()->
    jQuery(@owl_text).find('SubAnnotationPropertyOf').each (i,dom)=>
      ele        = jQuery(dom)
      as         = ele.find('AnnotationProperty')
      sub_iri    = jQuery(as[0]).attr('IRI')
      parent_iri = jQuery(as[1]).attr('IRI')
      @_build_sub_and_parent_annotation_related(sub_iri, parent_iri)

  _parse_domain_thing_related: ()->
    jQuery(@owl_text).find('AnnotationPropertyDomain').each (i,dom)=>
      ele            = jQuery(dom)
      annotation_iri = ele.find('AnnotationProperty').attr('IRI')
      thing_iri      = ele.find('IRI').value()
      @_build_domain_thing_related(annotation_iri, thing_iri)

  _parse_range_thing_related: ()->
    jQuery(@owl_text).find('AnnotationPropertyRange').each (i,dom)=>
      ele            = jQuery(dom)
      annotation_iri = ele.find('AnnotationProperty').attr('IRI')
      thing_iri      = ele.find('IRI').value()
      @_build_range_thing_related(annotation_iri, thing_iri)

  _build_annotation: (iri)->
    annotation   = new OntologyAnnotation(iri)
    @annotations = [] if !@annotations
    @annotations.push(annotation)

  _build_thing: (iri)->
    thing   = new OntologyThing(iri)
    @things = [] if !@things
    @things.push(thing)

  _build_sub_and_parent_annotation_related: (sub_iri, parent_iri)->
    sub    = @get_annotation_by_iri(sub_iri)
    parent = @get_annotation_by_iri(parent_iri)
    parent.add_sub_annotation(sub)
    sub.add_parent_annotation(parent)

  _build_domain_thing_related: (annotation_iri, thing_iri)->
    annotation = @get_annotation_by_iri(annotation_iri)
    thing      = @get_thing_by_iri(thing_iri)
    annotation.add_domain_thing(thing)

  _build_range_thing_related: (annotation_iri, thing_iri)->
    annotation = @get_annotation_by_iri(annotation_iri)
    thing      = @get_thing_by_iri(thing_iri)
    annotation.add_range_thing(thing)

jQuery.extend window,
  OwlParser: OwlParser
