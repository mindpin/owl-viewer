describe "individual parser", ->
  describe "individual.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/individual.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "ontology.individuals", ->
      iris = ontology.individuals.map (individual)->
        individual.iri
      expect(['#a','#b','#c','#d']).to.eql(iris)
      names = ontology.individuals.map (individual)->
        individual.name
      expect(['a','b','c','d']).to.eql(names)

    it "individual.things", ->
      thing = owl_parser.get_model_by_iri('owl:Thing')
      individual = owl_parser.get_model_by_iri('#a')
      expect(thing.individuals).to.eql([individual])
      expect(individual.things).to.eql([thing])

    it "individual.same_individuals", ->
      individual_a = owl_parser.get_model_by_iri('#a')
      individual_b = owl_parser.get_model_by_iri('#b')
      expect(individual_a.same_individuals).to.eql([individual_b])
      expect(individual_b.same_individuals).to.eql([individual_a])

    it "individual.different_individuals", ->
      individual_a = owl_parser.get_model_by_iri('#a')
      individual_c = owl_parser.get_model_by_iri('#c')
      expect(individual_a.different_individuals).to.eql([individual_c])
      expect(individual_c.different_individuals).to.eql([individual_a])

    

  describe "individual2.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/individual2.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it 'individual.things', ->
      individual_a = owl_parser.get_model_by_iri('#a')
      thing_a = owl_parser.get_model_by_iri('#A')
      thing   = owl_parser.get_model_by_iri('owl:Thing')
      expect(individual_a.things).to.eql([thing_a, thing])
      expect(thing.individuals).to.eql([individual_a])
