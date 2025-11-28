autoImport("SkillCell")
autoImport("DragDropCell")
InheritSkillCell = class("InheritSkillCell", SkillCell)

function InheritSkillCell:Init()
  self:FindObjs()
end

function InheritSkillCell:FindObjs()
  self.icon = self:FindComponent("SkillIcon", UISprite)
  self.skillLevel = self:FindComponent("SkillLevel", UILabel)
  self.skillName = self:FindComponent("SkillName", UILabel)
  self.cost = self:FindComponent("Cost", UILabel)
  self.selectSp = self:FindComponent("Select", UIMultiSprite)
  self.lockGO = self:FindGO("Lock")
  self.nameBg = self:FindComponent("NameBg", UIMultiSprite)
  local dragItem = self:FindComponent("SkillBg", UIDragItem)
  self.dragDrop = DragDropCell.new(dragItem, 0.01)
  self.dragDrop.dragDropComponent.data = self
  local clickGO = self:FindGO("SkillBg")
  self:AddClickEvent(clickGO, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.checkGO = self:FindGO("Check")
  self.inheritGO = self:FindGO("Inherit")
end

function InheritSkillCell:SetData(data)
  self.data = data
  if data then
    IconManager:SetSkillIconByProfess(data.staticData.Icon, self.icon, MyselfProxy.Instance:GetMyProfessionType(), true)
    self.skillLevel.text = data.isInherited and string.format("%d/%d", data.level, data.maxLevel) or ""
    local name = OverSea.LangManager.Instance():GetLangByKey(data.staticData.NameZh)
    local len = StringUtil.getTextLen(name)
    if 5 < len then
      name = StringUtil.SubString(name, 1, 4) .. "..."
    end
    self.skillName.text = name
    UIUtil.WrapLabel(self.skillName)
    self.cost.text = data:GetCostPoint()
    self.checkGO:SetActive(data.isLoad or false)
    self:UpdateSkillNameBg(data.staticData)
  end
  self:UpdateDragable(self.data and self.data.isUnlock and self.data.isInherited or false)
  self:UpdateLock()
end

function InheritSkillCell:UpdateDragable(enable)
  self.dragDrop:SetDragEnable(enable)
end

function InheritSkillCell:UpdateLock()
  local isLock = not self.data or not self.data.isUnlock
  local isInherited = self.data and self.data.isInherited or false
  self.lockGO:SetActive(isLock)
  self.inheritGO:SetActive(not isLock and not isInherited)
  self.nameBg.alpha = not (not isLock and isInherited) and 0.5 or 1
  self.skillName.alpha = not (not isLock and isInherited) and 0.5 or 1
  if isLock then
    ColorUtil.ShaderGrayUIWidget(self.icon)
  else
    ColorUtil.WhiteUIWidget(self.icon)
  end
  self.icon.alpha = not (not isLock and isInherited) and 0.5 or 1
end

function InheritSkillCell:SetSelect(state)
  self.selectSp.gameObject:SetActive(state or false)
  if state then
    local isPassive = GameConfig.SkillType[self.data.staticData.SkillType].isPassive
    self.selectSp.CurrentState = isPassive and 1 or 0
    self.selectSp.width = isPassive and 70 or 75
    self.selectSp.height = isPassive and 70 or 75
  end
end
