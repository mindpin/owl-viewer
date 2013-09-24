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

jQuery.extend window,
  OntologyIndividual: OntologyIndividual
