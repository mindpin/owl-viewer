describe "property value parser", ->
  describe "property_value.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/property_value.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()

    it "object_property_values", ->
      opa = owl_parser.get_model_by_iri("#opa")
      a = owl_parser.get_model_by_iri("#a")
      b = owl_parser.get_model_by_iri("#b")
      expect(a.object_property_values).to.have.length(1)
      opv = a.object_property_values[0]
      expect(opv.object_property).to.eql(opa)
      expect(opv.individual).to.eql(b)
      
    it "data_property_values", ->
      dpa = owl_parser.get_model_by_iri("#dpa")
      a = owl_parser.get_model_by_iri("#a")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")
      expect(a.data_property_values).to.have.length(1)
      dpv = a.data_property_values[0]
      expect(dpv.data_property).to.eql(dpa)
      expect(dpv.data_type_value.data_type).to.eql(dt)

    it "object_properties data_properties", ->
      a   = owl_parser.get_model_by_iri("#A")
      opa = owl_parser.get_model_by_iri("#opa")
      dpa = owl_parser.get_model_by_iri("#dpa")
      expect(a.object_properties).to.eql([opa])
      expect(a.data_properties).to.eql([dpa])
