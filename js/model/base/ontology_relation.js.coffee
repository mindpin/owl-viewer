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

class OntologyObjectPropertyParentSubRelation
  constructor: (parent, sub) ->
    @parent = parent
    @sub = sub
    @type = "object-property-parent-sub"

class OntologyObjectPropertyEquivalentRelation
  constructor: (object_properties) ->
    @object_properties = object_properties
    @type = "object-property-equivalent"

class OntologyObjectPropertyInverseRelation
  constructor: (object_properties) ->
    @object_properties = object_properties
    @type = "object-property-inverse"

class OntologyObjectPropertyDisjointRelation
  constructor: (object_properties) ->
    @object_properties = object_properties
    @type = "object-property-disjoint"

class OntologyObjectPropertyDomainClassRelation
  constructor: (object_property, clazz) ->
    @object_property = object_property
    @class = clazz
    @type = "object-property-domain-class"

class OntologyObjectPropertyRangeClassRelation
  constructor: (object_property, clazz) ->
    @object_property = object_property
    @class = clazz
    @type = "object-property-range-class"

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
  OntologyObjectPropertyParentSubRelation: OntologyObjectPropertyParentSubRelation
  OntologyObjectPropertyEquivalentRelation: OntologyObjectPropertyEquivalentRelation
  OntologyObjectPropertyInverseRelation: OntologyObjectPropertyInverseRelation
  OntologyObjectPropertyDisjointRelation: OntologyObjectPropertyDisjointRelation
  OntologyObjectPropertyDomainClassRelation: OntologyObjectPropertyDomainClassRelation
  OntologyObjectPropertyRangeClassRelation: OntologyObjectPropertyRangeClassRelation