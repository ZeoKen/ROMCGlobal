local baseCell = autoImport("BaseCell")
TransferProfessionTabCell = class("TransferProfessionTabCell", baseCell)
local tempVector3 = LuaVector3.Zero()
local tempColor = LuaColor.White()

function TransferProfessionTabCell:Init()
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
  self.tog = self:FindGO("Tog"):GetComponent(UIToggle)
  self.backGround = self:FindGO("Background"):GetComponent(UISprite)
  self.checkMark = self:FindGO("Checkmark"):GetComponent(UISprite)
  self:AddCellClickEvent()
end

function TransferProfessionTabCell:SetData(data)
  self.data = data
  self.staticData = Table_Class[data]
  if not self.staticData then
    return
  end
  local icon = self.staticData.icon
  if icon and icon ~= "" then
    IconManager:SetNewProfessionIcon(icon, self.icon)
    self.icon:MakePixelPerfect()
    LuaVector3.Better_Set(tempVector3, 0.5, 0.5, 0.5)
    self.icon.transform.localScale = tempVector3
  end
  local classType = self.staticData.Type
  if classType then
    local iconColor = ColorUtil["CareerIconPreviewBg" .. classType]
    if iconColor == nil then
      iconColor = ColorUtil.CareerIconBg0
    end
    self.backGround.color = iconColor
    self.checkMark.color = iconColor
  end
end

function TransferProfessionTabCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      LuaColor.Better_Set(tempColor, 1, 1, 1, 1)
      self.icon.color = tempColor
      self.tog.value = true
    else
      LuaColor.Better_Set(tempColor, 1, 1, 1, 1)
      self.icon.color = tempColor
      self.tog.value = false
    end
  end
end
