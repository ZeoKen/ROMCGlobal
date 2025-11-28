MenuUnlockItemCell = class("MenuUnlockItemCell", BaseCell)

function MenuUnlockItemCell:Init()
  self.empty = self:FindGO("empty")
  self.itemObj = self:FindGO("itemObj")
  self.iconSprite = self:FindGO("Icon_Sprite"):GetComponent(UISprite)
  self.numLabel = self:FindGO("NumLabel"):GetComponent(UILabel)
  self:AddCellClickEvent()
end

local tempScale = LuaVector3(0.7, 0.7, 0.7)

function MenuUnlockItemCell:SetData(data)
  self.data = data
  if data then
    IconManager:SetItemIcon(self.data.staticData.Icon, self.iconSprite)
    self.iconSprite:MakePixelPerfect()
    self.iconSprite.transform.localScale = tempScale
    self.itemObj:SetActive(true)
    self.empty:SetActive(false)
  else
    self.itemObj:SetActive(false)
    self.empty:SetActive(true)
  end
end
