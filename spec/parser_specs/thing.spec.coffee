describe "owl parser", ->
  describe "thing", ->
    ontology = null
    jQuery.ajax
      url: "../data/thing.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "ontology.things", ->
      iris = ontology.things.map (thing)->
        thing.iri
      expect(['#A','#AA','#AB','#B','#C','#D']).to.eql(iris)

