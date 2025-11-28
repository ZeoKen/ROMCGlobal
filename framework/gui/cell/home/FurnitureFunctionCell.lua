local baseCell = autoImport("BaseCell")
FurnitureFunctionCell = class("FurnitureFunctionCell", baseCell)
local color_effectGray = LuaColor(0.6941176470588235, 0.6941176470588235, 0.6941176470588235, 1)

function FurnitureFunctionCell:Init()
  self:FindObjs()
end

function FurnitureFunctionCell:FindObjs()
  self.objButton = self:FindGO("Button")
  self.sprBtnBG = self:FindComponent("Bg", UIMultiSprite, self.objButton)
  self.sprBtnBG.CurrentState = 0
  self.labFunctionText = self:FindComponent("Label", UILabel, self.objButton)
  self.colorLabelEffect = self.labFunctionText.effectColor
  self:SetEvent(self.objButton, function()
    if self.data.status == FurnitureFuncState.Active then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end

function FurnitureFunctionCell:SetData(data)
  self.data = data
  local isActive = data ~= nil and data.status ~= FurnitureFuncState.InActive
  if self.isActive ~= isActive then
    self.gameObject:SetActive(isActive)
    self.isActive = isActive
  end
  if not isActive then
    return
  end
  self.labFunctionText.text = data.content
  if data.status == FurnitureFuncState.Active then
    self:SetTextureWhite(self.sprBtnBG)
    self.labFunctionText.effectColor = self.colorLabelEffect
  else
    self:SetTextureGrey(self.sprBtnBG)
    self.labFunctionText.effectColor = color_effectGray
  end
end
