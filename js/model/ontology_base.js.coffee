class OntologyBase

  get_name: (iri) ->
    position = iri.indexOf('#')
    return iri.substring(1) if position is 0

    sections = iri.split(':')
    return sections[1]
