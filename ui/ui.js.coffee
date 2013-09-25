class CircleCollid
  constructor: (@obja, @objb)->

  # 是否碰撞，碰撞则返回碰撞数据对象，否则返回 null
  is_colliding: ->
    return null if @obja == @objb

    uia = @obja.ui
    uib = @objb.ui

    deltax = uib.x - uia.x
    deltay = uib.y - uia.y

    # 半径和
    rsum = uia.radius + uib.radius

    # 两个圆圆心距离
    d = Math.sqrt(deltax * deltax + deltay * deltay)

    # 小于半径和，碰撞
    if d < rsum
      @deep = rsum - d # 碰撞深度
      @deepx = @deep * deltax / d
      @deepy = @deep * deltay / d
      return @

    return null

class OwlRelationUi
  COLOR: '#C459DA'
  constructor: (@relation)->
    @line_layer = @relation.owl_ui.line_layer

    if @relation.type == 'parent-sub'
      @draw_type_parent_sub()

  draw_type_parent_sub: ->
    @refresh()

  refresh: ->
    px = @relation.parent.ui.x
    py = @relation.parent.ui.y
    sx = @relation.sub.ui.x
    sy = @relation.sub.ui.y

    deltax = px - sx
    deltay = py - sy

    d = Math.sqrt(deltax * deltax + deltay * deltay)

    offy = 6 * deltax / d
    offx = 6 * deltay / d
    mx = (px + sx) / 2
    my = (py + sy) / 2

    line_points = [px, py, sx, sy]

    arrow_points = [
      mx - offy * 2, my - offx * 2
      mx - offx, my + offy
      mx + offx, my - offy
    ]

    if !@canvas_line
      @canvas_line = new Kinetic.Line
        points: line_points
        stroke: @COLOR
        strokeWidth: 2
        lineCap: 'round'
        lineJoin: 'round'

      @canvas_arrow = new Kinetic.Polygon
        points: arrow_points
        fill: 'white'
        stroke: @COLOR
        strokeWidth: 2

      @line_layer.add(@canvas_line)
      @line_layer.add(@canvas_arrow)

    else
      @canvas_line.setPoints line_points
      @canvas_arrow.setPoints arrow_points

    
    @line_layer.draw()

class OwlObjUi
  constructor: (@obj)->
    @layer = @obj.owl_ui.layer
    @render()

  render: ->
    @$elm = jQuery("<a href='javascript:;'></a>")
      .addClass(@klass).addClass('obj')
      .html("#{@klass}: #{@obj.name}")
      .appendTo @parent_elm()

  draw: ->
    # no

  draw_relations: ->

class CircleObjUi extends OwlObjUi
  CIRCLE_PADDING: 10
  OPACITY: 1
  TEXT_COLOR: '#333'
  FONT_SIZE: 14
  FILL: 'white'
  STROKE: '#333'
  HOVER_FILL: '#f4f4f4'
  x: -10000
  y: -10000

  draw: ->
    @ox = @x
    @oy = @y

    @canvas_text = new Kinetic.Text
      x: @x
      y: @y
      text: @obj.name
      fontSize: @FONT_SIZE
      fontStyle: 'bold'
      fontFamily: 'Calibri, Microsoft YaHei'
      fill: @TEXT_COLOR

    text_width = @canvas_text.getWidth()
    text_height = @canvas_text.getHeight()

    @canvas_text.setOffset
      x: text_width / 2
      y: text_height / 2

    @radius = text_width / 2 + @CIRCLE_PADDING

    # 圆是从圆心算起
    @canvas_circle = new Kinetic.Circle
      x: @x
      y: @y
      radius: @radius
      fill: @FILL
      stroke: @STROKE
      strokeWidth: 2

    @canvas_group = new Kinetic.Group
      opacity: @OPACITY
      draggable: true
      dragBoundFunc: (pos)=>
        console.log @obj.owl_ui.stage_x
        @x = @ox + pos.x - @obj.owl_ui.stage_x
        @y = @oy + pos.y - @obj.owl_ui.stage_y
        return pos

    @canvas_group.on 'mouseover', =>
      @canvas_circle.setFill(@HOVER_FILL)
      @layer.draw()
      jQuery('body').css('cursor', 'pointer')

    @canvas_group.on 'mouseout', =>
      @canvas_circle.setFill(@FILL)
      @layer.draw()
      jQuery('body').css('cursor', 'default')

    @canvas_group.on 'mousedown', =>
      @canvas_group.moveToTop()
      @layer.draw()

    @canvas_group.on 'dragmove', =>
      for r in @obj.relations
        r.ui.refresh() if r.ui

    @canvas_group.add @canvas_circle
    @canvas_group.add @canvas_text

    @layer.add @canvas_group
    @layer.draw()

