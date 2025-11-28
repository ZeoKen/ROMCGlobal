autoImport("RecallItemCell")
RecallContractView = class("RecallContractView", ContainerView)
RecallContractView.ViewType = UIViewType.NormalLayer
local _bgName = "home_letter_bg0"
local _tipData = {}
_tipData.funcConfig = {}

function RecallContractView:OnExit()
  PictureManager.Instance:UnLoadHome(_bgName, self.bg1)
  PictureManager.Instance:UnLoadHome(_bgName, self.bg2)
  RecallContractView.super.OnExit(self)
end

function RecallContractView:Init()
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitShow()
end

function RecallContractView:FindObj()
  self.bg1 = self:FindGO("BgTexture1"):GetComponent(UITexture)
  self.bg2 = self:FindGO("BgTexture2"):GetComponent(UITexture)
  self.contractName = self:FindGO("ContractName"):GetComponent(UILabel)
end

function RecallContractView:AddButtonEvt()
  local addBtn = self:FindGO("AddBtn")
  self:AddClickEvent(addBtn, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RecallContractSelectView
    })
  end)
  local contractBtn = self:FindGO("ContractBtn")
  self:AddClickEvent(contractBtn, function()
    if self.selectGuid ~= nil then
      local tempArray = ReusableTable.CreateArray()
      tempArray[1] = self.selectGuid
      ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.Contract)
      ReusableTable.DestroyArray(tempArray)
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(3639)
      self:CloseSelf()
    end
  end)
end

function RecallContractView:AddViewEvt()
  self:AddListenEvt(RecallEvent.Select, self.Select)
end

function RecallContractView:InitShow()
  PictureManager.Instance:SetHome(_bgName, self.bg1)
  PictureManager.Instance:SetHome(_bgName, self.bg2)
  local _GameConfigRecall = GameConfig.Recall
  local tip = self:FindGO("Tip", self.contractRoot):GetComponent(UILabel)
  tip.text = string.format(ZhString.Friend_RecallContractTip, #FriendProxy.Instance:GetRecallList(), _GameConfigRecall.ContractTime / 86400)
  local myName = self:FindGO("MyName"):GetComponent(UILabel)
  myName.text = Game.Myself.data:GetName()
  self.greeting = self:FindGO("greeting"):GetComponent(UILabel)
  self:FillTextByHelpId(911, self.greeting)
  ServiceSessionSocialityProxy.Instance:CallQuerySocialData()
end

function RecallContractView:Select(note)
  local data = note.body
  if data then
    self.selectGuid = data.guid
    self.contractName.text = data:GetName()
  end
end
