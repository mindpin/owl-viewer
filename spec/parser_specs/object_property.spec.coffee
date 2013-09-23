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

    it "object-property-equivalent", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      opb = owl_parser.get_model_by_iri("#OPB")

      a_relations = opa.relations.filter (op)=>
        op.type == "object-property-equivalent"
      b_relations = opb.relations.filter (op)=>
        op.type == "object-property-equivalent"

      a_relation = a_relations[0]
      b_relation = b_relations[0]

      expect(a_relation).to.eql(b_relation)
      expect(a_relation.object_properties).to.eql([opa, opb])

    it "object-property-parent-sub", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      opc = owl_parser.get_model_by_iri("#OPC")

      a_relations = opa.relations.filter (op)=>
        op.type == "object-property-parent-sub"
      c_relations = opc.relations.filter (op)=>
        op.type == "object-property-parent-sub"

      a_relation = a_relations[0]
      c_relation = c_relations[0]

      expect(a_relation).to.eql(c_relation)
      expect(a_relation.parent).to.eql(opc)
      expect(a_relation.sub).to.eql(opa)

    it "object-property-inverse", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      opd = owl_parser.get_model_by_iri("#OPD")

      a_relations = opa.relations.filter (op)=>
        op.type == "object-property-inverse"
      d_relations = opd.relations.filter (op)=>
        op.type == "object-property-inverse"

      a_relation = a_relations[0]
      d_relation = d_relations[0]

      expect(a_relation).to.eql(d_relation)
      expect(a_relation.object_properties).to.eql([opa, opd])

    it "object-property-domain-class", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      a = owl_parser.get_model_by_iri("#A")

      opa_relations = opa.relations.filter (op)=>
        op.type == "object-property-domain-class"
      a_relations = a.relations.filter (op)=>
        op.type == "object-property-domain-class"

      opa_relation = opa_relations[0]
      a_relation = a_relations[0]

      expect(opa_relation).to.eql(a_relation)
      expect(opa_relation.object_property).to.eql(opa)
      expect(opa_relation.class).to.eql(a)

    it "object-property-range-class", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      b = owl_parser.get_model_by_iri("#B")

      opa_relations = opa.relations.filter (op)=>
        op.type == "object-property-range-class"
      b_relations = b.relations.filter (op)=>
        op.type == "object-property-range-class"

      opa_relation = opa_relations[0]
      b_relation = b_relations[0]

      expect(opa_relation).to.eql(b_relation)
      expect(opa_relation.object_property).to.eql(opa)
      expect(opa_relation.class).to.eql(b)

    it "object-property-disjoint", ->
      opa = owl_parser.get_model_by_iri("#OPA")
      ope = owl_parser.get_model_by_iri("#OPE")

      opa_relations = opa.relations.filter (op)=>
        op.type == "object-property-disjoint"
      ope_relations = ope.relations.filter (op)=>
        op.type == "object-property-disjoint"

      opa_relation = opa_relations[0]
      ope_relation = ope_relations[0]

      expect(opa_relation).to.eql(ope_relation)
      expect(opa_relation.object_properties).to.eql([opa, ope])

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
      
    it "object-property-equivalent", ->
      opa = owl_parser.get_model_by_iri("#opa")
      top = owl_parser.get_model_by_iri("owl:topObjectProperty")

      opa_relations = opa.relations.filter (op)=>
        op.type == "object-property-equivalent"
      top_relations = top.relations.filter (op)=>
        op.type == "object-property-equivalent"

      opa_relation = opa_relations[0]
      top_relation = top_relations[0]

      expect(opa_relation).to.eql(top_relation)
      expect(opa_relation.object_properties).to.eql([opa, top])

    it "object-property-parent-sub", ->
      top = owl_parser.get_model_by_iri("owl:topObjectProperty")
      opb = owl_parser.get_model_by_iri("#opb")

      top_relations = top.relations.filter (op)=>
        op.type == "object-property-parent-sub"
      opb_relations = opb.relations.filter (op)=>
        op.type == "object-property-parent-sub"

      top_relation = top_relations[0]
      opb_relation = opb_relations[0]

      expect(opb_relation).to.eql(top_relation)
      expect(opb_relation.parent).to.eql(opb)
      expect(opb_relation.sub).to.eql(top)

    it "object-property-inverse", ->
      top = owl_parser.get_model_by_iri("owl:topObjectProperty")
      opb = owl_parser.get_model_by_iri("#opc")

      top_relations = top.relations.filter (op)=>
        op.type == "object-property-inverse"
      opb_relations = opb.relations.filter (op)=>
        op.type == "object-property-inverse"

      top_relation = top_relations[0]
      opb_relation = opb_relations[0]

      expect(top_relation).to.eql(opb_relation)
      expect(top_relation.object_properties).to.eql([top, opb])

    it "object-property-domain-class", ->
      top   = owl_parser.get_model_by_iri("owl:topObjectProperty")
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      
      top_relations = top.relations.filter (op)=>
        op.type == "object-property-domain-class"
      clazz_relations = clazz.relations.filter (op)=>
        op.type == "object-property-domain-class"

      top_relation = top_relations[0]
      clazz_relation = clazz_relations[0]

      expect(top_relation).to.eql(clazz_relation)
      expect(top_relation.object_property).to.eql(top)
      expect(top_relation.class).to.eql(clazz)

    it "object-property-range-class", ->
      top   = owl_parser.get_model_by_iri("owl:topObjectProperty")
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      
      top_relations = top.relations.filter (op)=>
        op.type == "object-property-range-class"
      clazz_relations = clazz.relations.filter (op)=>
        op.type == "object-property-range-class"

      top_relation = top_relations[0]
      clazz_relation = clazz_relations[0]

      expect(top_relation).to.eql(clazz_relation)
      expect(top_relation.object_property).to.eql(top)
      expect(top_relation.class).to.eql(clazz)

    it "object-property-disjoint", ->
      top   = owl_parser.get_model_by_iri("owl:topObjectProperty")
      opd = owl_parser.get_model_by_iri("#opd")

      top_relations = top.relations.filter (op)=>
        op.type == "object-property-disjoint"
      opd_relations = opd.relations.filter (op)=>
        op.type == "object-property-disjoint"

      top_relation = top_relations[0]
      opd_relation = opd_relations[0]

      expect(top_relation).to.eql(opd_relation)
      expect(top_relation.object_properties).to.eql([opd, top])

    it "class.object_properties", ->
      top   = owl_parser.get_model_by_iri("owl:topObjectProperty")
      clazz = owl_parser.get_model_by_iri("owl:Thing")
      expect(clazz.object_properties).to.eql([top])
