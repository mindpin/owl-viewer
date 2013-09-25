class AnnotationParser extends BaseParser
  @DEFAULT_IRIS = [
    "owl:backwardCompatibleWith",
    "rdfs:comment",
    "owl:deprecated",
    "owl:incompatibleWith",
    "rdfs:isDefinedBy",
    "rdfs:label",
    "owl:priorVersion",
    "rdfs:seeAlso",
    "owl:versionInfo"
  ]

  constructor: (owl_parser) ->
    @owl_parser = owl_parser
    @models = []

  build_model: ->
    @_parse_model()
    @_parse_sub_and_parent_model()

  build_related: ->
    @_parse_related_domain_class()
    @_parse_related_range_class()
    @_parse_related_annotation_value()

  get_model_by_iri: (bug_iri)->
    iri = @_get_fix_bug_iri(bug_iri)
    ans = @models.filter (an)=>
      an.iri == iri
    an = ans[0]
    return an if !!an
    return @_get_default_mode_by_iri(iri)
    
  #######################
  _get_default_mode_by_iri: (iri)->
    i = AnnotationParser.DEFAULT_IRIS.indexOf(iri)
    return null if i == -1
    return @_build_model(iri)
    
  _parse_model: ->
    @owl_parser.owl_doc.find('AnnotationProperty').each (i,dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      a_iri = ele.attr('abbreviatedIRI')
      if !!iri && !@iri_is_created(iri)
        @_build_model(iri)
      if !!a_iri && !@iri_is_created(a_iri)
        iri = @_get_fix_bug_iri(iri)
        @_get_default_mode_by_iri(iri)

  _parse_sub_and_parent_model: ->
    @owl_parser.owl_doc.find('SubAnnotationPropertyOf').each (i,dom)=>
      ele        = jQuery(dom)
      as         = ele.find('AnnotationProperty')
      sub_iri    = jQuery(as[0]).attr('IRI')
      sub_iri    = jQuery(as[0]).attr('abbreviatedIRI') if !sub_iri
      parent_iri = jQuery(as[1]).attr('IRI')
      parent_iri = jQuery(as[1]).attr('abbreviatedIRI') if !parent_iri
      @_build_sub_and_parent_model(sub_iri, parent_iri)

  _parse_related_domain_class: ->
    @owl_parser.owl_doc.find('AnnotationPropertyDomain').each (i,dom)=>
      ele            = jQuery(dom)
      annotation_iri = ele.find('AnnotationProperty').attr('IRI')
      annotation_iri = ele.find('AnnotationProperty').attr('abbreviatedIRI') if !annotation_iri
      class_iri      = ele.find('IRI').html()
      class_iri      = ele.find('abbreviatedIRI').html() if !class_iri
      @_build_related_domain_class(annotation_iri, class_iri)

  _parse_related_range_class: ->
    @owl_parser.owl_doc.find('AnnotationPropertyRange').each (i,dom)=>
      ele            = jQuery(dom)
      annotation_iri = ele.find('AnnotationProperty').attr('IRI')
      annotation_iri = ele.find('AnnotationProperty').attr('abbreviatedIRI') if !annotation_iri
      class_iri      = ele.find('IRI').html()
      class_iri      = ele.find('abbreviatedIRI').html() if !class_iri
      @_build_related_range_class(annotation_iri, class_iri)

  _parse_related_annotation_value: ->
    @owl_parser.owl_doc.find('AnnotationAssertion').each (i, dom)=>
      ele            = jQuery(dom)
      annotation_iri = ele.find('AnnotationProperty').attr('IRI')
      annotation_iri = ele.find('AnnotationProperty').attr('abbreviatedIRI') if !annotation_iri
      model_iri      = ele.find('IRI').html()
      model_iri      = ele.find('abbreviatedIRI').html() if !model_iri
      data_type_iri  = ele.find('Literal').attr('datatypeIRI')
      value          = ele.find('Literal').html()
      @_build_related_annotation_value(model_iri, annotation_iri, data_type_iri, value)

  _build_model: (iri)->
    annotation   = new OntologyAnnotation(iri)
    @models.push(annotation)
    return annotation

  _build_sub_and_parent_model: (sub_iri, parent_iri)->
    sub    = @get_model_by_iri(sub_iri)
    parent = @get_model_by_iri(parent_iri)

    relation = new OntologyAnnotationParentSubRelation(parent, sub)
    parent.add_relation(relation)
    sub.add_relation(relation)

  _build_related_domain_class: (annotation_iri, class_iri)->
    annotation = @get_model_by_iri(annotation_iri)
    clazz      = @owl_parser.class_parser.get_model_by_iri(class_iri)
    
    relation = new OntologyAnnotationDomainClassRelation(clazz, annotation)
    annotation.add_relation(relation)
    clazz.add_relation(relation)
    
  _build_related_range_class: (annotation_iri, class_iri)->
    annotation = @get_model_by_iri(annotation_iri)
    clazz      = @owl_parser.class_parser.get_model_by_iri(class_iri)

    relation = new OntologyAnnotationRangeClassRelation(clazz, annotation)
    annotation.add_relation(relation)
    clazz.add_relation(relation)

  _build_related_annotation_value: (model_iri, annotation_iri, data_type_iri, value)->
    model      = @owl_parser.get_model_by_iri(model_iri)
    annotation = @get_model_by_iri(annotation_iri)
    data_type  = @owl_parser.data_type_parser.get_model_by_iri(data_type_iri)

    relation = new OntologyAnnotationValueRelation(model, annotation, data_type, value)
    model.add_relation(relation)
    
jQuery.extend window,
  AnnotationParser: AnnotationParser