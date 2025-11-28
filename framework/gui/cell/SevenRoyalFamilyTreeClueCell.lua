local baseCell = autoImport("BaseCell")
SevenRoyalFamilyTreeClueCell = class("SevenRoyalFamilyTreeClueCell", baseCell)
SevenRoyalFamilyTreeClueCell.State = {
  Locked = 0,
  Processing = 1,
  Available = 2,
  Finished = 3
}
local familyIns

function SevenRoyalFamilyTreeClueCell:Init()
  if not familyIns then
    familyIns = ServiceFamilyCmdProxy.Instance
  end
  self:FindObjs()
  self:InitCell()
  self:AddCellClickEvent()
  self:AddGameObjectComp()
end

function SevenRoyalFamilyTreeClueCell:FindObjs()
  self.choose = self:FindGO("ChooseSymbol")
  self.qMark = self:FindGO("QMark")
  self.icon = self:FindComponent("Icon", UISprite)
  self.processing = self:FindGO("Processing")
  self.rewardSp = self:FindComponent("Reward", UISprite)
  self.pathSlider = self:FindComponent("Path", UISlider)
end

function SevenRoyalFamilyTreeClueCell:InitCell()
  IconManager:SetUIIcon("pet_icon_activity", self.rewardSp)
end

function SevenRoyalFamilyTreeClueCell:SetData(data)
  self.data = data
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  local state, canGetReward = familyIns:GetClueState(data.id), familyIns:ClueCanGetRewardPredicate(data.id)
  if canGetReward then
    self:SwitchToState(self.State.Available)
  elseif state == FamilyCmd_pb.EFAMILYCLUE_STATE_UNLOCK then
    self:SwitchToState(self.State.Processing)
  elseif state == FamilyCmd_pb.EFAMILYCLUE_STATE_REWARD then
    self:SwitchToState(self.State.Finished)
  else
    self:SwitchToState(self.State.Locked)
  end
  self:UpdateChoose()
end

function SevenRoyalFamilyTreeClueCell:SwitchToState(state)
  local exState = self.state
  self.state = state
  local isIconShow = state == self.State.Available or state == self.State.Finished
  self.icon.gameObject:SetActive(isIconShow)
  if isIconShow and Table_Item[self.data.id] then
    IconManager:SetItemIcon(Table_Item[self.data.id].Icon, self.icon)
  end
  self.qMark:SetActive(not isIconShow)
  if self.pathSlider then
    if exState == self.State.Available and state == self.State.Finished then
      self:TryClearTween()
      LeanTween.sliderNGUI(self.pathSlider, 0, 1, 0.5)
    else
      self.pathSlider.value = state == self.State.Finished and 1 or 0
    end
  end
  self.processing:SetActive(state == self.State.Processing)
  self.rewardSp.gameObject:SetActive(state == self.State.Available)
end

function SevenRoyalFamilyTreeClueCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function SevenRoyalFamilyTreeClueCell:UpdateChoose()
  if not self.choose then
    return
  end
  local isChoose = self.data ~= nil and self.chooseId == self.data.id
  self.choose:SetActive(isChoose)
end

function SevenRoyalFamilyTreeClueCell:OnDestroy()
  self:TryClearTween()
end

function SevenRoyalFamilyTreeClueCell:TryClearTween()
  if not self.pathSlider then
    return
  end
  LeanTween.cancel(self.pathSlider.gameObject)
end
