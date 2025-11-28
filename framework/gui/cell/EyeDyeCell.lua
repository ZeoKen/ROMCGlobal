local baseCell = autoImport("BaseCell")
EyeDyeCell = class("EyeDyeCell", baseCell)

function EyeDyeCell:Init()
  EyeDyeCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function EyeDyeCell:FindObjs()
  self.empty = self:FindGO("empty")
  self.item = self:FindGO("Item")
  self.iconColor = self:FindGO("iconColor"):GetComponent(UISprite)
  self.iconFrame = self:FindComponent("iconFrame", UISprite, self.iconColor.gameObject)
  self.chooseImg = self:FindGO("chooseImg")
  self.equiped = self:FindGO("Equiped")
end

function EyeDyeCell:SetData(data)
  self.data = data
  self.eyeID = nil
  if data and data.id then
    self:Show(self.item)
    self:Hide(self.empty)
    local eyeID = data.goodsID
    if self.equiped then
      self.equiped:SetActive(eyeID == ShopDressingProxy.Instance.originalEye)
    end
    if eyeID then
      self.eyeID = eyeID
      local csvData = Table_Eye[eyeID]
      if csvData and csvData.Icon then
        local csvColor = csvData.ShopEyeColor
        if csvColor and 0 < #csvColor then
          local success, eyeColor = ColorUtil.TryParseFromNumber(csvColor[1])
          if success then
            self.iconColor.color = eyeColor
            self.iconFrame.color = eyeColor
          end
        end
      end
    end
  else
    self:Hide(self.item)
    self:Show(self.empty)
  end
  self:UpdateChoose()
  self:SetEquiped()
end

function EyeDyeCell:SetChoose(id)
  self.chooseId = id
  self:UpdateChoose()
end

function EyeDyeCell:UpdateChoose()
  self.chooseImg:SetActive(self.eyeID == self.chooseId)
end

function EyeDyeCell:SetEquiped()
  if self.equiped then
    self.equiped:SetActive(self.eyeID == ShopDressingProxy.Instance.originalEye)
  end
end
