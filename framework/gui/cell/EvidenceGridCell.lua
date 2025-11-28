local BaseCell = autoImport("BaseCell")
EvidenceGridCell = class("EvidenceGridCell", BaseCell)

function EvidenceGridCell:Init()
  EvidenceGridCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function EvidenceGridCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.redtip = self:FindGO("RedTip")
  self.finishSymbol = self:FindGO("FinishSymbol")
  local longPress = self.gameObject:AddComponent(UILongPress)
  longPress.pressTime = 0.5
  
  function longPress.pressEvent(obj, isPress)
    if isPress then
      self:PassEvent(SevenRoyalFamilies.JointInferenceLongPressEvidence, self)
    else
      TipsView.Me():HideTip(EvidenceDetailTip)
    end
  end
end

function EvidenceGridCell:SetData(data)
  self.data = data
  local staticData = data.staticData
  self.id = staticData.id
  local icon = staticData.Icon
  local setSuc = IconManager:SetItemIcon(icon, self.icon)
  if not setSuc then
    IconManager:SetItemIcon("item_45001", self.icon)
  end
  self.chooseSymbol:SetActive(false)
  local finishStatus = data.finish or false
  self:SetFinish(finishStatus)
  self:SetNew(data.isnew or false)
end

function EvidenceGridCell:SetChoose(bool)
  self.chooseSymbol:SetActive(bool)
end

function EvidenceGridCell:SwitchChoose()
  self.chooseSymbol:SetActive(not self.chooseSymbol.activeSelf)
end

function EvidenceGridCell:RegisterRedtip()
  local isNew = false
  self.redtip:SetActive(isNew)
end

function EvidenceGridCell:SetFinish(bool)
  self.finishSymbol:SetActive(bool)
  self.icon.alpha = bool and 0.5 or 1
end

function EvidenceGridCell:SetNew(bool)
  self.redtip:SetActive(bool)
end
