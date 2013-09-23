class DataPropertyParser
  @characteristic_data = {
      'FunctionalDataProperty'        : OntologyCharacteristic.FUNCTIONAL
  }
  @DEFAULT_IRIS = ['owl:topDataProperty']

  constructor: (owl_parser) ->
    @owl_parser = owl_parser
    @data_properties = []

  build_model: ->
    @_parse_model()
    @_parse_sub_and_parent_model()
    @_parse_equivalence_model()
    @_parse_disjoint_model()

  build_related: ->
    @_parse_related_domain_class()
    @_parse_related_range_data_type()
    @_parse_related_characteristic()

  get_model_by_iri: (iri)->
    dps = @data_properties.filter (dp)=>
      dp.iri == iri
    dp = dps[0]
    return dp if !!dp
    return @_get_default_mode_by_iri(iri)

  ###################
  _get_default_mode_by_iri: (iri)->
    i = DataPropertyParser.DEFAULT_IRIS.indexOf(iri)
    return null if i == -1
    return @_build_model(iri)

  _parse_model: ->
    @owl_parser.owl_doc.find('Declaration DataProperty').each (i, dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_model(iri)

  _build_model: (iri)->
    data_property = new OntologyDataProperty(iri)
    @data_properties.push(data_property)
    return data_property

  _parse_sub_and_parent_model: ->
    @owl_parser.owl_doc.find('SubDataPropertyOf').each (i, dom)=>
      ele        = jQuery(dom)
      dps        = ele.find('DataProperty')
      sub_iri    = jQuery(dps[0]).attr('IRI')
      sub_iri    = jQuery(dps[0]).attr('abbreviatedIRI') if !sub_iri
      parent_iri = jQuery(dps[1]).attr('IRI')
      parent_iri = jQuery(dps[1]).attr('abbreviatedIRI') if !parent_iri
      @_build_sub_and_parent_model(sub_iri, parent_iri)

  _build_sub_and_parent_model: (sub_iri, parent_iri)->
    sub    = @get_model_by_iri(sub_iri)
    parent = @get_model_by_iri(parent_iri)

    relation = new OntologyDataPropertyParentSubRelation(parent, sub)
    parent.add_relation(relation)
    sub.add_relation(relation)

  _parse_equivalence_model: ->
    @owl_parser.owl_doc.find('EquivalentDataProperties').each (i, dom)=>
      ele       = jQuery(dom)
      dps       = ele.find('DataProperty')
      iri       = jQuery(dps[0]).attr('IRI')
      iri       = jQuery(dps[0]).attr('abbreviatedIRI') if !iri
      other_iri = jQuery(dps[1]).attr('IRI')
      other_iri = jQuery(dps[1]).attr('abbreviatedIRI') if !other_iri
      @_build_equivalence_model(iri, other_iri)

  _build_equivalence_model: (iri, other_iri)->
    dp       = @get_model_by_iri(iri)
    other_dp = @get_model_by_iri(other_iri)

    relation = new OntologyDataPropertyEquivalentRelation([dp, other_dp])
    dp.add_relation(relation)
    other_dp.add_relation(relation)

  _parse_disjoint_model: ->
    @owl_parser.owl_doc.find('DisjointDataProperties').each (i, dom)=>
      ele       = jQuery(dom)
      dps       = ele.find('DataProperty')
      iri       = jQuery(dps[0]).attr('IRI')
      iri       = jQuery(dps[0]).attr('abbreviatedIRI') if !iri
      other_iri = jQuery(dps[1]).attr('IRI')
      other_iri = jQuery(dps[1]).attr('abbreviatedIRI') if !other_iri
      @_build_disjoint_model(iri, other_iri)

  _build_disjoint_model: (iri, other_iri)->
    dp       = @get_model_by_iri(iri)
    other_dp = @get_model_by_iri(other_iri)

    relation = new OntologyDataPropertyDisjointRelation([dp, other_dp])
    dp.add_relation(relation)
    other_dp.add_relation(relation)

  _parse_related_domain_class: ->
    @owl_parser.owl_doc.find('DataPropertyDomain').each (i, dom)=>
      ele       = jQuery(dom)
      iri       = ele.find('DataProperty').attr('IRI')
      iri       = ele.find('DataProperty').attr('abbreviatedIRI') if !iri
      class_iri = ele.find('Class').attr('IRI')
      class_iri = ele.find('Class').attr('abbreviatedIRI') if !class_iri
      @_build_related_domain_class(iri, class_iri)

  _build_related_domain_class: (iri, class_iri)->
    dp    = @get_model_by_iri(iri)
    clazz = @owl_parser.class_parser.get_model_by_iri(class_iri)

    relation = new OntologyDataPropertyDomainClassRelation(dp, clazz)
    dp.add_relation(relation)
    clazz.add_relation(relation)

  _parse_related_range_data_type: ->
    @owl_parser.owl_doc.find('DataPropertyRange').each (i,dom)=>
      ele = jQuery(dom)
      dp_iri = ele.find('DataProperty').attr('IRI')
      dp_iri = ele.find('DataProperty').attr('abbreviatedIRI') if !dp_iri
      dt_iri = ele.find('Datatype').attr('IRI')
      dt_iri = ele.find('Datatype').attr('abbreviatedIRI') if !dt_iri
      @_build_related_range_data_type(dp_iri, dt_iri)

  _build_related_range_data_type: (dp_iri, dt_iri)->
    dp = @get_model_by_iri(dp_iri)
    dt = @owl_parser.data_type_parser.get_model_by_iri(dt_iri)
    
    relation = new OntologyDataPropertyRangeDataTypeRelation(dp, dt)
    dp.add_relation(relation)
    dt.add_relation(relation)

  _parse_related_characteristic: ->
    for name,value of DataPropertyParser.characteristic_data
      @owl_parser.owl_doc.find(name).each (i, dom)=>
        iri = jQuery(dom).find('DataProperty').attr('IRI')
        iri = jQuery(dom).find('DataProperty').attr('abbreviatedIRI') if !iri
        @_build_related_characteristic(iri, value)

  _build_related_characteristic: (iri, characteristic)->
    dp = @get_model_by_iri(iri)
    dp.add_characteristic(characteristic)

jQuery.extend window,
  DataPropertyParser: DataPropertyParser