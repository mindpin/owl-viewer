class OntologyAnnotation

  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)

    @sub_annotations = []
    @parent_annotations = []
    @domain_things = []
    @range_things = []

  add_sub_annotation: (annotation) ->
    @sub_annotations.push(annotation)

  add_parent_annotation: (annotation) ->
    @parent_annotations.push(annotation)

  add_domain_things: (domain) ->
    @domain_things.push(domain)

  add_range_things: (range) ->
    @range_things.push(range)

jQuery.extend window,
  OntologyAnnotation: OntologyAnnotation