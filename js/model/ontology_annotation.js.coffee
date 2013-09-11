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

  add_domains_thing: (domain) ->
    @domains.push(domain)

  add_ranges_thing: (range) ->
    @ranges.push(range)

jQuery.extend window,
  OntologyAnnotation: OntologyAnnotation