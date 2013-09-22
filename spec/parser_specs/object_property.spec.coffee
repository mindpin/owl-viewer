describe "object_property parser", ->
  describe "object_property.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/object_property.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "ontology.object_properties", ->
      iris = ontology.object_properties.map (op)->
        op.iri
      expect(["#OPA", "#OPB", "#OPC", "#OPD", "#OPE"]).to.eql(iris)
      names = ontology.object_properties.map (op)->
        op.name
      expect(["OPA", "OPB", "OPC", "OPD", "OPE"]).to.eql(names)

    it "ontology.classes", ->
      iris = ontology.classes.map (clazz)->
        clazz.iri
      expect(["#A", "#B"]).to.eql(iris)
      names = ontology.classes.map (clazz)->
        clazz.name
      expect(["A", "B"]).to.eql(names)

    it "equivalence_object_properties", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      opb = owl_parser.get_model_by_iri("#OPB")
      expect(opa.equivalence_object_properties).to.eql([opb])
      expect(opb.equivalence_object_properties).to.eql([opa])

    it "sub_object_properties", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      opc = owl_parser.get_model_by_iri("#OPC")
      expect(opc.sub_object_properties).to.eql([opa])
      expect(opa.parent_object_properties).to.eql([opc])

    it "inverse_object_properties", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      opd = owl_parser.get_model_by_iri("#OPD")
      expect(opd.inverse_object_properties).to.eql([opa])
      expect(opa.inverse_object_properties).to.eql([opd])

    it "domain_classes", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      a = owl_parser.get_model_by_iri("#A")
      expect(opa.domain_classes).to.eql([a])

    it "range_classes", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      b = owl_parser.get_model_by_iri("#B")
      expect(opa.range_classes).to.eql([b])

    it "disjoint_object_properties", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      ope = owl_parser.get_model_by_iri("#OPE")
      expect(opa.disjoint_object_properties).to.eql([ope])
      expect(ope.disjoint_object_properties).to.eql([opa])

    it "characteristics", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      cs = [
        OntologyCharacteristic.FUNCTIONAL,
        OntologyCharacteristic.INVERSE_FUNCTIONAL,
        OntologyCharacteristic.SYMMETRIC,
        OntologyCharacteristic.ASYMMETRIC,
        OntologyCharacteristic.TRANSITIVE,
        OntologyCharacteristic.REFLEXIVE,
        OntologyCharacteristic.IRREFLEXIVE
      ]
      expect(opa.characteristics).to.eql(cs)


  describe "object_property2.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/object_property2.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "object_property_value", ->
      top          = owl_parser.get_model_by_iri("owl:topObjectProperty")
      individual_a = owl_parser.get_model_by_iri("#a")

      expect(individual_a.object_property_values).to.have.length(1)
      opv = individual_a.object_property_values[0]
      expect(opv.object_property).to.eql(top)
      expect(opv.individual).to.eql(individual_a)
      
    it "equivalence_object_properties", ->
      opa = owl_parser.get_model_by_iri("#opa")
      top = owl_parser.get_model_by_iri("owl:topObjectProperty")
      expect(opa.equivalence_object_properties).to.eql([top])
      expect(top.equivalence_object_properties).to.eql([opa])

    it "sub_object_properties", ->
      top = owl_parser.get_model_by_iri("owl:topObjectProperty")
      opb = owl_parser.get_model_by_iri("#opb")
      expect(opb.sub_object_properties).to.eql([top])
      expect(top.parent_object_properties).to.eql([opb])

    it "inverse_object_properties", ->
      top = owl_parser.get_model_by_iri("owl:topObjectProperty")
      opb = owl_parser.get_model_by_iri("#opc")
      expect(opb.inverse_object_properties).to.eql([top])
      expect(top.inverse_object_properties).to.eql([opb])

    it "domain_classes", ->
      top   = owl_parser.get_model_by_iri("owl:topObjectProperty")
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      expect(top.domain_classes).to.eql([clazz])
      
    it "range_classes", ->
      top   = owl_parser.get_model_by_iri("owl:topObjectProperty")
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      expect(top.range_classes).to.eql([clazz])

    it "disjoint_object_properties", ->
      top   = owl_parser.get_model_by_iri("owl:topObjectProperty")
      opd = owl_parser.get_model_by_iri("#opd")
      expect(top.disjoint_object_properties).to.eql([opd])
      expect(opd.disjoint_object_properties).to.eql([top])

    it "class.object_properties", ->
      top   = owl_parser.get_model_by_iri("owl:topObjectProperty")
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      expect(clazz.object_properties).to.eql([top])
