autoImport("BaseCell")
PetDressingItemCell = class("PetDressingItemCell", ItemCell)
local FIXED_ICON = "pet_equip_off"
DressingItemCell = {
  LongPress = "DressingItemCell_LongPress"
}

function PetDressingItemCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.bg = self:FindGO("bg")
  self.lock = self:FindGO("LockFlag")
  self.chooseFlag = self:FindGO("ChooseFlag")
  self:AddCellClickEvent()
  self:AddEvts()
end

function PetDressingItemCell:AddEvts()
  self:AddClickEvent(self.bg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local longPress = self.bg:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    self:PassEvent(DressingItemCell.LongPress, {state, self})
  end
end

function PetDressingItemCell:SetData(data)
  self.data = data
  if data then
    self:Show(self.gameObject)
    if 0 ~= data.id then
      local iconName = Table_Item[data.id] and Table_Item[data.id].Icon or ""
      IconManager:SetItemIcon(iconName, self.icon)
    else
      IconManager:SetUIIcon(FIXED_ICON, self.icon)
    end
    self.icon:MakePixelPerfect()
    self.lock:SetActive(not data.unlocked)
    if data.unlocked then
      ColorUtil.WhiteUIWidget(self.icon)
    else
      ColorUtil.ShaderLightGrayUIWidget(self.icon)
    end
  else
    self:Hide(self.gameObject)
  end
  self:UpdateChoose()
end

function PetDressingItemCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function PetDressingItemCell:UpdateChoose()
  if self.data and self.chooseId and self.data.id ~= 0 and self.data.id == self.chooseId then
    self.chooseFlag:SetActive(true)
  else
    self.chooseFlag:SetActive(false)
  end
end
