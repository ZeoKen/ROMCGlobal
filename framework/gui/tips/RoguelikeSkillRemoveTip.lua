RoguelikeSkillRemoveTip = class("RoguelikeSkillRemoveTip", BaseTip)

function RoguelikeSkillRemoveTip:Init()
  self:FindObjs()
end

function RoguelikeSkillRemoveTip:FindObjs()
  local callbackWhenClickOtherPlace = self:FindComponent("Bg", CallBackWhenClickOtherPlace)
  
  function callbackWhenClickOtherPlace.call()
    TipManager.Instance:CloseTip()
  end
  
  self.icon = self:FindComponent("Icon", UISprite)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.levelLabel = self:FindComponent("Level", UILabel)
  self.descLabel = self:FindComponent("Desc", UILabel)
  local removeBtn = self:FindGO("RemoveBtn")
  self:AddClickEvent(removeBtn, function()
    MsgManager.ConfirmMsgByID(43630, function()
      ServiceFuBenCmdProxy.Instance:CallSTIDropSkillCmd(self.data:GetID())
    end, nil, nil, self.data:GetName(), self.data:GetReturnPoint())
  end)
  self.returnPointLabel = self:FindComponent("ReturnPoint", UILabel)
end

function RoguelikeSkillRemoveTip:SetData(data)
  self.data = data
  IconManager:SetSkillIcon(data:GetIcon(), self.icon)
  self.nameLabel.text = data:GetName()
  self.levelLabel.text = string.format(ZhString.RoguelikeRaid_Level, data:GetLevel())
  self.descLabel.text = data:GetDesc()
  self.returnPointLabel.text = data:GetReturnPoint()
end
