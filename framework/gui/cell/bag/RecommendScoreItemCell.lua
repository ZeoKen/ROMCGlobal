local BaseCell = autoImport("BaseCell")
RecommendScoreItemCell = class("RecommendScoreItemCell", BaseCell)

function RecommendScoreItemCell:Init()
  self:FindObjs()
end

function RecommendScoreItemCell:FindObjs()
  self.iconGo = self:FindGO("icon")
  self.iconSprite = self.iconGo:GetComponent(UISprite)
  self.numberGo = self:FindGO("nmberBg")
  self.number = self:FindComponent("number", UILabel)
end

function RecommendScoreItemCell:SetData(_data)
  self.data = _data
  if self.data then
    self.number.text = self.data.num or self.data.count
    local itemData = Table_Item[self.data.id]
    if itemData and itemData.Icon then
      IconManager:SetItemIcon(itemData.Icon, self.iconSprite)
    else
      redlog("Table_Item have no id or no Icon ,this id = ", self.data.id)
    end
  else
    self.numberGo:SetActive(false)
    self.iconGo:SetActive(false)
  end
end

function RecommendScoreItemCell:Destroy()
  GameObject.Destroy(self.gameObject)
end

return RecommendScoreItemCell
