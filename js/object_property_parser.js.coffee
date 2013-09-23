class ObjectPropertyParser
  @characteristic_data = {
      'FunctionalObjectProperty'        : OntologyCharacteristic.FUNCTIONAL,
      'InverseFunctionalObjectProperty' : OntologyCharacteristic.INVERSE_FUNCTIONAL,
      'SymmetricObjectProperty'         : OntologyCharacteristic.SYMMETRIC,
      'AsymmetricObjectProperty'        : OntologyCharacteristic.ASYMMETRIC,
      'TransitiveObjectProperty'        : OntologyCharacteristic.TRANSITIVE,
      'ReflexiveObjectProperty'         : OntologyCharacteristic.REFLEXIVE,
      'IrreflexiveObjectProperty'       : OntologyCharacteristic.IRREFLEXIVE
  }
  @DEFAULT_IRIS = ['owl:topObjectProperty']

  constructor: (owl_parser) ->
    @owl_parser = owl_parser
    @object_properties = []

  build_model: ->
    @_parse_model()
    @_parse_sub_and_parent_model()
    @_parse_equivalence_model()
    @_parse_inverse_model()
    @_parse_disjoint_model()

  build_related: ->
    @_parse_related_domain_class()
    @_parse_realted_range_class()
    @_parse_related_characteristic()

  get_model_by_iri: (iri)->
    ans = @object_properties.filter (an)=>
      an.iri == iri
    an = ans[0]
    return an if !!an
    return @_get_default_mode_by_iri(iri)

  ################
  _get_default_mode_by_iri: (iri)->
    i = ObjectPropertyParser.DEFAULT_IRIS.indexOf(iri)
    return null if i == -1
    return @_build_model(iri)
    
  _parse_model: ->
    @owl_parser.owl_doc.find('Declaration ObjectProperty').each (i,dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_model(iri)

  _build_model: (iri)->
    odp = new OntologyObjectProperty(iri)
    @object_properties.push(odp)
    return odp

  _parse_sub_and_parent_model: ->
    @owl_parser.owl_doc.find('SubObjectPropertyOf').each (i,dom)=>
      ele        = jQuery(dom)
      ops        = ele.find('ObjectProperty')
      sub_iri    = jQuery(ops[0]).attr('IRI')
      sub_iri    = jQuery(ops[0]).attr('abbreviatedIRI') if !sub_iri
      parent_iri = jQuery(ops[1]).attr('IRI')
      parent_iri = jQuery(ops[1]).attr('abbreviatedIRI') if !parent_iri
      @_build_sub_and_parent_model(sub_iri, parent_iri)

  _build_sub_and_parent_model: (sub_iri, parent_iri)->
    sub    = @get_model_by_iri(sub_iri)
    parent = @get_model_by_iri(parent_iri)

    relation = new OntologyObjectPropertyParentSubRelation(parent, sub)
    parent.add_relation(relation)
    sub.add_relation(relation)

  _parse_equivalence_model: ->
    @owl_parser.owl_doc.find('EquivalentObjectProperties').each (i, dom)=>
      ele       = jQuery(dom)
      ops       = ele.find('ObjectProperty')
      iri       = jQuery(ops[0]).attr('IRI')
      iri       = jQuery(ops[0]).attr('abbreviatedIRI') if !iri
      other_iri = jQuery(ops[1]).attr('IRI')
      other_iri = jQuery(ops[1]).attr('abbreviatedIRI') if !other_iri
      @_build_equivalence_model(iri, other_iri)

  _build_equivalence_model: (iri, other_iri)->
    op       = @get_model_by_iri(iri)
    other_op = @get_model_by_iri(other_iri)

    relation = new OntologyObjectPropertyEquivalentRelation([op, other_op])
    op.add_relation(relation)
    other_op.add_relation(relation)

  _parse_inverse_model: ->
    @owl_parser.owl_doc.find('InverseObjectProperties').each (i, dom)=>
      ele = jQuery(dom)
      ops = ele.find('ObjectProperty')
      iri       = jQuery(ops[0]).attr('IRI')
      iri       = jQuery(ops[0]).attr('abbreviatedIRI') if !iri
      other_iri = jQuery(ops[1]).attr('IRI')
      other_iri = jQuery(ops[1]).attr('abbreviatedIRI') if !other_iri
      @_build_inverse_model(iri, other_iri)

  _build_inverse_model: (iri, other_iri)->
    op       = @get_model_by_iri(iri)
    other_op = @get_model_by_iri(other_iri)
    relation = new OntologyObjectPropertyInverseRelation([op, other_op])
    op.add_relation(relation)
    other_op.add_relation(relation)

  _parse_disjoint_model: ->
    @owl_parser.owl_doc.find('DisjointObjectProperties').each (i, dom)=>
      ele = jQuery(dom)
      ops = ele.find('ObjectProperty')
      iri       = jQuery(ops[0]).attr('IRI')
      iri       = jQuery(ops[0]).attr('abbreviatedIRI') if !iri
      other_iri = jQuery(ops[1]).attr('IRI')
      other_iri = jQuery(ops[1]).attr('abbreviatedIRI') if !other_iri
      @_build_disjoint_model(iri, other_iri)

  _build_disjoint_model: (iri, other_iri)->
    op       = @get_model_by_iri(iri)
    other_op = @get_model_by_iri(other_iri)
    relation = new OntologyObjectPropertyDisjointRelation([op, other_op])
    op.add_relation(relation)
    other_op.add_relation(relation)

  _parse_related_domain_class: ->
    @owl_parser.owl_doc.find('ObjectPropertyDomain').each (i, dom)=>
      ele       = jQuery(dom)
      op_iri    = ele.find('ObjectProperty').attr('IRI')
      op_iri    = ele.find('ObjectProperty').attr('abbreviatedIRI') if !op_iri
      class_iri = ele.find('Class').attr('IRI')
      class_iri = ele.find('Class').attr('abbreviatedIRI') if !class_iri
      @_build_related_domain_class(op_iri, class_iri)

  _build_related_domain_class: (op_iri, class_iri)->
    op    = @get_model_by_iri(op_iri)
    clazz = @owl_parser.class_parser.get_model_by_iri(class_iri)
    
    relation = new OntologyObjectPropertyDomainClassRelation(op, clazz)
    op.add_relation(relation)
    clazz.add_relation(relation)

  _parse_realted_range_class: ->
    @owl_parser.owl_doc.find('ObjectPropertyRange').each (i, dom)=>
      ele = jQuery(dom)
      op_iri    = ele.find('ObjectProperty').attr('IRI')
      op_iri    = ele.find('ObjectProperty').attr('abbreviatedIRI') if !op_iri
      class_iri = ele.find('Class').attr('IRI')
      class_iri = ele.find('Class').attr('abbreviatedIRI') if !class_iri
      @_build_realted_range_class(op_iri, class_iri)

  _build_realted_range_class: (op_iri, class_iri)->
    op    = @get_model_by_iri(op_iri)
    clazz = @owl_parser.class_parser.get_model_by_iri(class_iri)
      
    relation = new OntologyObjectPropertyRangeClassRelation(op, clazz)
    op.add_relation(relation)
    clazz.add_relation(relation)

  _parse_related_characteristic: ->
    for name,value of ObjectPropertyParser.characteristic_data
      @owl_parser.owl_doc.find(name).each (i, dom)=>
        iri = jQuery(dom).find('ObjectProperty').attr('IRI')
        iri = jQuery(dom).find('ObjectProperty').attr('abbreviatedIRI') if !iri
        @_build_related_characteristic(iri, value)

  _build_related_characteristic: (iri, characteristic)->
    op = @get_model_by_iri(iri)
    op.add_characteristic(characteristic)

jQuery.extend window,
  ObjectPropertyParser: ObjectPropertyParser
