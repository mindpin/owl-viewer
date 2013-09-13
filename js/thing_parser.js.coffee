class ThingParser
  @DEFAULT_IRIS = ['owl:Thing']

  constructor: (owl_parser, owl_text) ->
    @owl_parser = owl_parser
    @owl_text   = owl_text

  build_model: ->
    @_parse_model()
    @_parse_sub_and_parent_model()
    @_parse_equivalence_model()
    @_parse_disjoint_model()

  build_related: ->
    @_parse_related_individual()
    @_parse_related_object_property()
    @_parse_related_data_property()

  get_model_by_iri: (iri)->
    return null if !@things || @things.length == 0
    things = @things.filter (thing)=>
      thing.iri == iri
    thing = things[0]
    return thing if !!thing
    return @_get_default_mode_by_iri(iri)

  ######################
  _get_default_mode_by_iri: (iri)->
    i = ThingParser.DEFAULT_IRIS.indexOf(iri)
    return null if i == -1
    return @_build_model(iri)

  _parse_model: ->
    jQuery(@owl_text).find('Declaration Class').each (i,dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_model(iri)

  _build_model: (iri)->
    thing   = new OntologyThing(iri)
    @things = [] if !@things
    @things.push(thing)
    return thing

  _parse_sub_and_parent_model: ->
    jQuery(@owl_text).find('SubClassOf').each (i,dom)=>
      ele        = jQuery(dom)
      thing_eles = ele.find('Class')
      sub_iri    = jQuery(thing_eles[0]).attr('IRI')
      sub_iri    = jQuery(thing_eles[0]).attr('abbreviatedIRI') if !sub_iri
      parent_iri = jQuery(thing_eles[1]).attr('IRI')
      parent_iri = jQuery(thing_eles[1]).attr('abbreviatedIRI') if !parent_iri
      @_build_sub_and_parent_model(sub_iri, parent_iri)

  _build_sub_and_parent_model: (sub_iri, parent_iri)->
    sub    = @get_model_by_iri(sub_iri)
    parent = @get_model_by_iri(parent_iri)
    parent.add_sub_thing(sub)
    sub.add_parent_thing(parent)

  _parse_equivalence_model: ->
    jQuery(@owl_text).find('EquivalentClasses').each (i,dom)=>
      ele        = jQuery(dom)
      thing_eles = ele.find('Class')
      iri        = jQuery(thing_eles[0]).attr('IRI')
      iri        = jQuery(thing_eles[0]).attr('abbreviatedIRI') if !iri
      other_iri  = jQuery(thing_eles[1]).attr('IRI')
      other_iri  = jQuery(thing_eles[1]).attr('abbreviatedIRI') if !other_iri
      @_build_equivalence_model(iri, other_iri)

  _build_equivalence_model: (iri, other_iri)->
    thing       = @get_model_by_iri(iri)
    other_thing = @get_model_by_iri(other_iri)
    thing.add_equivalence_thing(other_thing)
    other_thing.add_equivalence_thing(thing)

  _parse_disjoint_model: ->
    jQuery(@owl_text).find('DisjointClasses').each (i,dom)=>
      ele        = jQuery(dom)
      thing_eles = ele.find('Class')
      iri        = jQuery(thing_eles[0]).attr('IRI')
      iri        = jQuery(thing_eles[0]).attr('abbreviatedIRI') if !iri
      other_iri  = jQuery(thing_eles[1]).attr('IRI')
      other_iri  = jQuery(thing_eles[1]).attr('abbreviatedIRI') if !other_iri
      @_build_disjoint_model(iri, other_iri)

  _build_disjoint_model: (iri, other_iri)->
    thing       = @get_model_by_iri(iri)
    other_thing = @get_model_by_iri(other_iri)
    thing.add_disjoint_thing(other_thing)
    other_thing.add_disjoint_thing(thing)

  _parse_related_individual: ->
    jQuery(@owl_text).find('ClassAssertion').each (i,dom)=>
      ele            = jQuery(dom)
      thing_iri      = ele.find('Class').attr('IRI')
      thing_iri      = ele.find('Class').attr('abbreviatedIRI') if !thing_iri
      individual_iri = ele.find('NamedIndividual').attr('IRI')
      @_build_related_individual(thing_iri, individual_iri)

  _build_related_individual: (thing_iri, individual_iri)->
    thing      = @get_model_by_iri(thing_iri)
    individual = @owl_parser.individual_parser.get_model_by_iri(individual_iri)
    thing.add_individual(individual)

  _parse_related_object_property: ->
    jQuery(@owl_text).find('HasKey').each (i, dom)=>
      ele       = jQuery(dom)
      thing_iri = ele.find('Class').attr('IRI')
      thing_iri = ele.find('Class').attr('abbreviatedIRI') if !thing_iri
      op_iri    = ele.find('ObjectProperty').attr('IRI')
      op_iri    = ele.find('ObjectProperty').attr('abbreviatedIRI') if !op_iri
      @_build_related_object_property(thing_iri, op_iri)

  _build_related_object_property: (thing_iri, op_iri)->
    thing = @get_model_by_iri(thing_iri)
    op    = @owl_parser.object_property_parser.get_model_by_iri(op_iri)
    thing.add_object_property(op)

  _parse_related_data_property: ->
    jQuery(@owl_text).find('HasKey').each (i, dom)=>
      ele       = jQuery(dom)
      thing_iri = ele.find('Class').attr('IRI')
      thing_iri = ele.find('Class').attr('abbreviatedIRI') if !thing_iri
      dp_iri    = ele.find('DataProperty').attr('IRI')
      @_build_related_data_property(thing_iri, dp_iri)

  _build_related_data_property: (thing_iri, dp_iri)->
    thing = @get_model_by_iri(thing_iri)
    op    = @owl_parser.data_property_parser.get_model_by_iri(dp_iri)
    thing.add_data_property(op)

jQuery.extend window,
  ThingParser: ThingParser