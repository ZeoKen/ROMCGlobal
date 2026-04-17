SnowCrownAreaAttrCell = class("SnowCrownAreaAttrCell", BaseCell)

function SnowCrownAreaAttrCell:Init()
  self:FindObjs()
end

function SnowCrownAreaAttrCell:FindObjs()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.icon = self:FindComponent("Icon", UISprite)
  self.level = self:FindComponent("Level", UILabel)
  self.lock = self:FindGO("Lock")
  self.select = self:FindGO("Select")
  self:AddCellClickEvent()
end

function SnowCrownAreaAttrCell:SetData(data, index)
  self.index = index
  self.data = data
  if data and data.staticData then
    self.icon.spriteName = data.staticData.Icon
    if data.level > 0 then
      local maxLevel = Game.SnowCrownGroupMaxLevel[data.id // 100]
      self.level.text = maxLevel ~= nil and maxLevel <= data.level and ZhString.SnowCrown_MaxLevel or "Lv." .. data.level
    else
      self.level.text = ""
    end
    self.lock:SetActive(data.isLock or false)
  end
end

function SnowCrownAreaAttrCell:SetSelect(select)
  self.select:SetActive(select)
end
