class ThingParser
  constructor: (owl_parser, owl_text) ->
    @owl_parser = owl_parser
    @owl_text   = owl_text

  build_model: ->
    @_parse_thing()

  get_thing_by_iri: (iri)->
    return null if !@things || @things.length == 0
    things = @things.filter (thing)=>
      thing.iri == iri

    return things[0]

  ######################
  _parse_thing: ->
    jQuery(@owl_text).find('Declaration Class').each (i,dom)=>
      ele = jQuery(dom)
      iri = ele.attr('IRI')
      @_build_thing(iri)

  _build_thing: (iri)->
    thing   = new OntologyThing(iri)
    @things = [] if !@things
    @things.push(thing)

jQuery.extend window,
  ThingParser: ThingParser