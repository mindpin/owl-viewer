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

    it "individual.classes", ->
      clazz = owl_parser.get_model_by_iri('owl:Thing')
      individual = owl_parser.get_model_by_iri('#a')
      expect(clazz.individuals).to.eql([individual])
      expect(individual.classes).to.eql([clazz])

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

    it 'individual.classes', ->
      individual_a = owl_parser.get_model_by_iri('#a')
      class_a = owl_parser.get_model_by_iri('#A')
      clazz   = owl_parser.get_model_by_iri('owl:Thing')
      expect(individual_a.classes).to.eql([class_a, clazz])
      expect(clazz.individuals).to.eql([individual_a])
