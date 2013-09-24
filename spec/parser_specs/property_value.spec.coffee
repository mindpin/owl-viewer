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

    it "object-property-value", ->
      opa = owl_parser.get_model_by_iri("#opa")
      a = owl_parser.get_model_by_iri("#a")
      b = owl_parser.get_model_by_iri("#b")

      relations = a.relations.filter (relation)->
        relation.type == "object-property-value"

      relation = relations[0]

      expect(relation.host).to.eql(a)
      expect(relation.value).to.eql(b)
      expect(relation.object_property).to.eql(opa)

    it "data-property-value", ->
      dpa = owl_parser.get_model_by_iri("#dpa")
      a = owl_parser.get_model_by_iri("#a")
      dt = owl_parser.get_model_by_iri("rdf:PlainLiteral")

      relations = a.relations.filter (relation) ->
        relation.type == "data-property-value"

      relation = relations[0]

      expect(relation.host).to.eql(a)
      expect(relation.data_property).to.eql(dpa)
      expect(relation.data_type).to.eql(dt)

    it "object_properties data_properties", ->
      a   = owl_parser.get_model_by_iri("#A")
      opa = owl_parser.get_model_by_iri("#opa")
      dpa = owl_parser.get_model_by_iri("#dpa")
      expect(a.object_properties).to.eql([opa])
      expect(a.data_properties).to.eql([dpa])
