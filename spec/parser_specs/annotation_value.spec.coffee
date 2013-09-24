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

    it "annotation-value", ->
      ano     = owl_parser.get_model_by_iri("#aname")
      class_a = owl_parser.get_model_by_iri("#A")
      dt      = owl_parser.get_model_by_iri("#dt")
      
      class_a_relations = class_a.relations.filter (clazz)=>
        clazz.type == "annotation-value"
      
      class_a_relation = class_a_relations[0]
      expect(class_a_relation.host).to.eql(class_a)
      expect(class_a_relation.annotation).to.eql(ano)
      expect(class_a_relation.data_type).to.eql(dt)
      expect(class_a_relation.value).to.eql("1")
      ##
 
      individual_a = owl_parser.get_model_by_iri("#a")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")

      individual_a_relations = individual_a.relations.filter (clazz)=>
        clazz.type == "annotation-value"
      
      individual_a_relation = individual_a_relations[0]
      expect(individual_a_relation.host).to.eql(individual_a)
      expect(individual_a_relation.annotation).to.eql(ano)
      expect(individual_a_relation.data_type).to.eql(dt)
      expect(individual_a_relation.value).to.eql("2")


      annotation = owl_parser.get_model_by_iri("#anno")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")

      annotation_relations = annotation.relations.filter (annotation)=>
        annotation.type == "annotation-value"
      
      annotation_relation = annotation_relations[0]
      expect(annotation_relation.host).to.eql(annotation)
      expect(annotation_relation.annotation).to.eql(ano)
      expect(annotation_relation.data_type).to.eql(dt)
      expect(annotation_relation.value).to.eql("3")


      dp = owl_parser.get_model_by_iri("#dp")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")
      #
      dp_relations = dp.relations.filter (d)=>
        d.type == "annotation-value"
      
      dp_relation = dp_relations[0]
      expect(dp_relation.host).to.eql(dp)
      expect(dp_relation.annotation).to.eql(ano)
      expect(dp_relation.data_type).to.eql(dt)
      expect(dp_relation.value).to.eql("5")
      #

      data_type = owl_parser.get_model_by_iri("#dt")
      dt = owl_parser.get_model_by_iri("xsd:boolean")
      #
      data_type_relations = data_type.relations.filter (d)=>
        d.type == "annotation-value"
      
      data_type_relation = data_type_relations[0]
      expect(data_type_relation.host).to.eql(data_type)
      expect(data_type_relation.annotation).to.eql(ano)
      expect(data_type_relation.data_type).to.eql(dt)
      expect(data_type_relation.value).to.eql("false")
      #
      op = owl_parser.get_model_by_iri("#op")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")
      #
      op_relations = op.relations.filter (d)=>
        d.type == "annotation-value"
      
      op_relation = op_relations[0]
      expect(op_relation.host).to.eql(op)
      expect(op_relation.annotation).to.eql(ano)
      expect(op_relation.data_type).to.eql(dt)
      expect(op_relation.value).to.eql("4")
      #
      data_type = owl_parser.get_model_by_iri("xsd:dateTimeStamp")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")
      #
      data_type_relations = data_type.relations.filter (d)=>
        d.type == "annotation-value"
      
      data_type_relation = data_type_relations[0]
      expect(data_type_relation.host).to.eql(data_type)
      expect(data_type_relation.annotation).to.eql(ano)
      expect(data_type_relation.data_type).to.eql(dt)
      expect(data_type_relation.value).to.eql("")
      #

