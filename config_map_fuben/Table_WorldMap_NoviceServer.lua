Table_WorldMap = {
  [1] = {
    id = 1,
    NameZh = "米德加尔特",
    MapSwitch = {
      {
        to = 2,
        showpos = {-409.9, -107.3}
      }
    },
    MapPic = "map",
    Icon = "map_icon_mdjet",
    Desc = "米德加尔特位于世界之树中央某处，是人类唯一可见全貌的世界。"
  },
  [2] = {
    id = 2,
    NameZh = "未知的领域",
    MapSwitch = {
      {
        to = 1,
        showpos = {454.7, 35.5}
      }
    },
    MapPic = "Asgard",
    Icon = "map_icon_asjd",
    Desc = "人类目前无法踏足的神秘区域，无人知晓它的秘密。也许某一天，当既定的启示来临时，会有人踏上改变命运的旅程。"
  }
}
Table_WorldMap_fields = {
  "id",
  "NameZh",
  "MapSwitch",
  "MapPic",
  "Icon",
  "Desc"
}
return Table_WorldMap
