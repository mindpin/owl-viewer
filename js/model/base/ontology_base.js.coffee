class OntologyBase

  get_name: (iri) ->
    position = iri.indexOf('#')
    return iri.substring(1) if position is 0

    sections = iri.split(':')
    return sections[1]

  get_relations_by_type: (type) ->
    @relations.filter (re) =>
      re.type == type

jQuery.extend window,
  OntologyBase: OntologyBase
