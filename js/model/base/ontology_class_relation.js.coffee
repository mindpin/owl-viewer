class OntologyClassParentSubRelation
  constructor: (parent, sub) ->
    @parent = parent
    @sub    = sub
    @type    = "parent-sub"

class OntologyClassEquivalentRelation
  constructor: (classes) ->
    @classes = classes
    @type    = "equivalent"

class OntologyClassDisjointRelation
  constructor: (classes) ->
    @classes = classes
    @type    = "disjoint"

class OntologyClassIndividualRelation
  constructor: (clazz, individual) ->
    @class      = clazz
    @individual = individual
    @type       = "class-individual"

jQuery.extend window,
  OntologyClassParentSubRelation: OntologyClassParentSubRelation
  OntologyClassEquivalentRelation: OntologyClassEquivalentRelation
  OntologyClassDisjointRelation: OntologyClassDisjointRelation
  OntologyClassIndividualRelation: OntologyClassIndividualRelation