class IndividualParser
  constructor: (owl_parser, owl_text) ->
    @owl_parser = owl_parser
    @owl_text   = owl_text

  build_model: ->
    @_parse_model()
    @_parse_same_model()
    @_parse_different_model()

  build_related: ->
    @_parse_related_thing()
    @_parse_related_object_property_value()
    @_parse_related_data_property_value()

  get_model_by_iri: (iri)->
    return null if !@individuals || @individuals.length == 0
    individuals = @individuals.filter (indi)=>
      indi.iri == iri

    return individuals[0]

  #####
  _parse_model: ->
    jQuery(@owl_text).find('Declaration NamedIndividual').each (i,dom)->
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_model(iri)

  _build_model: (iri)->
    indi         = new OntologyIndividual(iri)
    @individuals = [] if !@individuals
    @individuals.push(indi)

  _parse_same_model: ->
    jQuery(@owl_text).find('SameIndividual').each (i, dom)->
      ele        = jQuery(dom)
      indis      = ele.find('NamedIndividual')
      iri        = jQuery(indis[0]).attr('IRI')
      other_iri  = jQuery(indis[1]).attr('IRI')
      @_build_same_model(iri, other_iri)

  _build_same_model: (iri, other_iri)->
    indi       = @get_model_by_iri(iri)
    other_indi = @get_model_by_iri(other_iri)
    indi.add_same_individual(other_indi)
    other_indi.add_same_individual(indi)

  _parse_different_model: ->
    jQuery(@owl_text).find('DifferentIndividuals').each (i, dom)->
      ele        = jQuery(dom)
      indis      = ele.find('NamedIndividual')
      iri        = jQuery(indis[0]).attr('IRI')
      other_iri  = jQuery(indis[1]).attr('IRI')
      @_build_different_model(iri, other_iri)

  _build_different_model: (iri, other_iri)->
    indi       = @get_model_by_iri(iri)
    other_indi = @get_model_by_iri(other_iri)
    indi.add_different_individual(other_indi)
    other_indi.add_different_individual(indi)

  _parse_related_thing: ->
    jQuery(@owl_text).find('ClassAssertion').each (i,dom)->
      ele            = jQuery(dom)
      thing_iri      = ele.find('Class').attr('IRI')
      individual_iri = ele.find('NamedIndividual').attr('IRI')
      @_build_related_thing(thing_iri, individual_iri)

  _build_related_thing: (thing_iri, individual_iri)->
    thing      = @owl_parser.thing_parser.get_model_by_iri(thing_iri)
    individual = @get_model_by_iri(individual_iri)
    individual.add_thing(thing)

  _parse_related_object_property_value: ->
    jQuery(@owl_text).find('ObjectPropertyAssertion').each (i, dom)->
      ele = jQuery(dom)
      op_iri = ele.find('ObjectProperty').attr('IRI')
      indis = ele.find('NamedIndividual')
      indi_iri = jQuery(indis[0]).attr('IRI')
      value_indi_iri = jQuery(indis[1]).attr('IRI')
      @_build_related_object_property_value(indi_iri, op_iri, value_indi_iri)

  _build_related_object_property_value: (indi_iri, op_iri, value_indi_iri)->
    indi  = @get_model_by_iri(indi_iri)
    value = @get_model_by_iri(value_indi_iri)
    op    = @owl_parser.object_property_parser.get_model_by_iri(op_iri)
    opv = new OntologyObjectPropertyValue(op, value)
    indi.add_object_property_value(opv)

  _parse_related_data_property_value: ->
    jQuery(@owl_text).find('DataPropertyAssertion').each (i, dom)->
      ele = jQuery(dom)
      dp_iri = ele.find('DataProperty').attr('IRI')
      indi_iri = ele.find('NamedIndividual').attr('IRI')
      data_type_iri = ele.find('Literal').attr('datatypeIRI')
      value = ele.find('Literal').value()
      @_build_related_data_property_value(indi_iri, dp_iri, data_type_iri, value)

  _build_related_data_property_value: (indi_iri, dp_iri, data_type_iri, value)->
    indi = @get_model_by_iri(indi_iri)
    dp = @owl_parser.data_property_parser.get_model_by_iri(dp_iri)
    data_type = @owl_parser.data_type_parser.get_model_by_iri(data_type_iri)

    dtv = new OntologyDatatypeValue(data_type, value)
    dpv = new OntologyDataPropertyValue(dp, dtv)
    indi.add_data_property_value(dpv)

jQuery.extend window,
  IndividualParser: IndividualParser
