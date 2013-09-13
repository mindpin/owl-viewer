class OntologyAnnotation extends OntologyBase

  constructor: (iri) ->
    @iri = iri
    @name = @get_name(iri)

    @sub_annotations = []
    @parent_annotations = []
    @domain_things = []
    @range_things = []
    @annotation_values = []

  add_sub_annotation: (annotation) ->
    @sub_annotations.push(annotation)

  add_parent_annotation: (annotation) ->
    @parent_annotations.push(annotation)

  add_domain_thing: (domain) ->
    @domain_things.push(domain)

  add_range_thing: (range) ->
    @range_things.push(range)

  add_annotation_value: (annotation_value) ->
    @annotation_values.push(annotation_value)
    

jQuery.extend window,
  OntologyAnnotation: OntologyAnnotation