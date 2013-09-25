class ClassParser extends BaseParser
  @DEFAULT_IRIS = ['owl:Thing','owl:Nothing']

  constructor: (owl_parser) ->
    @owl_parser = owl_parser
    @models = []

  build_model: ->
    @_parse_model()
    @_parse_sub_and_parent_model()
    @_parse_equivalence_model()
    @_parse_disjoint_model()

  build_related: ->
    @_parse_related_individual()
    @_parse_related_object_property()
    @_parse_related_data_property()

  get_model_by_iri: (bug_iri)->
    iri = @_get_fix_bug_iri(bug_iri)
    models = @models.filter (clazz)=>
      clazz.iri == iri
    clazz = models[0]
    return clazz if !!clazz
    return @_get_default_mode_by_iri(iri)

  ######################
  _get_default_mode_by_iri: (iri)->
    i = ClassParser.DEFAULT_IRIS.indexOf(iri)
    return null if i == -1
    return @_build_model(iri)

  _parse_model: ->
    @owl_parser.owl_doc.find('Class').each (i,dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      a_iri = ele.attr('abbreviatedIRI')
      if !!iri && !@iri_is_created(iri)
        iri = @_get_fix_bug_iri(iri)
        @_build_model(iri)
      if !!a_iri && !@iri_is_created(a_iri)
        a_iri = @_get_fix_bug_iri(a_iri)
        @_get_default_mode_by_iri(a_iri)

  _build_model: (iri)->
    clazz   = new OntologyClass(iri)
    @models.push(clazz)
    return clazz

  _parse_sub_and_parent_model: ->
    @owl_parser.owl_doc.find('SubClassOf').each (i,dom)=>
      ele        = jQuery(dom)
      class_eles = ele.find('Class')
      sub_iri    = jQuery(class_eles[0]).attr('IRI')
      sub_iri    = jQuery(class_eles[0]).attr('abbreviatedIRI') if !sub_iri
      parent_iri = jQuery(class_eles[1]).attr('IRI')
      parent_iri = jQuery(class_eles[1]).attr('abbreviatedIRI') if !parent_iri
      @_build_sub_and_parent_model(sub_iri, parent_iri)

  _build_sub_and_parent_model: (sub_iri, parent_iri)->
    sub    = @get_model_by_iri(sub_iri)
    parent = @get_model_by_iri(parent_iri)

    if !!sub && !!parent
      relation = new OntologyClassParentSubRelation(parent, sub)
      parent.add_relation(relation)
      sub.add_relation(relation)

  _parse_equivalence_model: ->
    @owl_parser.owl_doc.find('EquivalentClasses').each (i,dom)=>
      ele        = jQuery(dom)
      class_eles = ele.find('Class')
      iri        = jQuery(class_eles[0]).attr('IRI')
      iri        = jQuery(class_eles[0]).attr('abbreviatedIRI') if !iri
      other_iri  = jQuery(class_eles[1]).attr('IRI')
      other_iri  = jQuery(class_eles[1]).attr('abbreviatedIRI') if !other_iri
      @_build_equivalence_model(iri, other_iri)

  _build_equivalence_model: (iri, other_iri)->
    clazz       = @get_model_by_iri(iri)
    other_class = @get_model_by_iri(other_iri)

    if !!clazz && !!other_class
      relation = new OntologyClassEquivalentRelation([clazz, other_class])
      clazz.add_relation(relation)
      other_class.add_relation(relation)

  _parse_disjoint_model: ->
    @owl_parser.owl_doc.find('DisjointClasses').each (i,dom)=>
      ele        = jQuery(dom)
      class_eles = ele.find('Class')
      iri        = jQuery(class_eles[0]).attr('IRI')
      iri        = jQuery(class_eles[0]).attr('abbreviatedIRI') if !iri
      other_iri  = jQuery(class_eles[1]).attr('IRI')
      other_iri  = jQuery(class_eles[1]).attr('abbreviatedIRI') if !other_iri
      @_build_disjoint_model(iri, other_iri)

  _build_disjoint_model: (iri, other_iri)->
    clazz       = @get_model_by_iri(iri)
    other_class = @get_model_by_iri(other_iri)
    if !!clazz && !!other_class
      relation = new OntologyClassDisjointRelation([clazz, other_class])
      clazz.add_relation(relation)
      other_class.add_relation(relation)

  _parse_related_individual: ->
    @owl_parser.owl_doc.find('ClassAssertion').each (i,dom)=>
      ele            = jQuery(dom)
      class_iri      = ele.find('Class').attr('IRI')
      class_iri      = ele.find('Class').attr('abbreviatedIRI') if !class_iri
      individual_iri = ele.find('NamedIndividual').attr('IRI')
      @_build_related_individual(class_iri, individual_iri)

  _build_related_individual: (class_iri, individual_iri)->
    clazz      = @get_model_by_iri(class_iri)
    individual = @owl_parser.individual_parser.get_model_by_iri(individual_iri)

    if !!clazz && !!individual
      relation = new OntologyClassIndividualRelation(clazz, individual)
      clazz.add_relation(relation)
      individual.add_relation(relation)    

  _parse_related_object_property: ->
    @owl_parser.owl_doc.find('HasKey').each (i, dom)=>
      ele       = jQuery(dom)
      class_iri = ele.find('Class').attr('IRI')
      class_iri = ele.find('Class').attr('abbreviatedIRI') if !class_iri
      op_iri    = ele.find('ObjectProperty').attr('IRI')
      op_iri    = ele.find('ObjectProperty').attr('abbreviatedIRI') if !op_iri
      if !!op_iri
        @_build_related_object_property(class_iri, op_iri)

  _build_related_object_property: (class_iri, op_iri)->
    clazz = @get_model_by_iri(class_iri)
    op    = @owl_parser.object_property_parser.get_model_by_iri(op_iri)

    if !!clazz && !!op
      clazz.add_object_property(op)

  _parse_related_data_property: ->
    @owl_parser.owl_doc.find('HasKey').each (i, dom)=>
      ele       = jQuery(dom)
      class_iri = ele.find('Class').attr('IRI')
      class_iri = ele.find('Class').attr('abbreviatedIRI') if !class_iri
      dp_iri    = ele.find('DataProperty').attr('IRI')
      dp_iri    = ele.find('DataProperty').attr('abbreviatedIRI') if !dp_iri
      if !!dp_iri
        @_build_related_data_property(class_iri, dp_iri)

  _build_related_data_property: (class_iri, dp_iri)->
    clazz = @get_model_by_iri(class_iri)
    op    = @owl_parser.data_property_parser.get_model_by_iri(dp_iri)

    if !!clazz && !!op
      clazz.add_data_property(op)

jQuery.extend window,
  ClassParser: ClassParser