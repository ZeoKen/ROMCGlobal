autoImport("BaseTip")
autoImport("RoguelikeSkillTipAttrCell")
RoguelikeSkillTip = class("RoguelikeSkillTip", BaseTip)

function RoguelikeSkillTip:Init()
  self:FindObjs()
end

function RoguelikeSkillTip:FindObjs()
  local closeBtn = self:FindGO("CloseBtn")
  self:AddClickEvent(closeBtn, function()
    self:OnClose()
  end)
  local callbackWhenClickOtherPlace = self:FindComponent("Bg", CallBackWhenClickOtherPlace)
  
  function callbackWhenClickOtherPlace.call()
    self:OnClose()
  end
  
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.attrTable = self:FindComponent("AttrTable", UITable)
  self.attrListCtrl = ListCtrl.new(self.attrTable, RoguelikeSkillTipAttrCell, "RoguelikeSkillTipAttrCell")
end

function RoguelikeSkillTip:SetData(data)
  self.data = data
  if data then
    self.titleLabel.text = data:GetName()
    self.descLabel.text = data:GetDesc()
    local attrs = data:GetAttrs()
    self.attrListCtrl:ResetDatas(attrs)
    self.attrListCtrl:ResetPosition()
  end
end

function RoguelikeSkillTip:OnExit()
  self.attrListCtrl:RemoveAll()
  return true
end

function RoguelikeSkillTip:OnClose()
  TipsView.Me():HideCurrent()
end
