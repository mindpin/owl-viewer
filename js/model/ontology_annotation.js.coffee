class OntologyAnnotation

  constructor: (iri) ->
    @iri = iri
    @name = iri.substring(1)

    @sub_annotations = []
    @parent_annotations = []
    @domains = []
    @ranges = []

  add_sub_annotation: (annotation) ->
    @sub_annotations.push(annotation)

  add_parent_annotation: (annotation) ->
    @parent_annotations.push(annotation)

  add_domain_things: (domain) ->
    @domains.push(domain)

  add_range_things: (range) ->
    @ranges.push(range)

jQuery.extend window,
  OntologyAnnotation: OntologyAnnotation