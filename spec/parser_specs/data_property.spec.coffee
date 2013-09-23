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

    it "data-property-equivalent", ->
      dpa = owl_parser.get_model_by_iri("#dpa")
      dpb = owl_parser.get_model_by_iri("#dpb")

      dpa_relations = dpa.relations.filter (dp)=>
        dp.type == "data-property-equivalent"
      dpb_relations = dpb.relations.filter (dp)=>
        dp.type == "data-property-equivalent"

      dpa_relation = dpa_relations[0]
      dpb_relation = dpb_relations[0]

      expect(dpa_relation).to.eql(dpb_relation)
      expect(dpa_relation.data_properties).to.eql([dpa, dpb])

    it "data-property-parent-sub", ->
      dpa = owl_parser.get_model_by_iri("#dpa")
      dpc = owl_parser.get_model_by_iri("#dpc")

      dpa_relations = dpa.relations.filter (dp)=>
        dp.type == "data-property-parent-sub"
      dpc_relations = dpc.relations.filter (dp)=>
        dp.type == "data-property-parent-sub"

      dpa_relation = dpa_relations[0]
      dpc_relation = dpc_relations[0]

      expect(dpa_relation).to.eql(dpc_relation)
      expect(dpa_relation.parent).to.eql(dpa)
      expect(dpa_relation.sub).to.eql(dpc)

    it "data_property.characteristics", ->
      dpe = owl_parser.get_model_by_iri("#dpe")
      expect(dpe.characteristics).to.eql([OntologyCharacteristic.FUNCTIONAL])

    it "data-property-domain-class", ->
      dpa = owl_parser.get_model_by_iri("#dpa")
      clazz = owl_parser.get_model_by_iri("#A")

      dpa_relations = dpa.relations.filter (dp)=>
        dp.type == "data-property-domain-class"
      clazz_relations = clazz.relations.filter (dp)=>
        dp.type == "data-property-domain-class"

      dpa_relation = dpa_relations[0]
      clazz_relation = clazz_relations[0]

      expect(dpa_relation).to.eql(clazz_relation)
      expect(dpa_relation.data_property).to.eql(dpa)
      expect(dpa_relation.class).to.eql(clazz)

    it "data-property-range-data-type", ->
      dpe = owl_parser.get_model_by_iri("#dpe")
      data_type_boo  = owl_parser.get_model_by_iri("xsd:boolean")
      data_type_byte = owl_parser.get_model_by_iri("xsd:byte")

      dpe_relations = dpe.relations.filter (dp)=>
        dp.type == "data-property-range-data-type"
      boo_relations = data_type_boo.relations.filter (dp)=>
        dp.type == "data-property-range-data-type"
      byte_relations = data_type_byte.relations.filter (dp)=>
        dp.type == "data-property-range-data-type"

      boo_relation = boo_relations[0]
      byte_relation = byte_relations[0]

      expect(dpe_relations[0]).to.eql(boo_relation)
      expect(boo_relation.data_property).to.eql(dpe)
      expect(boo_relation.data_type).to.eql(data_type_boo)
      
      expect(dpe_relations[1]).to.eql(byte_relation)
      expect(byte_relation.data_property).to.eql(dpe)
      expect(byte_relation.data_type).to.eql(data_type_byte)
      
      expect(data_type_boo.name).to.eql("boolean")
      expect(data_type_byte.name).to.eql("byte")

    it "data-property-disjoint", ->
      dpd = owl_parser.get_model_by_iri("#dpd")
      dpe = owl_parser.get_model_by_iri("#dpe")

      dpd_relations = dpd.relations.filter (dp)=>
        dp.type == "data-property-disjoint"
      dpe_relations = dpe.relations.filter (dp)=>
        dp.type == "data-property-disjoint"

      dpd_relation = dpd_relations[0]
      dpe_relation = dpe_relations[0]

      expect(dpd_relation).to.eql(dpe_relation)
      expect(dpd_relation.data_properties).to.eql([dpd, dpe])

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
    
    it "data-property-equivalent", ->
      opa = owl_parser.get_model_by_iri('#opa')
      dp  = owl_parser.get_model_by_iri('owl:topDataProperty')

      opa_relations = opa.relations.filter (dp)=>
        dp.type == "data-property-equivalent"
      dp_relations = dp.relations.filter (dp)=>
        dp.type == "data-property-equivalent"

      opa_relation = opa_relations[0]
      dp_relation = dp_relations[0]

      expect(opa_relation).to.eql(dp_relation)
      expect(opa_relation.data_properties).to.eql([opa, dp])

    it "data-property-parent-sub", ->
      tdp = owl_parser.get_model_by_iri("owl:topDataProperty")
      opb = owl_parser.get_model_by_iri("#opb")

      tdp_relations = tdp.relations.filter (dp)=>
        dp.type == "data-property-parent-sub"
      opb_relations = opb.relations.filter (dp)=>
        dp.type == "data-property-parent-sub"

      tdp_relation = tdp_relations[0]
      opb_relation = opb_relations[0]

      expect(tdp_relation).to.eql(opb_relation)
      expect(tdp_relation.parent).to.eql(opb)
      expect(tdp_relation.sub).to.eql(tdp)
    
    it "data-property-domain-class", ->
      tdp = owl_parser.get_model_by_iri("owl:topDataProperty")
      clazz = owl_parser.get_model_by_iri("owl:Thing")

      tdp_relations = tdp.relations.filter (dp)=>
        dp.type == "data-property-domain-class"
      clazz_relations = clazz.relations.filter (dp)=>
        dp.type == "data-property-domain-class"

      tdp_relation = tdp_relations[0]
      clazz_relation = clazz_relations[0]

      expect(tdp_relation).to.eql(clazz_relation)
      expect(tdp_relation.data_property).to.eql(tdp)
      expect(tdp_relation.class).to.eql(clazz)
      
    it "data-property-range-data-type", ->
      tdp = owl_parser.get_model_by_iri("owl:topDataProperty")
      dt = owl_parser.get_model_by_iri("xsd:anyURI")

      tdp_relations = tdp.relations.filter (dp)=>
        dp.type == "data-property-range-data-type"
      dt_relations = dt.relations.filter (dp)=>
        dp.type == "data-property-range-data-type"

      tdp_relation = tdp_relations[0]
      dt_relation = dt_relations[0]

      expect(tdp_relation).to.eql(dt_relation)
      expect(tdp_relation.data_property).to.eql(tdp)
      expect(tdp_relation.data_type).to.eql(dt)

    it "data-property-disjoint", ->
      opc = owl_parser.get_model_by_iri("#opc")
      tdp = owl_parser.get_model_by_iri("owl:topDataProperty")

      opc_relations = opc.relations.filter (dp)=>
        dp.type == "data-property-disjoint"
      tdp_relations = tdp.relations.filter (dp)=>
        dp.type == "data-property-disjoint"

      opc_relation = opc_relations[0]
      tdp_relation = tdp_relations[0]

      expect(opc_relation).to.eql(tdp_relation)
      expect(opc_relation.data_properties).to.eql([opc, tdp])

    it "class.data_properties", ->
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      tdp = owl_parser.get_model_by_iri("owl:topDataProperty")
      expect(clazz.data_properties).to.eql([tdp])
      
      