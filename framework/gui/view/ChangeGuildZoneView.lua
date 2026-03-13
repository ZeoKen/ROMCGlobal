ChangeGuildZoneView = class("ChangeGuildZoneView", ContainerView)
ChangeGuildZoneView.ViewType = UIViewType.NormalLayer

function ChangeGuildZoneView:Init()
  self:FindObjs()
  self:AddEvts()
  self:InitCost()
  self:UpdateCost()
  self:InitShow()
  self:InitEvents()
end

function ChangeGuildZoneView:InitEvents()
  self:AddListenEvt(ServiceEvent.GuildCmdQueryPackGuildCmd, self.UpdateCost)
  self:AddListenEvt(ServiceEvent.GuildCmdPackUpdateGuildCmd, self.UpdateCost)
end

function ChangeGuildZoneView:FindObjs()
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.currentZone = self:FindGO("CurrentZone"):GetComponent(UILabel)
  self.contentInput = self:FindGO("ContentInput"):GetComponent(UIInput)
  self.contentInputLabel = self:FindComponent("ContentInputLabel", UILabel, self.contentInput.gameObject)
  UIUtil.LimitInputCharacter(self.contentInput, 8)
  self.changeBtn = self:FindGO("ChangeBtn")
  self.changeBtnLabel = self:FindGO("Label", self.changeBtn):GetComponent(UILabel)
  self.InputLab = self:FindComponent("InputLab", UILabel)
  self.InputLab.text = ZhString.ChangeGuildZone_InputTip
  self.costLabel = self:FindComponent("CostLab", UILabel)
  self.costLabel.text = ZhString.Gem_SecretLand_OptionalView_Cost
  self.costNumLab = self:FindComponent("CostNum", UILabel)
  self.costIcon = self:FindComponent("CostIcon", UISprite)
  self.helpBtn = self:FindGO("HelpButton")
end

local _grayColor = Color(0.21568627450980393, 0.3568627450980392, 0.43137254901960786, 1)

function ChangeGuildZoneView:UpdateCost()
  self.ownCount = GuildProxy.Instance:GetGuildPackItemNumByItemid(self.costID)
  self.costNumLab.text = self.ownCount .. "/" .. self.costNum
  local color = self.ownCount < self.costNum and ColorUtil.Red or _grayColor
  self.costNumLab.color = color
end

function ChangeGuildZoneView:InitCost()
  self.costID = GameConfig.Zone.guild_zone_exchange.cost[1][1]
  self.costNum = GameConfig.Zone.guild_zone_exchange.cost[1][2]
  self.costHour = GameConfig.Zone.guild_zone_exchange.cd // 60
  local itemData = Table_Item[self.costID]
  IconManager:SetItemIcon(itemData.Icon, self.costIcon)
end

function ChangeGuildZoneView:AddEvts()
  self:AddClickEvent(self.changeBtn, function()
    self:ClickChangeBtn()
  end)
end

function ChangeGuildZoneView:InitShow()
  self:RegistShowGeneralHelpByHelpID(32649, self.helpBtn)
  local guildData = GuildProxy.Instance.myGuildData
  self.name.text = string.format(ZhString.ChangeGuildZone_Name, guildData.name)
  self.currentZone.text = ChangeZoneProxy.Instance:ZoneNumToString(guildData.zoneid, ZhString.ChangeGuildZone_Current)
  if guildData.zonetime ~= 0 then
    self.changeBtnLabel.text = ZhString.ChangeZone_CancelChangeGuildLine
    self.contentInput.enabled = false
    self.contentInput.value = ChangeZoneProxy.Instance:ZoneNumToString(GuildProxy.Instance.myGuildData.nextzone)
  else
    self.changeBtnLabel.text = ZhString.ChangeZone_ChangeGuildLine
    self.contentInput.enabled = true
    self.contentInput.defaultText = ZhString.ChangeGuildZone_Default
    self.contentInput.value = ""
  end
end

function ChangeGuildZoneView:ClickChangeBtn()
  local value = self.contentInput.value
  local num
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    local name, id = string.match(value, "(%a+)(%d+)")
    if not name or not id then
      MsgManager.ShowMsgByID(3088)
      return
    end
    num = ChangeZoneProxy.Instance:ZoneStringToNum(value)
  else
    num = ChangeZoneProxy.Instance:ZoneStringToNum(value)
  end
  if GuildProxy.Instance.myGuildData.zonetime == 0 then
    if value == "" then
      MsgManager.ShowMsgByID(3087)
      return
    end
    if num == GuildProxy.Instance.myGuildData.zoneid then
      MsgManager.ShowMsgByID(3084)
      return
    end
    if ChangeZoneProxy.Instance:GetInfos(num) == nil then
      MsgManager.ShowMsgByID(3088)
      return
    end
    if self.ownCount < self.costNum then
      MsgManager.ShowMsgByID(3083)
      return
    end
    MsgManager.ConfirmMsgByID(2261, function()
      self:CallExchangeZoneGuildCmd(num)
    end, nil, nil, tostring(num), string.format(ZhString.Hours, self.costHour))
  else
    MsgManager.ConfirmMsgByID(3090, function()
      self:CallExchangeZoneGuildCmd(num)
    end)
  end
end

function ChangeGuildZoneView:CallExchangeZoneGuildCmd(num)
  ServiceGuildCmdProxy.Instance:CallExchangeZoneGuildCmd(num, GuildProxy.Instance.myGuildData.zonetime == 0)
  LogUtility.InfoFormat("CallExchangeZoneGuildCmd : num : {0} , {1}", tostring(num), tostring(GuildProxy.Instance.myGuildData.zonetime == 0))
  self:CloseSelf()
end

function ChangeGuildZoneView:OnEnter()
  ChangeGuildZoneView.super.OnEnter(self)
  FunctionGuild.Me():QueryGuildItemList()
end
