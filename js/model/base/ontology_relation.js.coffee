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

class OntologyIndividualSameRelation
  constructor: (individuals) ->
    @individuals = individuals
    @type       = "individual-same"

class OntologyIndividualDifferentRelation
  constructor: (individuals) ->
    @individuals = individuals
    @type       = "individual-different"

class OntologyAnnotationParentSubRelation
  constructor: (parent, sub) ->
    @parent = parent
    @sub    = sub
    @type   = "annotation-parent-sub"

class OntologyAnnotationDomainClassRelation
  constructor: (clazz, annotation) ->
    @class = clazz
    @annotation = annotation
    @type = "annotation-domain-class"

class OntologyAnnotationRangeClassRelation  
  constructor: (clazz, annotation) ->
    @class = clazz
    @annotation = annotation
    @type = "annotation-range-class"

jQuery.extend window,
  OntologyClassParentSubRelation: OntologyClassParentSubRelation
  OntologyClassEquivalentRelation: OntologyClassEquivalentRelation
  OntologyClassDisjointRelation: OntologyClassDisjointRelation
  OntologyClassIndividualRelation: OntologyClassIndividualRelation
  OntologyIndividualSameRelation: OntologyIndividualSameRelation
  OntologyIndividualDifferentRelation: OntologyIndividualDifferentRelation
  OntologyAnnotationParentSubRelation: OntologyAnnotationParentSubRelation
  OntologyAnnotationDomainClassRelation: OntologyAnnotationDomainClassRelation
  OntologyAnnotationRangeClassRelation: OntologyAnnotationRangeClassRelation