autoImport("PveTypeCell")
SkadaBossPveTypeCell = class("SkadaBossPveTypeCell", PveTypeCell)

function SkadaBossPveTypeCell:Init()
  SkadaBossPveTypeCell.super.Init(self)
  LuaGameObject.SetLocalScaleGO(self.content, 0.8, 0.8, 1)
end

function SkadaBossPveTypeCell:SetData(data)
  SkadaBossPveTypeCell.super.SetData(self, data)
  self.featureLab.gameObject:SetActive(false)
end
