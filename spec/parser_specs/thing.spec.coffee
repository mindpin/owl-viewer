describe "owl parser", ->
  describe "thing.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/thing.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "ontology.annotations", ->
      expect(ontology.annotations).to.eql([])

    it "ontology.object_properties", ->
      expect(ontology.object_properties).to.eql([])
      
    it "ontology.data_properties", ->
      expect(ontology.data_properties).to.eql([])

    it "ontology.things", ->
      iris = ontology.things.map (thing)->
        thing.iri
      expect(['#A','#AA','#AB','#B','#C','#D']).to.eql(iris)
      names = ontology.things.map (thing)->
        thing.name
      expect(['A','AA','AB','B','C','D']).to.eql(names)

    it "ontology.individuals", ->
      iris = ontology.individuals.map (individual)->
        individual.iri
      expect(['#b','#bb']).to.eql(iris)
      names = ontology.individuals.map (individual)->
        individual.name
      expect(['b','bb']).to.eql(names)

    it "thing.equivalent_things", ->
      thing_a = owl_parser.get_model_by_iri("#A")
      thing_b = owl_parser.get_model_by_iri("#B")
      expect(thing_a.equivalence_things).to.have.include(thing_b)
      expect(thing_b.equivalence_things).to.have.include(thing_a)

    it "thing.sub_things", ->
      thing_a = owl_parser.get_model_by_iri("#A")
      thing_aa = owl_parser.get_model_by_iri("#AA")
      thing_ab = owl_parser.get_model_by_iri("#AB")
      expect(thing_a.sub_things).to.have.members([thing_aa, thing_ab])

    it "thing.parent_things", ->
      thing_a = owl_parser.get_model_by_iri("#A")
      thing_aa = owl_parser.get_model_by_iri("#AA")
      thing_ab = owl_parser.get_model_by_iri("#AB")
      expect(thing_aa.parent_things).to.have.include(thing_a)
      expect(thing_ab.parent_things).to.have.include(thing_a)

    it "thing.disjoint_things", ->
      thing_a = owl_parser.get_model_by_iri("#A")
      thing_c = owl_parser.get_model_by_iri("#C")
      expect(thing_a.disjoint_things).to.have.include(thing_c)
      expect(thing_c.disjoint_things).to.have.include(thing_a)

    it "thing.individuals", ->
      thing_b = owl_parser.get_model_by_iri("#B")
      individual_b = owl_parser.get_model_by_iri("#b")
      individual_bb = owl_parser.get_model_by_iri("#bb")
      expect(thing_b.individuals).to.have.include(individual_b)
      expect(thing_b.individuals).to.have.include(individual_bb)

  describe "thing2.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/thing2.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "thing.equivalence_things", ->
      thing = owl_parser.get_model_by_iri("owl:Thing")
      thing_b = owl_parser.get_model_by_iri("#B")
      thing_d = owl_parser.get_model_by_iri("#D")
      expect(thing.equivalence_things).to.have.include(thing_b)
      expect(thing.equivalence_things).to.have.include(thing_d)
      expect(thing_b.equivalence_things).to.have.include(thing)
      expect(thing_d.equivalence_things).to.have.include(thing)

    it "thing.sub_things", ->
      thing = owl_parser.get_model_by_iri("owl:Thing")
      thing_a = owl_parser.get_model_by_iri("#A")
      thing_e = owl_parser.get_model_by_iri("#E")
      expect(thing.sub_things).to.have.include(thing_e)
      expect(thing_a.sub_things).to.have.include(thing)

    it "thing.parent_things", ->
      thing = owl_parser.get_model_by_iri("owl:Thing")
      thing_a = owl_parser.get_model_by_iri("#A")
      thing_e = owl_parser.get_model_by_iri("#E")
      expect(thing_e.parent_things).to.have.include(thing)
      expect(thing.parent_things).to.have.include(thing_a)

    it "thing.disjoint_things", ->
      thing = owl_parser.get_model_by_iri("owl:Thing")
      thing_c = owl_parser.get_model_by_iri("#C")
      thing_f = owl_parser.get_model_by_iri("#F")
      expect(thing.disjoint_things).to.have.include(thing_c)
      expect(thing.disjoint_things).to.have.include(thing_f)
      expect(thing_c.disjoint_things).to.have.include(thing)
      expect(thing_f.disjoint_things).to.have.include(thing)