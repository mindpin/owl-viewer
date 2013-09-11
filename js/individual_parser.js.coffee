class IndividualParser
  constructor: (owl_parser, owl_text) ->
    @owl_parser = owl_parser
    @owl_text   = owl_text

  build_model: ->
    @_parse_model()
    @_parse_related_same_model()
    @_parse_related_different_model()

  build_related: ->
    @_parse_related_thing()

  get_individual_by_iri: (iri)->
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

  _parse_related_same_model: ->
    jQuery(@owl_text).find('SameIndividual').each (i, dom)->
      ele        = jQuery(dom)
      indis      = ele.find('NamedIndividual')
      iri        = jQuery(indis[0]).attr('IRI')
      other_iri  = jQuery(indis[1]).attr('IRI')
      @_build_related_same_model(iri, other_iri)

  _build_related_same_model: (iri, other_iri)->
    indi       = @get_individual_by_iri(iri)
    other_indi = @get_individual_by_iri(other_iri)
    indi.add_same_individual(other_indi)
    other_indi.add_same_individual(indi)

  _parse_related_different_model: ->
    jQuery(@owl_text).find('DifferentIndividuals').each (i, dom)->
      ele        = jQuery(dom)
      indis      = ele.find('NamedIndividual')
      iri        = jQuery(indis[0]).attr('IRI')
      other_iri  = jQuery(indis[1]).attr('IRI')
      @_build_related_different_model(iri, other_iri)

  _build_related_different_model: (iri, other_iri)->
    indi       = @get_individual_by_iri(iri)
    other_indi = @get_individual_by_iri(other_iri)
    indi.add_different_individual(other_indi)
    other_indi.add_different_individual(indi)

  _parse_related_thing: ->
    jQuery(@owl_text).find('ClassAssertion').each (i,dom)->
      ele            = jQuery(dom)
      thing_iri      = ele.find('Class').attr('IRI')
      individual_iri = ele.find('NamedIndividual').attr('IRI')
      @_build_related_thing(thing_iri, individual_iri)

  _build_related_thing: (thing_iri, individual_iri)->
    thing      = @owl_parser.thing_parser.get_thing_by_iri(thing_iri)
    individual = @get_individual_by_iri(individual_iri)
    individual.add_thing(thing)

jQuery.extend window,
  IndividualParser: IndividualParser
