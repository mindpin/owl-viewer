class DataPropertyParser
  @characteristic_data = {
      'FunctionalDataProperty'        : OntologyCharacteristic.FUNCTIONAL
  }
  @DEFAULT_IRIS = ['owl:topDataProperty']

  constructor: (owl_parser, owl_text) ->
    @owl_parser = owl_parser
    @owl_text   = owl_text

  build_model: ->
    @_parse_model()
    @_parse_sub_and_parent_model()
    @_parse_equivalence_model()
    @_parse_disjoint_model()

  build_related: ->
    @_parse_related_domain_thing()
    @_parse_related_range_data_type()
    @_parse_related_characteristic()

  get_model_by_iri: (iri)->
    return null if !@data_properties || @data_properties.length == 0
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
    jQuery(@owl_text).find('Declaration DataProperty').each (i, dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_model(iri)

  _build_model: (iri)->
    data_property = new OntologyDataProperty(iri)
    @data_properties = [] if !@data_properties
    @data_properties.push(data_property)
    return data_property

  _parse_sub_and_parent_model: ->
    jQuery(@owl_text).find('SubDataPropertyOf').each (i, dom)=>
      ele        = jQuery(dom)
      dps        = ele.find('DataProperty')
      sub_iri    = jQuery(dps[0]).attr('IRI')
      parent_iri = jQuery(dps[1]).attr('IRI')
      @_build_sub_and_parent_model(sub_iri, parent_iri)

  _build_sub_and_parent_model: (sub_iri, parent_iri)->
    sub    = @get_model_by_iri(sub_iri)
    parent = @get_model_by_iri(parent_iri)
    parent.add_sub_data_property(sub)
    sub.add_parent_data_property(parent)

  _parse_equivalence_model: ->
    jQuery(@owl_text).find('EquivalentDataProperties').each (i, dom)=>
      ele       = jQuery(dom)
      dps       = ele.find('DataProperty')
      iri       = jQuery(dps[0]).attr('IRI')
      other_iri = jQuery(dps[1]).attr('IRI')
      @_build_equivalence_model(iri, other_iri)

  _build_equivalence_model: (iri, other_iri)->
    dp       = @get_model_by_iri(iri)
    other_dp = @get_model_by_iri(other_iri)
    dp.add_equivalence_data_property(other_dp)
    other_dp.add_equivalence_data_property(dp)

  _parse_disjoint_model: ->
    jQuery(@owl_text).find('DisjointDataProperties').each (i, dom)=>
      ele       = jQuery(dom)
      dps       = ele.find('DataProperty')
      iri       = jQuery(dps[0]).attr('IRI')
      other_iri = jQuery(dps[1]).attr('IRI')
      @_build_disjoint_model(iri, other_iri)

  _build_disjoint_model: (iri, other_iri)->
    dp       = @get_model_by_iri(iri)
    other_dp = @get_model_by_iri(other_iri)
    dp.add_disjoint_data_property(other_dp)
    other_dp.add_disjoint_data_property(dp)

  _parse_related_domain_thing: ->
    jQuery(@owl_text).find('DataPropertyDomain').each (i, dom)=>
      ele       = jQuery(dom)
      iri       = ele.find('DataProperty').attr('IRI')
      thing_iri = ele.find('Class').attr('IRI')
      @_build_related_domain_thing(iri, thing_iri)

  _build_related_domain_thing: (iri, thing_iri)->
    dp    = @get_model_by_iri(iri)
    thing = @owl_parser.thing_parser.get_model_by_iri(thing_iri)
    dp.add_domain_thing(thing)

  _parse_related_range_data_type: ->
    jQuery(@owl_text).find('DataPropertyRange').each (i,dom)=>
      ele = jQuery(dom)
      dp_iri = ele.find('DataProperty').attr('IRI')
      dt_iri = ele.find('Datatype').attr('IRI')
      @_build_related_range_data_type(dp_iri, dt_iri)

  _build_related_range_data_type: (dp_iri, dt_iri)->
    dp = @get_model_by_iri(dp_iri)
    dt = @owl_parser.data_type_parser.get_model_by_iri(dt_iri)
    dp.add_range_data_type(dt)

  _parse_related_characteristic: ->
    for name,value in DataPropertyParser.characteristic_data
      jQuery(@owl_text).find(name).each (i, dom)=>
        iri = jQuery('DataProperty').attr('IRI')
        @_build_characteristic(iri, characteristic)

  _build_related_characteristic: (iri, characteristic)->
    dp = @get_model_by_iri(iri)
    dp.add_characteristic(characteristic)

jQuery.extend window,
  DataPropertyParser: DataPropertyParser