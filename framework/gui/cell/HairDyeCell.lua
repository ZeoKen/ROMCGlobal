local baseCell = autoImport("BaseCell")
HairDyeCell = class("HairDyeCell", baseCell)

function HairDyeCell:Init()
  HairDyeCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function HairDyeCell:FindObjs()
  self.empty = self:FindGO("empty")
  self.item = self:FindGO("Item")
  self.iconColor = self:FindGO("iconColor"):GetComponent(UISprite)
  self.iconFrame = self:FindComponent("iconFrame", UISprite, self.iconColor.gameObject)
  self.chooseImg = self:FindGO("chooseImg")
  self.equiped = self:FindGO("Equiped")
end

function HairDyeCell:SetData(data)
  self.data = data
  if self.data then
    self:SetActive(self.item, true)
    self:SetActive(self.empty, false)
    local hairColorData = Table_HairColor[data.hairColorID]
    if hairColorData then
      local color = hairColorData.Color
      if color then
        local result, c = ColorUtil.TryParseHexString(color)
        if result then
          self.iconColor.color = c
          self.iconFrame.color = c
        end
      end
    end
  else
    self:SetActive(self.item, false)
    self:SetActive(self.empty, true)
  end
  self.colorId = data and data.hairColorID or nil
  self:SetEquiped()
  self:UpdateChoose()
end

function HairDyeCell:SetChoose(id)
  self.chooseId = id
  self:UpdateChoose()
end

function HairDyeCell:UpdateChoose()
  if self.data and self.data.id and self.data.id == self.chooseId then
    self.chooseImg:SetActive(true)
  else
    self.chooseImg:SetActive(false)
  end
end

function HairDyeCell:SetEquiped()
  if self.equiped then
    self.equiped:SetActive(self.colorId == ShopDressingProxy.Instance.originalHairColor)
  end
end