class OwlClassUi extends CircleObjUi
  klass: 'class'
  FONT_SIZE: 16
  parent_elm: ->
    @obj.owl_ui.$classes

  draw_relations: ->
    for relation in @obj.relations
      if !relation.ui
        relation.owl_ui = @obj.owl_ui
        relation.ui = new OwlRelationUi(relation)

class OwlIndividualUi extends CircleObjUi
  klass: 'individual'
  TEXT_COLOR: 'white'
  FILL: '#333'
  STROKE: '#333'
  HOVER_FILL: '#111'
  parent_elm: ->
    @obj.owl_ui.$individuals

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
    # 作为图形节点显示
    @classes = @ontology.classes
    @individuals = @ontology.individuals
    
    # 只在侧边栏显示
    @annotations = @ontology.annotations
    @data_properties = @ontology.data_properties
    @object_properties = @ontology.object_properties
    @data_types = @ontology.data_types

    @build_sidebar_dom()

    @init_stage()
    @generate_objects_ui()

  build_sidebar_dom: ->
    if !@$page
      @$page = jQuery('<div></div>')
        .addClass('owl-viewer-page')
        .appendTo(jQuery('body'))

      @$objects_list = jQuery('<div></div>')
        .addClass('objects-list')
        .appendTo(@$page)

      @$classes = jQuery('<div></div>')
        .addClass('objs').addClass('classes')
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

  init_stage: ->
    if !@$stage
      @stage_x = 0
      @stage_y = 0

      @$stage = jQuery("<div></div>")
        .addClass('stage')
        .appendTo @$page

      @stage = new Kinetic.Stage
        container: @$stage[0]
        width: @$stage.width()
        height: @$stage.height()
        draggable: true
        dragBoundFunc: (pos)=>
          @stage_x = pos.x
          @stage_y = pos.y
          return pos

      jQuery(window).on 'resize', =>
        @stage.setWidth @$stage.width()
        @stage.setHeight @$stage.height()

      @layer = new Kinetic.Layer()
      @line_layer = new Kinetic.Layer()

      @stage.add @line_layer
      @stage.add @layer

  generate_objects_ui: ->
    for klass in @classes
      klass.owl_ui = @
      klass.ui = new OwlClassUi(klass)
      klass.ui.draw()

    for individual in @individuals
      individual.owl_ui = @
      individual.ui = new OwlIndividualUi(individual)

    @layout()

  # 节点排布算法
  layout: ->
    @layout_nodes = []
    @layout_edges = []

    for klass in @classes
      @layout_nodes.push {
        id: klass.name
        label: klass.name
        width: klass.ui.radius * 2
        height: klass.ui.radius * 2
        node: klass
      }

      for sub_klass in klass.sub_classes()
        @layout_edges.push {
          sourceId: klass.name
          targetId: sub_klass.name
        }

    dagre.layout().nodes(@layout_nodes).edges(@layout_edges).run()
    for layout_node in @layout_nodes
      console.log layout_node.dagre
      layout_node.node.ui.x = layout_node.dagre.x * 2
      layout_node.node.ui.y = layout_node.dagre.y
      layout_node.node.ui.draw()

    for klass in @classes
      klass.ui.draw_relations()

window.OwlViewerUi = OwlViewerUi