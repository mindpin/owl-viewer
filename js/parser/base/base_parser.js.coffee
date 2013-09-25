class BaseParser
  _get_fix_bug_iri: (iri)->
    return null if !iri
    reg = iri.match(/&(\S+);(\S+)/)
    return "#{reg[1]}:#{reg[2]}" if !!reg

    reg = iri.match(/\S+(#\S+)/)
    return reg[1] if !!reg

    return iri
    
jQuery.extend window,
  BaseParser: BaseParser