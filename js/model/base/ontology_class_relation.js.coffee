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

jQuery.extend window,
  OntologyClassParentSubRelation: OntologyClassParentSubRelation
  OntologyClassEquivalentRelation: OntologyClassEquivalentRelation
  OntologyClassDisjointRelation: OntologyClassDisjointRelation
