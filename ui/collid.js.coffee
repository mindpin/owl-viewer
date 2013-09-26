# class CircleCollid
#   constructor: (@obja, @objb)->

#   # 是否碰撞，碰撞则返回碰撞数据对象，否则返回 null
#   is_colliding: ->
#     return null if @obja == @objb

#     uia = @obja.ui
#     uib = @objb.ui

#     deltax = uib.x - uia.x
#     deltay = uib.y - uia.y

#     # 半径和
#     rsum = uia.radius + uib.radius

#     # 两个圆圆心距离
#     d = Math.sqrt(deltax * deltax + deltay * deltay)

#     # 小于半径和，碰撞
#     if d < rsum
#       @deep = rsum - d # 碰撞深度
#       @deepx = @deep * deltax / d
#       @deepy = @deep * deltay / d
#       return @

#     return null