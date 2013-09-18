class OwlObjUi
  constructor: (@obj)->
    @layer = @obj.owl_ui.layer

    @render()
    @draw()

  render: ->
    @$elm = jQuery("<a href='javascript:;'></a>")
      .addClass(@klass).addClass('obj')
      .html("#{@klass}: #{@obj.name}")
      .appendTo @parent_elm()

  draw: ->
    # nothing

class OwlThingUi extends OwlObjUi
  klass: 'thing'
  parent_elm: ->
    @obj.owl_ui.$things

  draw: ->
    rect = new Kinetic.Rect({
      x: ~~(Math.random() * 300)
      y: ~~(Math.random() * 300)
      width: 100
      height: 50
      fill: '#4285F4'
      stroke: 'black'
      strokeWidth: 2
    })

    @layer.add rect

class OwlAnnotationUi extends OwlObjUi
  klass: 'annotation'
  parent_elm: ->
    @obj.owl_ui.$annotations

class OwlIndividualUi extends OwlObjUi
  klass: 'individual'
  parent_elm: ->
    @obj.owl_ui.$individuals

class OwlDataPropertyUi extends OwlObjUi
  klass: 'data_property'
  parent_elm: ->
    @obj.owl_ui.$data_properties

class OwlObjectPropertyUi extends OwlObjUi
  klass: 'object_property'
  parent_elm: ->
    @obj.owl_ui.$object_properties

class OwlDataTypeUi extends OwlObjUi
  klass: 'data_type'
  parent_elm: ->
    @obj.owl_ui.$data_types

class OwlViewerUi
  constructor: ->

  load_owl: (owl_url)->
    jQuery.ajax
      url: owl_url,
      success: (data)=>
        owl_parser = new OwlParser(data)
        @ontology = owl_parser.build()

        @render()

  render: ->
    @things = @ontology.things
    @annotations = @ontology.annotations
    @individuals = @ontology.individuals
    @data_properties = @ontology.data_properties
    @object_properties = @ontology.object_properties
    @data_types = @ontology.data_types

    @build_dom()
    @init_stage()
    @fill_objects_list()
    @stage.add @layer
    


  build_dom: ->
    if !@$page
      @$page = jQuery('<div></div>')
        .addClass('owl-viewer-page')
        .appendTo(jQuery('body'))

      @$objects_list = jQuery('<div></div>')
        .addClass('objects-list')
        .appendTo @$page

      @$things = jQuery('<div></div>')
        .addClass('objs').addClass('things')
        .appendTo(@$objects_list)

      @$annotations = jQuery('<div></div>')
        .addClass('objs').addClass('annotations')
        .appendTo(@$objects_list)

      @$individuals = jQuery('<div></div>')
        .addClass('objs').addClass('individuals')
        .appendTo(@$objects_list)

      @$data_properties = jQuery('<div></div>')
        .addClass('objs').addClass('data_properties')
        .appendTo(@$objects_list)

      @$object_properties = jQuery('<div></div>')
        .addClass('objs').addClass('object_properties')
        .appendTo(@$objects_list)

      @$data_types = jQuery('<div></div>')
        .addClass('objs').addClass('data_types')
        .appendTo(@$objects_list)

  fill_objects_list: ->
    for thing in @things
      thing.owl_ui = @
      thing.ui = new OwlThingUi(thing)

    for annotation in @annotations
      annotation.owl_ui = @
      annotation.ui = new OwlAnnotationUi(annotation)

    for individual in @individuals
      individual.owl_ui = @
      individual.ui = new OwlIndividualUi(individual)

    for data_property in @data_properties
      data_property.owl_ui = @
      data_property.ui = new OwlDataPropertyUi(data_property)

    for object_property in @object_properties
      object_property.owl_ui = @
      object_property.ui = new OwlObjectPropertyUi(object_property)

    for data_type in @data_types
      data_type.owl_ui = @
      data_type.ui = new OwlDataTypeUi(data_type)

  init_stage: ->
    if !@$stage
      @$stage = jQuery("<div id='owl-stage'></div>")
        .addClass('stage')
        .appendTo @$page

      @stage = new Kinetic.Stage({
        container: @$stage[0]
        width: 500
        height: 500
      })

      jQuery(window).on 'resize', =>
        @stage.setWidth @$stage.width()
        @stage.setHeight @$stage.height()

      @layer = new Kinetic.Layer()

window.OwlViewerUi = OwlViewerUi