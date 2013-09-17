describe "data_property parser", ->
  describe "data_property.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/data_property.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "ontology.data_properties", ->
      iris = ontology.data_properties.map (dp)->
        dp.iri
      expect(["#dpa", "#dpb", "#dpc", "#dpd", "#dpe"]).to.eql(iris)
      names = ontology.data_properties.map (dp)->
        dp.name
      expect(["dpa", "dpb", "dpc", "dpd", "dpe"]).to.eql(names)

    it "data_property.equivalence_data_properties", ->
      dpa = owl_parser.get_model_by_iri("#dpa")
      dpb = owl_parser.get_model_by_iri("#dpb")
      expect(dpa.equivalence_data_properties).to.eql([dpb])
      expect(dpb.equivalence_data_properties).to.eql([dpa])

    it "data_property.sub_data_properties", ->
      dpa = owl_parser.get_model_by_iri("#dpa")
      dpc = owl_parser.get_model_by_iri("#dpc")
      expect(dpa.sub_data_properties).to.eql([dpc])
      expect(dpc.parent_data_properties).to.eql([dpa])

    it "data_property.characteristics", ->
      dpe = owl_parser.get_model_by_iri("#dpe")
      expect(dpe.characteristics).to.eql([OntologyCharacteristic.FUNCTIONAL])

    it "data_property.domain_things", ->
      dpa = owl_parser.get_model_by_iri("#dpa")
      thing = owl_parser.get_model_by_iri("#A")
      expect(dpa.domain_things).to.eql([thing])

    it "range_data_types", ->
      dpe = owl_parser.get_model_by_iri("#dpe")
      data_type_boo  = owl_parser.get_model_by_iri("xsd:boolean")
      data_type_byte = owl_parser.get_model_by_iri("xsd:byte")
      expect(dpe.range_data_types).to.have.length(2)
      iris = dpe.range_data_types.map (data_type)->
        data_type.iri
      names = dpe.range_data_types.map (data_type)->
        data_type.name
      expect(iris).to.eql(['xsd:boolean','xsd:byte'])
      expect(names).to.eql(['boolean','byte'])

    it "disjoint_data_properties", ->
      dpd = owl_parser.get_model_by_iri("#dpd")
      dpe = owl_parser.get_model_by_iri("#dpe")
      expect(dpd.disjoint_data_properties).to.eql([dpe])
      expect(dpe.disjoint_data_properties).to.eql([dpd])

  describe "data_property2.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/data_property2.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "data_property_values", ->
      dp = owl_parser.get_model_by_iri('owl:topDataProperty')
      individual = owl_parser.get_model_by_iri('#a')
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")

      expect(individual.data_property_values).to.have.length(1)
      dpv = individual.data_property_values[0]
      expect(dpv.data_property).to.eql(dp)
      expect(dpv.data_type_value.data_type).to.eql(dt)
    
    it "equivalence_data_properties", ->
      opa = owl_parser.get_model_by_iri('#opa')
      dp  = owl_parser.get_model_by_iri('owl:topDataProperty')
      expect(opa.equivalence_data_properties).to.eql([dp])
      expect(dp.equivalence_data_properties).to.eql([opa])
      
    it "sub_data_properties", ->
      tdp = owl_parser.get_model_by_iri("owl:topDataProperty")
      opb = owl_parser.get_model_by_iri("#opb")
      expect(opb.sub_data_properties).to.eql([tdp])
      expect(tdp.parent_data_properties).to.eql([opb])
    
    it "domain_things", ->
      tdp = owl_parser.get_model_by_iri("owl:topDataProperty")
      thing = owl_parser.get_model_by_iri("owl:Thing")
      expect(tdp.domain_things).to.eql([thing])
      
    it "range_data_types", ->
      tdp = owl_parser.get_model_by_iri("owl:topDataProperty")
      dt = owl_parser.get_model_by_iri("xsd:anyURI")
      expect(tdp.range_data_types).to.eql([dt])

    it "disjoint_data_properties", ->
      opc = owl_parser.get_model_by_iri("#opc")
      tdp = owl_parser.get_model_by_iri("owl:topDataProperty")
      expect(opc.disjoint_data_properties).to.eql([tdp])
      expect(tdp.disjoint_data_properties).to.eql([opc])

    it "thing.data_properties", ->
      thing = owl_parser.get_model_by_iri("owl:Thing")
      tdp = owl_parser.get_model_by_iri("owl:topDataProperty")
      expect(thing.data_properties).to.eql([tdp])
      
      