class
individual
object_property
data_property
annotation
data_type
==============

demo1
=====
一个 class 
  "人"

demo2
=====
两个 class 
  "人"
  "三国人物"

"三国人物" 是 "人" 的子集

demo3
=====
两个 class 
  "软件工程师"
  "程序员"

"软件工程师" 和 "程序员" 是 equivalent 关系

demo4
=====
两个 class 
  "男人"
  "女人"
  
"男人" 和 "女人" 是 disjoint 关系
  
demo5
=====
一个 class 
  "人"
两个 individual
  "吕布"
  "张飞"

"吕布" 和 "张飞" 是 "人" 的 individuals
  

demo6
=====
一个 class 
  "人"
两个 individual
  "孔明"
  "诸葛亮"

"孔明" 和 "诸葛亮" 是 "人" 的 individuals
"孔明" 和 "诸葛亮" 是 same 关系


demo7
=====
一个 class 
  "人"
两个 individual
  "孔明"
  "张飞"

"孔明" 和 "张飞" 是 "人" 的 individuals
"孔明" 和 "张飞" 是 different 关系


demo8
=====
一个 class 
  "人"
  "三国人物"
  "歌手"
两个 individual
  "王菲"
  "张飞"

"王菲" 和 "张飞" 是 "人" 的 individuals
"王菲" 是 "歌手" 的 individuals
"张飞" 是 "三国人物" 的 individuals
"三国人物" 是 "人" 的子集
"歌手" 是 "人" 的子集

"王菲" 和 "张飞" 是 different 关系

demo9
=====
一个 class 
  "人"
两个 individual
  "关羽"
  "张飞"
一个 object property
  "结拜兄弟关系"

"关羽" 有个 "结拜兄弟关系" 取值是 "张飞"

demo10
=====
一个 class 
  "人"
两个 individual
  "关羽"
  "张飞"
两个 object property
  "朋友关系"
  "结拜兄弟关系"

"关羽" 有个 "结拜兄弟关系" 取值是 "张飞"
"结拜兄弟关系" 是 "朋友关系" 的 子集

demo11
======
一个 class 
  "人"
两个 individual
  "周瑜"
  "黄盖"
两个 object property
  "打"
  "被打"

"周瑜" 有个 "打" 取值是 "黄盖"
"黄盖" 有个 "被打" 取值是 "周瑜"
"打" 是 "被打" 的  inverse object property
"被打" 是 "打" 的  inverse object property

demo12
======
一个 class 
  "人"
两个 individual
  "刘备"
  "张飞"
  "曹操"
两个 object property
  "朋友关系"
  "敌人关系"

"刘备" 有个 "朋友关系" 取值是 "张飞"
"刘备" 有个 "敌人关系" 取值是 "曹操"
"朋友关系" 是 "敌人关系" 的 disjoint object property
"敌人关系" 是 "朋友关系" 的 disjoint object property

demo13
========
两个 class
 "狮子"
 "兔子"
两个 individual
  "辛巴"
  "兔八哥"
一个 object_property
  "吃"

"辛巴" 是 "狮子" 的 individual
"兔八哥" 是 "兔子" 的 individual
"辛巴" 有个 "吃" 的值是 "兔八哥"
"狮子" 是 "吃" 的 domain classes
"兔子" 是 "吃" 的 range classes

demo14
=======
两个 individual
  "张飞"
  "关羽"
一个 object property
  "结拜兄弟关系"

"张飞" 有个 "结拜兄弟关系" 的值是 "关羽"
"关羽" 有个 "结拜兄弟关系" 的值是 "张飞"
"结拜兄弟关系" 具有 symmetric (对称性) 

demo15
======
两个 individual
  "张飞"
  "关羽"
一个 object property
  "结拜大哥关系"

"张飞" 有个 "结拜大哥关系" 的值是 "关羽"
"关羽" 的 "结拜大哥关系" 的值不可能是 "张飞"
"结拜大哥关系" 具有 asymmetric (非对称性)

demo16
======
两个 individual
  "赵云"
  "刘备"
一个 object property
  "主公关系"

"赵云" 有个 "主公关系" 的值是 "刘备"
"赵云" 的主公只有一个
"主公关系" 具有 functional (专一性) 


demo17
======
两个 individual
  "刘备"
  "刘备老婆甘夫人"

一个 object property
  "夫妻关系"

"刘备" 有个 "夫妻关系" 的值是 "刘备老婆甘夫人"
反过来
"刘备老婆甘夫人" 有个 "夫妻关系" 的值是 "刘备"
刘备老婆甘夫人 有且只有一个丈夫 刘备
"夫妻关系" 具有 inverse functional (被动专一性) 

demo18
======
三个 individual
  "刘备"
  "张飞"
  "关羽"

一个 object property
  "结拜兄弟关系"

"刘备" 有个 "结拜兄弟关系" 取值是 "张飞"
"张飞" 有个 "结拜兄弟关系" 取值是 "关羽"
那么
"刘备" 有个 "结拜兄弟关系" 取值是 "关羽"
"结拜兄弟关系" 具有  transitive (传递性) 

demo19
======
三个 individual
  "刘备"
  "张飞"

一个 object property
  "可以依靠"

"刘备" 有个 "可以依靠" 取值是 "张飞"
此外
"刘备" 的 "可以依靠" 取值必然有 "刘备" 自己

"可以依靠" 具有 reflexive (自指性)

demo20
======
三个 individual
  "刘备"
  "张飞"

一个 object property
  "结拜兄弟关系"

"刘备" 有个 "结拜兄弟关系" 取值是 "张飞"
"刘备" 的 "结拜兄弟关系" 取值不可能是 "刘备" 自己
"结拜兄弟关系" 具有  irreflexive (非自指性) 