autoImport("BaseItemNewCell")
EquipRepairMatCell = class("EquipRepairMatCell", BaseItemNewCell)
local noMatLabelColor = LuaColor.New(1, 0.3764705882352941, 0.12941176470588237, 1)
local redTipOffset = {-10, -10}

function EquipRepairMatCell:Init()
  EquipRepairMatCell.super.Init(self)
  self.nameTip = self:FindComponent("NameTip", UILabel)
  self.numLab = self:FindComponent("NumLabel", UILabel, self.item)
  self:InitManualRedTip()
end

function EquipRepairMatCell:InitManualRedTip()
  self.redTip = Game.AssetManager_UI:CreateAsset(RedTip.resID, self.gameObject):GetComponent(UISprite)
  UIUtil.ChangeLayer(self.redTip, self.gameObject.layer)
  local widget = self.gameObject:GetComponent(UIWidget)
  if widget then
    self.redTip.transform.position = NGUIUtil.GetAnchorPoint(self.gameObject, widget, NGUIUtil.AnchorSide.TopRight, redTipOffset)
    self.redTip.transform.localScale = LuaGeometry.Const_V3_one
    self.redTip.depth = widget.depth + 10
  end
  self.redTip.gameObject:SetActive(false)
end

function EquipRepairMatCell:SetData(data)
  EquipRepairMatCell.super.SetData(self, data)
  if not data.equipInfo then
    return
  end
  if data and data.id == "None" then
    self:SetNoMatState()
  else
    self:SetNormalState()
  end
end

function EquipRepairMatCell:SetNormalState()
  self.icon.alpha = 1
  self.numLab.color = ColorUtil.NGUIWhite
  if self.nameTip then
    self.nameTip.color = ColorUtil.NGUIWhite
  end
end

function EquipRepairMatCell:SetNoMatState()
  self.icon.alpha = 0.5
  self.numLab.color = noMatLabelColor
  if self.nameTip then
    self.nameTip.color = noMatLabelColor
  end
end

function EquipRepairMatCell:SetNeedNum(needNum)
  needNum = needNum or 0
  self.needNum = needNum
  if needNum > self.data.num then
    self:SetNoMatState()
  else
    self:SetNormalState()
  end
  self.numLab.text = string.format("%s/%s", self.data.num, needNum)
  if self.nameTip then
    self.nameTip.text = string.format("x%s", needNum)
  end
end

function EquipRepairMatCell:SetShowRedTip(isShow)
  isShow = isShow and true or false
  self.redTip.gameObject:SetActive(isShow)
  self.isShowRedTip = isShow
end

function EquipRepairMatCell:OnExit()
  Game.GOLuaPoolManager:AddToUIPool(RedTip.resID, self.redTip.gameObject)
end
