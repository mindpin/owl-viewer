class OntologyCharacteristic
  @FUNCTIONAL = new OntologyCharacteristic('FUNCTIONAL')
  @INVERSE_FUNCTIONAL = new OntologyCharacteristic('INVERSE_FUNCTIONAL')
  @SYMMETRIC = new OntologyCharacteristic('SYMMETRIC')
  @ASYMMETRIC = new OntologyCharacteristic('ASYMMETRIC')
  @TRANSITIVE = new OntologyCharacteristic('TRANSITIVE')
  @REFLEXIVE = new OntologyCharacteristic('REFLEXIVE')
  @IRREFLEXIVE = new OntologyCharacteristic('IRREFLEXIVE')

  constructor: (name) ->
    @name = name


jQuery.extend window,
  OntologyCharacteristic: OntologyCharacteristic