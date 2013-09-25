describe "undeclare parser", ->
  describe "undeclare.owl", ->
    ontology   = null
    owl_parser = null
    jQuery.ajax
      url: "../data/undeclare.owl",
      async: false,
      success: (data)->
        owl_parser = new OwlParser(data)
        ontology = owl_parser.build()
    it "ontology.classes", ->
      names = ontology.classes.map (clazz)->
        clazz.name
      expect(['B','A']).to.eql(names)
    it "ontology.individuals", ->
      names = ontology.individuals.map (clazz)->
        clazz.name
      expect(['a','b']).to.eql(names)
    it "ontology.data_properties", ->
      names = ontology.data_properties.map (clazz)->
        clazz.name
      expect(['topDataProperty']).to.eql(names)
    it "ontology.object_properties", ->
      names = ontology.object_properties.map (clazz)->
        clazz.name
      expect(['topObjectProperty']).to.eql(names)