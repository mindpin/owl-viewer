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
    it "ontology.top_classes", ->
      names = ontology.top_classes.map (clazz)->
        clazz.name
      expect(['A','B','C','D']).to.eql(names)
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

    it "equivalent", ->
      class_a = owl_parser.get_model_by_iri("#A")
      class_b = owl_parser.get_model_by_iri("#B")
      a_relations = class_a.relations.filter (relation)=>
        relation.type == 'equivalent'
      b_relations = class_b.relations.filter (relation)=>
        relation.type == 'equivalent'
      relation_a = a_relations[0]
      relation_b = b_relations[0]

      expect(relation_a).to.eql(relation_b)
      expect(relation_a.classes).to.eql(relation_b.classes)
      expect(relation_a.classes).to.eql([class_a, class_b])


    it "parent-sub", ->
      class_a = owl_parser.get_model_by_iri("#A")
      class_aa = owl_parser.get_model_by_iri("#AA")
      class_ab = owl_parser.get_model_by_iri("#AB")

      a_relations = class_a.relations.filter (relation)=>
        relation.type == 'parent-sub'
      aa_relations = class_aa.relations.filter (relation)=>
        relation.type == 'parent-sub'
      ab_relations = class_ab.relations.filter (relation)=>
        relation.type == 'parent-sub'

      relation_aa = aa_relations[0]
      relation_ab = ab_relations[0]

      expect(relation_aa).to.eql(a_relations[0])
      expect(relation_aa.sub).to.eql(class_aa)
      expect(relation_aa.parent).to.eql(class_a)

      expect(relation_ab).to.eql(a_relations[1])
      expect(relation_ab.sub).to.eql(class_ab)
      expect(relation_ab.parent).to.eql(class_a)

      expect(class_a.sub_classes()).to.eql([class_aa, class_ab])
      expect(class_aa.parent_classes()).to.eql([class_a])
      expect(class_ab.parent_classes()).to.eql([class_a])
      

    it "disjoint", ->
      class_a = owl_parser.get_model_by_iri("#A")
      class_c = owl_parser.get_model_by_iri("#C")
      a_relations = class_a.relations.filter (relation)=>
        relation.type == 'disjoint'
      c_relations = class_c.relations.filter (relation)=>
        relation.type == 'disjoint'
      relation_a = a_relations[0]
      relation_c = c_relations[0]

      expect(relation_a).to.eql(relation_c)
      expect(relation_a.classes).to.eql(relation_c.classes)
      expect(relation_a.classes).to.eql([class_a, class_c])

    it "class-individual", ->
      class_b = owl_parser.get_model_by_iri("#B")
      individual_b = owl_parser.get_model_by_iri("#b")
      individual_bb = owl_parser.get_model_by_iri("#bb")

      class_b_relations = class_b.relations.filter (relation)=>
        relation.type == 'class-individual'
      individual_b_relations = individual_b.relations.filter (relation)=>
        relation.type == 'class-individual'
      individual_bb_relations = individual_bb.relations.filter (relation)=>
        relation.type == 'class-individual'

      individual_b_relation = individual_b_relations[0]
      individual_bb_relation = individual_bb_relations[0]

      expect(individual_b_relation.individual).to.eql(individual_b)
      expect(individual_b_relation.class).to.eql(class_b)

      expect(individual_bb_relation.individual).to.eql(individual_bb)
      expect(individual_bb_relation.class).to.eql(class_b)

      expect(class_b_relations[0]).to.eql(individual_b_relation)
      expect(class_b_relations[0].individual).to.eql(individual_b_relation.individual)
      expect(class_b_relations[0].class).to.eql(individual_b_relation.class)

      expect(class_b_relations[1]).to.eql(individual_bb_relation)
      expect(class_b_relations[1].individual).to.eql(individual_bb_relation.individual)
      expect(class_b_relations[1].class).to.eql(individual_bb_relation.class)
      expect(class_b.individuals()).to.eql([individual_b, individual_bb])
      expect(individual_b.classes()).to.eql([class_b])
      expect(individual_bb.classes()).to.eql([class_b])

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

    it "equivalent", ->
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      class_b = owl_parser.get_model_by_iri("#B")
      class_d = owl_parser.get_model_by_iri("#D")

      relations = clazz.relations.filter (relation)=>
        relation.type == 'equivalent'
      b_relations = class_b.relations.filter (relation)=>
        relation.type == 'equivalent'
      d_relations = class_d.relations.filter (relation)=>
        relation.type == 'equivalent'
      relation_b = b_relations[0]
      relation_d = d_relations[0]
      
      expect(relations[0]).to.eql(relation_b)
      expect(relation_b.classes).to.eql(relations[0].classes)
      expect(relation_b.classes).to.eql([class_b, clazz])
      
      expect(relations[1]).to.eql(relation_d)
      expect(relation_d.classes).to.eql(relations[1].classes)
      expect(relation_d.classes).to.eql([class_d, clazz])

    it "parent-sub", ->
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      class_a = owl_parser.get_model_by_iri("#A")
      class_e = owl_parser.get_model_by_iri("#E")

      relations = clazz.relations.filter (relation)=>
        relation.type == 'parent-sub'
      a_relations = class_a.relations.filter (relation)=>
        relation.type == 'parent-sub'
      e_relations = class_e.relations.filter (relation)=>
        relation.type == 'parent-sub'

      relation_a = a_relations[0]
      relation_e = e_relations[0]
      expect(relation_a).to.eql(relations[1])
      expect(relation_a.sub).to.eql(clazz)
      expect(relation_a.parent).to.eql(class_a)

      expect(relation_e).to.eql(relations[0])
      expect(relation_e.sub).to.eql(class_e)
      expect(relation_e.parent).to.eql(clazz)

    it "disjoint", ->
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      class_c = owl_parser.get_model_by_iri("#C")
      class_f = owl_parser.get_model_by_iri("#F")

      relations = clazz.relations.filter (relation)=>
        relation.type == 'disjoint'
      c_relations = class_c.relations.filter (relation)=>
        relation.type == 'disjoint'
      f_relations = class_f.relations.filter (relation)=>
        relation.type == 'disjoint'

      relation_c = c_relations[0]
      relation_f = f_relations[0]

      expect(relation_c).to.eql(relations[0])
      expect(relation_c.classes).to.eql(relations[0].classes)
      expect(relation_c.classes).to.eql([class_c, clazz])

      expect(relation_f).to.eql(relations[1])
      expect(relation_f.classes).to.eql(relations[1].classes)
      expect(relation_f.classes).to.eql([class_f, clazz])