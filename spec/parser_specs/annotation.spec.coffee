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

    it "annotation.sub_annotations", ->
      annotation_a = owl_parser.get_model_by_iri('#a')
      annotation_aa = owl_parser.get_model_by_iri('#aa')
      annotation_ab = owl_parser.get_model_by_iri('#ab')
      expect(annotation_a.sub_annotations).to.eql([annotation_aa, annotation_ab])

    it "annotation.parent_annotations", ->
      annotation_a = owl_parser.get_model_by_iri('#a')
      annotation_aa = owl_parser.get_model_by_iri('#aa')
      annotation_ab = owl_parser.get_model_by_iri('#ab')
      expect(annotation_aa.parent_annotations).to.eql([annotation_a])
      expect(annotation_ab.parent_annotations).to.eql([annotation_a])

    it "annotation.range_things", ->
      annotation_b = owl_parser.get_model_by_iri('#b')
      thing_c = owl_parser.get_model_by_iri('#C')
      thing_d = owl_parser.get_model_by_iri('#D')
      expect(annotation_b.range_things).to.eql([thing_c, thing_d])
      
    it "annotation.domain_things", ->
      annotation_b = owl_parser.get_model_by_iri('#b')
      thing_a = owl_parser.get_model_by_iri('#A')
      thing_b = owl_parser.get_model_by_iri('#B')
      expect(annotation_b.domain_things).to.eql([thing_a, thing_b])

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
      thing      = owl_parser.get_model_by_iri('owl:Thing')
      annotation_c = owl_parser.get_model_by_iri('rdfs:comment')
      annotation_b = owl_parser.get_model_by_iri('owl:backwardCompatibleWith')

      expect(individual.annotation_values).to.have.length(1)
      av = individual.annotation_values[0]
      expect(av.annotation).to.eql(annotation_c)
      expect(av.data_type_value.data_type).to.eql(owl_parser.get_model_by_iri('xsd:dateTime'))

      expect(thing.annotation_values).to.have.length(1)
      av = thing.annotation_values[0]
      expect(av.annotation).to.eql(annotation_c)
      expect(av.data_type_value.data_type).to.eql(owl_parser.get_model_by_iri('rdf:PlainLiteral'))

      expect(annotation_b.annotation_values).to.have.length(1)
      av = annotation_b.annotation_values[0]
      expect(av.annotation).to.eql(annotation_c)
      expect(av.data_type_value.data_type).to.eql(owl_parser.get_model_by_iri('xsd:dateTime'))

    it "annotation.sub_annotations", ->
      an_c = owl_parser.get_model_by_iri("rdfs:comment")
      an_d = owl_parser.get_model_by_iri("owl:deprecated")
      expect(an_d.sub_annotations).to.eql([an_c])
      expect(an_c.parent_annotations).to.eql([an_d])
      
    it "annotation.range_things", ->
      an_c = owl_parser.get_model_by_iri("rdfs:comment")
      thing = owl_parser.get_model_by_iri("owl:Thing")
      expect(an_c.range_things).to.eql([thing])

    it "annotation.domain_things", ->
      an_c = owl_parser.get_model_by_iri("rdfs:comment")
      thing = owl_parser.get_model_by_iri("owl:Thing")
      expect(an_c.domain_things).to.eql([thing])
      

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

      thing      = owl_parser.get_model_by_iri('owl:Thing')
      model_l = owl_parser.get_model_by_iri('rdfs:label')
      model_d = owl_parser.get_model_by_iri('xsd:dateTimeStamp')
      model_td = owl_parser.get_model_by_iri('owl:topDataProperty')
      model_to = owl_parser.get_model_by_iri('owl:topObjectProperty')
      annotation_c = owl_parser.get_model_by_iri('rdfs:comment')

      expect(model_l.annotation_values).to.have.length(1)
      av = model_l.annotation_values[0]
      expect(av.annotation).to.eql(annotation_c)
      expect(av.data_type_value.data_type).to.eql(owl_parser.get_model_by_iri('xsd:dateTime'))

      expect(model_d.annotation_values).to.have.length(1)
      av = model_d.annotation_values[0]
      expect(av.annotation).to.eql(annotation_c)
      expect(av.data_type_value.data_type).to.eql(owl_parser.get_model_by_iri('xsd:boolean'))

      expect(thing.annotation_values).to.have.length(1)
      av = thing.annotation_values[0]
      expect(av.annotation).to.eql(annotation_c)
      expect(av.data_type_value.data_type).to.eql(owl_parser.get_model_by_iri('rdf:PlainLiteral'))

      expect(model_td.annotation_values).to.have.length(1)
      av = model_td.annotation_values[0]
      expect(av.annotation).to.eql(annotation_c)
      expect(av.data_type_value.data_type).to.eql(owl_parser.get_model_by_iri('rdf:PlainLiteral'))

      expect(model_to.annotation_values).to.have.length(1)
      av = model_to.annotation_values[0]
      expect(av.annotation).to.eql(annotation_c)
      expect(av.data_type_value.data_type).to.eql(owl_parser.get_model_by_iri('rdf:PlainLiteral'))
