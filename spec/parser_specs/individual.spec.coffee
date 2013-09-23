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

    it "class-individual", ->
      clazz = owl_parser.get_model_by_iri('owl:Thing')
      individual = owl_parser.get_model_by_iri('#a')

      clazz_relations = clazz.relations.filter (relation)=>
        relation.type == 'class-individual'
      individual_relations = individual.relations.filter (relation)=>
        relation.type == 'class-individual'

      clazz_relation = clazz_relations[0]
      individual_relation = individual_relations[0]

      expect(clazz_relation).to.eql(individual_relation)
      expect(clazz_relation.individual).to.eql(individual_relation.individual)
      expect(clazz_relation.class).to.eql(individual_relation.class)

    it "same_individuals", ->
      individual_a = owl_parser.get_model_by_iri('#a')
      individual_b = owl_parser.get_model_by_iri('#b')

      a_relations = individual_a.relations.filter (relation)=>
        relation.type == 'same'
      b_relations = individual_b.relations.filter (relation)=>
        relation.type == 'same'

      relation_a = a_relations[0]
      relation_b = b_relations[0]

      expect(relation_a).to.eql(relation_b)
      expect(relation_a.individuals).to.eql([individual_a, individual_b])

    it "different_individuals", ->
      individual_a = owl_parser.get_model_by_iri('#a')
      individual_c = owl_parser.get_model_by_iri('#c')

      a_relations = individual_a.relations.filter (relation)=>
        relation.type == 'different'
      c_relations = individual_c.relations.filter (relation)=>
        relation.type == 'different'

      relation_a = a_relations[0]
      relation_c = c_relations[0]

      expect(relation_a).to.eql(relation_c)
      expect(relation_a.individuals).to.eql([individual_a, individual_c])

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

      individual_a_relations = individual_a.relations.filter (relation)=>
        relation.type == 'class-individual'
      class_a_relations = class_a.relations.filter (relation)=>
        relation.type == 'class-individual'
      clazz_relations = clazz.relations.filter (relation)=>
        relation.type == 'class-individual'

      class_a_relation = class_a_relations[0]
      clazz_relation  = clazz_relations[0]

      expect(individual_a_relations[0]).to.eql(class_a_relation)
      expect(individual_a_relations[0].individual).to.eql(class_a_relation.individual)
      expect(individual_a_relations[0].class).to.eql(class_a_relation.class)

      expect(individual_a_relations[1]).to.eql(clazz_relation)
      expect(individual_a_relations[1].individual).to.eql(clazz_relation.individual)
      expect(individual_a_relations[1].class).to.eql(clazz_relation.class)