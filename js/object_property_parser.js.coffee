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

  constructor: (owl_parser, owl_text) ->
    @owl_parser = owl_parser
    @owl_text   = owl_text

  build_model: ->
    @_parse_model()
    @_parse_sub_and_parent_model()
    @_parse_equivalence_model()
    @_parse_inverse_model()
    @_parse_disjoint_model()

  build_related: ->
    @_parse_related_domain_thing()
    @_parse_realted_range_thing()
    @_parse_related_characteristic()

  get_model_by_iri: (iri)->
    return null if !@object_properties || @object_properties.length == 0
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
    jQuery(@owl_text).find('Declaration ObjectProperty').each (i,dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_model(iri)

  _build_model: (iri)->
    odp = new OntologyObjectProperty(iri)
    @object_properties = [] if !@object_properties
    @object_properties.push(odp)
    return odp

  _parse_sub_and_parent_model: ->
    jQuery(@owl_text).find('SubObjectPropertyOf').each (i,dom)=>
      ele        = jQuery(dom)
      ops        = ele.find('ObjectProperty')
      sub_iri    = jQuery(ops[0]).attr('IRI')
      parent_iri = jQuery(ops[1]).attr('IRI')
      @_build_sub_and_parent_model(sub_iri, parent_iri)

  _build_sub_and_parent_model: (sub_iri, parent_iri)->
    sub    = @get_model_by_iri(sub_iri)
    parent = @get_model_by_iri(parent_iri)
    parent.add_sub_object_property(sub)
    sub.add_parent_object_property(parent)

  _parse_equivalence_model: ->
    jQuery(@owl_text).find('EquivalentObjectProperties').each (i, dom)=>
      ele       = jQuery(dom)
      ops       = ele.find('ObjectProperty')
      iri       = jQuery(ops[0]).attr('IRI')
      other_iri = jQuery(ops[0]).attr('IRI')
      @_build_equivalence_model(iri, other_iri)

  _build_equivalence_model: (iri, other_iri)->
    op       = @get_model_by_iri(iri)
    other_op = @get_model_by_iri(other_iri)
    op.add_equivalence_object_property(other_op)
    other_op.add_equivalence_object_property(op)

  _parse_inverse_model: ->
    jQuery(@owl_text).find('InverseObjectProperties').each (i, dom)=>
      ele = jQuery(dom)
      ops = ele.find('ObjectProperty')
      iri       = jQuery(ops[0]).attr('IRI')
      other_iri = jQuery(ops[0]).attr('IRI')
      @_build_inverse_model(iri, other_iri)

  _build_inverse_model: (iri, other_iri)->
    op       = @get_model_by_iri(iri)
    other_op = @get_model_by_iri(other_iri)
    op.add_inverse_object_property(other_op)
    other_op.add_inverse_object_property(op)

  _parse_disjoint_model: ->
    jQuery(@owl_text).find('DisjointObjectProperties').each (i, dom)=>
      ele = jQuery(dom)
      ops = ele.find('ObjectProperty')
      iri       = jQuery(ops[0]).attr('IRI')
      other_iri = jQuery(ops[0]).attr('IRI')
      @_build_disjoint_model(iri, other_iri)

  _build_disjoint_model: (iri, other_iri)->
    op       = @get_model_by_iri(iri)
    other_op = @get_model_by_iri(other_iri)
    op.add_disjoint_object_property(other_op)
    other_op.add_disjoint_object_property(op)

  _parse_related_domain_thing: ->
    jQuery(@owl_text).find('ObjectPropertyDomain').each (i, dom)=>
      ele       = jQuery(dom)
      op_iri    = ele.find('ObjectProperty').attr('IRI')
      thing_iri = ele.find('Class').attr('IRI')
      thing_iri = ele.find('Class').attr('abbreviatedIRI') if !thing_iri
      @_build_related_domain_thing(op_iri, thing_iri)

  _build_related_domain_thing: (op_iri, thing_iri)->
    op    = @get_model_by_iri(op_iri)
    thing = @owl_parser.thing_parser.get_model_by_iri(thing_iri)
    op.add_domain_thing(thing)

  _parse_realted_range_thing: ->
    jQuery(@owl_text).find('ObjectPropertyRange').each (i, dom)=>
      ele = jQuery(dom)
      op_iri    = ele.find('ObjectProperty').attr('IRI')
      thing_iri = ele.find('Class').attr('IRI')
      thing_iri = ele.find('Class').attr('abbreviatedIRI') if !thing_iri
      @_build_realted_range_thing(op_iri, thing_iri)

  _build_realted_range_thing: (op_iri, thing_iri)->
    op    = @get_model_by_iri(op_iri)
    thing = @owl_parser.thing_parser.get_model_by_iri(thing_iri)
    op.add_range_thing(thing)

  _parse_related_characteristic: ->
    for name,value in ObjectPropertyParser.characteristic_data
      jQuery(@owl_text).find(name).each (i, dom)=>
        iri = jQuery('ObjectProperty').attr('IRI')
        @_build_related_characteristic(iri, characteristic)

  _build_related_characteristic: (iri, characteristic)->
    op = @get_model_by_iri(iri)
    op.add_characteristic(characteristic)

jQuery.extend window,
  ObjectPropertyParser: ObjectPropertyParser
