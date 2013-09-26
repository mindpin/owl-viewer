class OntologyIndividual extends OntologyBase
  
  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)

    @data_property_values = []

    @relations = []

  add_relation: (relation) ->
    @relations.push(relation)

  add_data_property_value: (data_property_value) ->
    @data_property_values.push(data_property_value)
    
  is_top: () ->
    relations = @relations.filter (re) ->
      re.type == "class-individual"

    relations.length == 0

  classes: () ->
    return @attr_classes if !!@attr_classes
    relations = @relations.filter (re) =>
      re.type == "class-individual" && re.individual == this
    @attr_classes = relations.map (re) =>
      re.class
    @attr_classes

jQuery.extend window,
  OntologyIndividual: OntologyIndividual
