describe "annotation parser", ->
  describe "annotation.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/annotation.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "ontology.annotations", ->
      iris = ontology.annotations.map (annotation)->
        annotation.iri
      expect(['#a','#aa','#ab','#b']).to.eql(iris)
      names = ontology.annotations.map (annotation)->
        annotation.name
      expect(['a','aa','ab','b']).to.eql(names)

    it "annotation-parent-sub", ->
      annotation_a = owl_parser.get_model_by_iri('#a')
      annotation_aa = owl_parser.get_model_by_iri('#aa')
      annotation_ab = owl_parser.get_model_by_iri('#ab')

      annotation_a_relations = annotation_a.relations.filter (relation)=>
        relation.type == 'annotation-parent-sub'
      annotation_aa_relations = annotation_aa.relations.filter (relation)=>
        relation.type == 'annotation-parent-sub'
      annotation_ab_relations = annotation_ab.relations.filter (relation)=>
        relation.type == 'annotation-parent-sub'

      annotation_aa_relation = annotation_aa_relations[0]
      annotation_ab_relation = annotation_ab_relations[0]

      expect(annotation_a_relations[0]).to.eql(annotation_aa_relation)
      expect(annotation_a_relations[0].parent).to.eql(annotation_aa_relation.parent)
      expect(annotation_a_relations[0].sub).to.eql(annotation_aa_relation.sub)

      expect(annotation_a_relations[1]).to.eql(annotation_ab_relation)
      expect(annotation_a_relations[1].parent).to.eql(annotation_ab_relation.parent)
      expect(annotation_a_relations[1].sub).to.eql(annotation_ab_relation.sub)

    it "annotation-range-class", ->
      annotation_b = owl_parser.get_model_by_iri('#b')
      class_c = owl_parser.get_model_by_iri('#C')
      class_d = owl_parser.get_model_by_iri('#D')

      annotation_b_relations = annotation_b.relations.filter (relation)=>
        relation.type == 'annotation-range-class'
      class_c_relations = class_c.relations.filter (relation)=>
        relation.type == 'annotation-range-class'
      class_d_relations = class_d.relations.filter (relation)=>
        relation.type == 'annotation-range-class'

      class_c_relation = class_c_relations[0]
      class_d_relation = class_d_relations[0]

      expect(annotation_b_relations[0]).to.eql(class_c_relation)
      expect(class_c_relation.class).to.eql(class_c)
      expect(class_c_relation.annotation).to.eql(annotation_b)

      expect(annotation_b_relations[1]).to.eql(class_d_relation)
      expect(class_d_relation.class).to.eql(class_d)
      expect(class_d_relation.annotation).to.eql(annotation_b)


    it "annotation-domain-class", ->
      annotation_b = owl_parser.get_model_by_iri('#b')
      class_a = owl_parser.get_model_by_iri('#A')
      class_b = owl_parser.get_model_by_iri('#B')

      annotation_b_relations = annotation_b.relations.filter (relation)=>
        relation.type == 'annotation-domain-class'
      class_a_relations = class_a.relations.filter (relation)=>
        relation.type == 'annotation-domain-class'
      class_b_relations = class_b.relations.filter (relation)=>
        relation.type == 'annotation-domain-class'

      class_a_relation = class_a_relations[0]
      class_b_relation = class_b_relations[0]

      expect(annotation_b_relations[0]).to.eql(class_a_relation)
      expect(class_a_relation.class).to.eql(class_a)
      expect(class_a_relation.annotation).to.eql(annotation_b)

      expect(annotation_b_relations[1]).to.eql(class_b_relation)
      expect(class_b_relation.class).to.eql(class_b)
      expect(class_b_relation.annotation).to.eql(annotation_b)

  describe "annotation2.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/annotation2.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "ontology.annotations", ->
      iris = ontology.annotations.map (annotation)->
        annotation.iri
      expect(['rdfs:comment','owl:deprecated','owl:backwardCompatibleWith']).to.eql(iris)
      names = ontology.annotations.map (annotation)->
        annotation.name
      expect(['comment','deprecated','backwardCompatibleWith']).to.eql(names)

    it "annotation_values", ->
      individual = owl_parser.get_model_by_iri('#a')
      clazz      = owl_parser.get_model_by_iri('owl:Thing')
      annotation_c = owl_parser.get_model_by_iri('rdfs:comment')
      annotation_b = owl_parser.get_model_by_iri('owl:backwardCompatibleWith')


      #
      individual_relations = individual.relations.filter (clazz)=>
        clazz.type == "annotation-value"
      
      individual_relation = individual_relations[0]
      expect(individual_relation.host).to.eql(individual)
      expect(individual_relation.annotation).to.eql(annotation_c)
      expect(individual_relation.data_type).to.eql(owl_parser.get_model_by_iri('xsd:dateTime'))
      #

      #
      clazz_relations = clazz.relations.filter (clazz)=>
        clazz.type == "annotation-value"
      
      clazz_relation = clazz_relations[0]
      expect(clazz_relation.host).to.eql(clazz)
      expect(clazz_relation.annotation).to.eql(annotation_c)
      expect(clazz_relation.data_type).to.eql(owl_parser.get_model_by_iri('rdf:PlainLiteral'))
      #
      #
      annotation_b_relations = annotation_b.relations.filter (clazz)=>
        clazz.type == "annotation-value"
      
      annotation_b_relation = annotation_b_relations[0]
      expect(annotation_b_relation.host).to.eql(annotation_b)
      expect(annotation_b_relation.annotation).to.eql(annotation_c)
      expect(annotation_b_relation.data_type).to.eql(owl_parser.get_model_by_iri('xsd:dateTime'))
      #

    it "annotation-parent-sub", ->
      an_c = owl_parser.get_model_by_iri("rdfs:comment")
      an_d = owl_parser.get_model_by_iri("owl:deprecated")

      an_c_relations = an_c.relations.filter (relation)=>
        relation.type == 'annotation-parent-sub'
      an_d_relations = an_d.relations.filter (relation)=>
        relation.type == 'annotation-parent-sub'

      an_c_relation = an_c_relations[0]
      an_d_relation = an_d_relations[0]

      expect(an_c_relation).to.eql(an_d_relation)
      expect(an_c_relation.parent).to.eql(an_d)
      expect(an_c_relation.sub).to.eql(an_c)

    it "annotation-range-class", ->
      an_c = owl_parser.get_model_by_iri("rdfs:comment")
      clazz = owl_parser.get_model_by_iri("owl:Thing")

      an_c_relations = an_c.relations.filter (relation)=>
        relation.type == 'annotation-range-class'
      clazz_relations = clazz.relations.filter (relation)=>
        relation.type == 'annotation-range-class'      

      an_c_relation = an_c_relations[0]
      clazz_relation = clazz_relations[0]

      expect(an_c_relation).to.eql(clazz_relation)
      expect(an_c_relation.class).to.eql(clazz)
      expect(an_c_relation.annotation).to.eql(an_c)

    it "annotation-domain-class", ->
      an_c = owl_parser.get_model_by_iri("rdfs:comment")
      clazz = owl_parser.get_model_by_iri("owl:Thing")

      an_c_relations = an_c.relations.filter (relation)=>
        relation.type == 'annotation-domain-class'  
      clazz_relations = clazz.relations.filter (relation)=>
        relation.type == 'annotation-domain-class'  

      an_c_relation = an_c_relations[0]
      clazz_relation = clazz_relations[0]

      expect(an_c_relation).to.eql(clazz_relation)
      expect(an_c_relation.class).to.eql(clazz)
      expect(an_c_relation.annotation).to.eql(an_c)

  describe "annotation3.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/annotation3.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "annotation_values", ->
      individual = owl_parser.get_model_by_iri('#a')

      clazz      = owl_parser.get_model_by_iri('owl:Thing')
      model_l = owl_parser.get_model_by_iri('rdfs:label')
      model_d = owl_parser.get_model_by_iri('xsd:dateTimeStamp')
      model_td = owl_parser.get_model_by_iri('owl:topDataProperty')
      model_to = owl_parser.get_model_by_iri('owl:topObjectProperty')
      annotation_c = owl_parser.get_model_by_iri('rdfs:comment')


      #
      model_l_relations = model_l.relations.filter (clazz)=>
        clazz.type == "annotation-value"
      
      model_l_relation = model_l_relations[0]
      expect(model_l_relation.host).to.eql(model_l)
      expect(model_l_relation.annotation).to.eql(annotation_c)
      expect(model_l_relation.data_type).to.eql(owl_parser.get_model_by_iri('xsd:dateTime'))
      #

      #
      model_d_relations = model_d.relations.filter (clazz)=>
        clazz.type == "annotation-value"
      
      model_d_relation = model_d_relations[0]
      expect(model_d_relation.host).to.eql(model_d)
      expect(model_d_relation.annotation).to.eql(annotation_c)
      expect(model_d_relation.data_type).to.eql(owl_parser.get_model_by_iri('xsd:boolean'))
      #

      #
      clazz_relations = clazz.relations.filter (clazz)=>
        clazz.type == "annotation-value"
      
      clazz_relation = clazz_relations[0]
      expect(clazz_relation.host).to.eql(clazz)
      expect(clazz_relation.annotation).to.eql(annotation_c)
      expect(clazz_relation.data_type).to.eql(owl_parser.get_model_by_iri('rdf:PlainLiteral'))
      #

      #
      model_td_relations = model_td.relations.filter (clazz)=>
        clazz.type == "annotation-value"
      
      model_td_relation = model_td_relations[0]
      expect(model_td_relation.host).to.eql(model_td)
      expect(model_td_relation.annotation).to.eql(annotation_c)
      expect(model_td_relation.data_type).to.eql(owl_parser.get_model_by_iri('rdf:PlainLiteral'))
      #

      #
      model_to_relations = model_to.relations.filter (clazz)=>
        clazz.type == "annotation-value"
      
      model_to_relation = model_to_relations[0]
      expect(model_to_relation.host).to.eql(model_to)
      expect(model_to_relation.annotation).to.eql(annotation_c)
      expect(model_to_relation.data_type).to.eql(owl_parser.get_model_by_iri('rdf:PlainLiteral'))
      #
