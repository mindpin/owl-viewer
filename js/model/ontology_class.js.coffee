class OntologyClass extends OntologyBase
  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)

    @relations = []
    
    @object_properties = []
    @data_properties = []

  add_relation: (relation) ->
    @relations.push(relation)

  add_object_property: (object_property) ->
    @object_properties.push(object_property)

  add_data_property: (data_property) ->
    @data_properties.push(data_property)

  is_top: () ->
    relations = @relations.filter (re) =>
      re.type == "parent-sub" && re.sub == this
      
    relations.length == 0

  sub_classes: () ->
    return @subs if !!@subs
    relations = @relations.filter (re) =>
      re.type == "parent-sub" && re.parent == this
    @subs = relations.map (re) =>
      re.sub
    @subs

  parent_classes: () ->
    return @parents if !!@parents
    relations = @relations.filter (re) =>
      re.type == "parent-sub" && re.sub == this
    @parents = relations.map (re) =>
      re.parent
    @parents

  individuals: () ->
    return @attr_individuals if !!@attr_individuals
    relations = @relations.filter (re) =>
      re.type == "class-individual" && re.class == this
    @attr_individuals = relations.map (re) =>
      re.individual
    @attr_individuals

jQuery.extend window,
  OntologyClass: OntologyClass