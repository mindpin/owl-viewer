describe "annotation value parser", ->
  describe "annotation_value.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/annotation_value.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "annotation_values", ->
      ano     = owl_parser.get_model_by_iri("#aname")
      thing_a = owl_parser.get_model_by_iri("#A")
      dt      = owl_parser.get_model_by_iri("#dt")
      expect(thing_a.annotation_values).to.length(1)
      av = thing_a.annotation_values[0]
      expect(av.annotation).to.eql(ano)
      expect(av.data_type_value.data_type).to.eql(dt)
      expect(av.data_type_value.value).to.eql("1")

      individual_a = owl_parser.get_model_by_iri("#a")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")
      expect(individual_a.annotation_values).to.length(1)
      av = individual_a.annotation_values[0]
      expect(av.annotation).to.eql(ano)
      expect(av.data_type_value.data_type).to.eql(dt)
      expect(av.data_type_value.value).to.eql("2")
    
      annotation = owl_parser.get_model_by_iri("#anno")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")
      expect(annotation.annotation_values).to.length(1)
      av = annotation.annotation_values[0]
      expect(av.annotation).to.eql(ano)
      expect(av.data_type_value.data_type).to.eql(dt)
      expect(av.data_type_value.value).to.eql("3")

      dp = owl_parser.get_model_by_iri("#dp")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")
      expect(dp.annotation_values).to.length(1)
      av = dp.annotation_values[0]
      expect(av.annotation).to.eql(ano)
      expect(av.data_type_value.data_type).to.eql(dt)
      expect(av.data_type_value.value).to.eql("5")

      data_type = owl_parser.get_model_by_iri("#dt")
      dt = owl_parser.get_model_by_iri("xsd:boolean")
      expect(data_type.annotation_values).to.length(1)
      av = data_type.annotation_values[0]
      expect(av.annotation).to.eql(ano)
      expect(av.data_type_value.data_type).to.eql(dt)
      expect(av.data_type_value.value).to.eql("false")

      op = owl_parser.get_model_by_iri("#op")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")
      expect(op.annotation_values).to.length(1)
      av = op.annotation_values[0]
      expect(av.annotation).to.eql(ano)
      expect(av.data_type_value.data_type).to.eql(dt)
      expect(av.data_type_value.value).to.eql("4")

      data_type = owl_parser.get_model_by_iri("xsd:dateTimeStamp")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")
      expect(data_type.annotation_values).to.length(1)
      av = data_type.annotation_values[0]
      expect(av.annotation).to.eql(ano)
      expect(av.data_type_value.data_type).to.eql(dt)
      expect(av.data_type_value.value).to.eql("")

