class ThingParser
  constructor: (owl_parser, owl_text) ->
    @owl_parser = owl_parser
    @owl_text   = owl_text

  build_model: ->
    @_parse_thing()
    @_parse_related_sub_and_parent_thing()
    @_parse_equivalence_thing()
    @_parse_disjoint_thing()

  build_related: ->
    @_parse_related_individual()

  get_thing_by_iri: (iri)->
    return null if !@things || @things.length == 0
    things = @things.filter (thing)=>
      thing.iri == iri

    return things[0]

  ######################
  _parse_thing: ->
    jQuery(@owl_text).find('Declaration Class').each (i,dom)->
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_thing(iri)

  _build_thing: (iri)->
    thing   = new OntologyThing(iri)
    @things = [] if !@things
    @things.push(thing)

  _parse_related_sub_and_parent_thing: ->
    jQuery(@owl_text).find('SubClassOf').each (i,dom)->
      ele        = jQuery(dom)
      thing_eles = ele.find('Class')
      sub_iri    = jQuery(thing_eles[0]).attr('IRI')
      parent_iri = jQuery(thing_eles[1]).attr('IRI')
      @_build_related_sub_and_parent_thing(sub_iri, parent_iri)

  _build_related_sub_and_parent_thing: (sub_iri, parent_iri)->
    sub    = @get_thing_by_iri(sub_iri)
    parent = @get_thing_by_iri(parent_iri)
    parent.add_sub_thing(sub)
    sub.add_parent_thing(parent)

  _parse_equivalence_thing: ->
    jQuery(@owl_text).find('EquivalentClasses').each (i,dom)->
      ele        = jQuery(dom)
      thing_eles = ele.find('Class')
      iri        = jQuery(thing_eles[0]).attr('IRI')
      other_iri  = jQuery(thing_eles[1]).attr('IRI')
      @_build_equivalence_thing(iri, other_iri)

  _build_equivalence_thing: (iri, other_iri)->
    thing       = @get_thing_by_iri(iri)
    other_thing = @get_thing_by_iri(other_iri)
    thing.add_equivalence_thing(other_thing)
    other_thing.add_equivalence_thing(thing)

  _parse_disjoint_thing: ->
    jQuery(@owl_text).find('DisjointClasses').each (i,dom)->
      ele        = jQuery(dom)
      thing_eles = ele.find('Class')
      iri        = jQuery(thing_eles[0]).attr('IRI')
      other_iri  = jQuery(thing_eles[1]).attr('IRI')
      @_build_disjoint_thing(iri, other_iri)

  _build_disjoint_thing: (iri, other_iri)->
    thing       = @get_thing_by_iri(iri)
    other_thing = @get_thing_by_iri(other_iri)
    thing.add_disjoint_thing(other_thing)
    other_thing.add_disjoint_thing(thing)

  _parse_related_individual: ->
    jQuery(@owl_text).find('ClassAssertion').each (i,dom)->
      ele            = jQuery(dom)
      thing_iri      = ele.find('Class').attr('IRI')
      individual_iri = ele.find('NamedIndividual').attr('IRI')
      @_build_related_individual(thing_iri, individual_iri)

  _build_related_individual: (thing_iri, individual_iri)->
    thing      = @get_thing_by_iri(thing_iri)
    individual = @owl_parser.individual_parser.get_individual_by_iri(individual_iri)
    thing.add_individual(individual)
    
jQuery.extend window,
  ThingParser: ThingParser