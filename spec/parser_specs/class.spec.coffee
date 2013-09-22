describe "class parser", ->
  describe "class.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/class.owl",
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

    it "ontology.classes", ->
      iris = ontology.classes.map (clazz)->
        clazz.iri
      expect(['#A','#AA','#AB','#B','#C','#D']).to.eql(iris)
      names = ontology.classes.map (clazz)->
        clazz.name
      expect(['A','AA','AB','B','C','D']).to.eql(names)

    it "ontology.individuals", ->
      iris = ontology.individuals.map (individual)->
        individual.iri
      expect(['#b','#bb']).to.eql(iris)
      names = ontology.individuals.map (individual)->
        individual.name
      expect(['b','bb']).to.eql(names)

    it "class.equivalent_classes", ->
      class_a = owl_parser.get_model_by_iri("#A")
      class_b = owl_parser.get_model_by_iri("#B")
      expect(class_a.equivalence_classes).to.have.include(class_b)
      expect(class_b.equivalence_classes).to.have.include(class_a)

    it "class.sub_classes", ->
      class_a = owl_parser.get_model_by_iri("#A")
      class_aa = owl_parser.get_model_by_iri("#AA")
      class_ab = owl_parser.get_model_by_iri("#AB")
      expect(class_a.sub_classes).to.have.members([class_aa, class_ab])

    it "class.parent_classes", ->
      class_a = owl_parser.get_model_by_iri("#A")
      class_aa = owl_parser.get_model_by_iri("#AA")
      class_ab = owl_parser.get_model_by_iri("#AB")
      expect(class_aa.parent_classes).to.have.include(class_a)
      expect(class_ab.parent_classes).to.have.include(class_a)

    it "class.disjoint_classes", ->
      class_a = owl_parser.get_model_by_iri("#A")
      class_c = owl_parser.get_model_by_iri("#C")
      expect(class_a.disjoint_classes).to.have.include(class_c)
      expect(class_c.disjoint_classes).to.have.include(class_a)

    it "class.individuals", ->
      class_b = owl_parser.get_model_by_iri("#B")
      individual_b = owl_parser.get_model_by_iri("#b")
      individual_bb = owl_parser.get_model_by_iri("#bb")
      expect(class_b.individuals).to.have.include(individual_b)
      expect(class_b.individuals).to.have.include(individual_bb)

  describe "class2.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/class2.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "ontology.classes", ->
      iris = ontology.classes.map (clazz)->
        clazz.iri
      expect(['#A','#B','#C','#D','#E','#F','owl:Thing']).to.eql(iris)
      names = ontology.classes.map (clazz)->
        clazz.name
      expect(['A','B','C','D','E','F','Thing']).to.eql(names)

    it "class.equivalence_classes", ->
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      class_b = owl_parser.get_model_by_iri("#B")
      class_d = owl_parser.get_model_by_iri("#D")
      expect(clazz.equivalence_classes).to.have.include(class_b)
      expect(clazz.equivalence_classes).to.have.include(class_d)
      expect(class_b.equivalence_classes).to.have.include(clazz)
      expect(class_d.equivalence_classes).to.have.include(clazz)

    it "class.sub_classes", ->
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      class_a = owl_parser.get_model_by_iri("#A")
      class_e = owl_parser.get_model_by_iri("#E")
      expect(clazz.sub_classes).to.have.include(class_e)
      expect(class_a.sub_classes).to.have.include(clazz)

    it "class.parent_classes", ->
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      class_a = owl_parser.get_model_by_iri("#A")
      class_e = owl_parser.get_model_by_iri("#E")
      expect(class_e.parent_classes).to.have.include(clazz)
      expect(clazz.parent_classes).to.have.include(class_a)

    it "class.disjoint_classes", ->
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      class_c = owl_parser.get_model_by_iri("#C")
      class_f = owl_parser.get_model_by_iri("#F")
      expect(clazz.disjoint_classes).to.have.include(class_c)
      expect(clazz.disjoint_classes).to.have.include(class_f)
      expect(class_c.disjoint_classes).to.have.include(clazz)
      expect(class_f.disjoint_classes).to.have.include(clazz)