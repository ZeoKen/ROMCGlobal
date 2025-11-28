autoImport("ItemCell")
ExpRaidDetailView = class("ExpRaidDetailView", BaseView)
ExpRaidDetailView.ViewType = UIViewType.NormalLayer
local btnDisableDuration, jobUpTexName, baseUpTexName = 3000, "fb_icon_jobup", "fb_icon_base"
local expRaidType, expIns

function ExpRaidDetailView:Init()
  if not expRaidType then
    expRaidType = PvpProxy.Type.ExpRaid
    expIns = ExpRaidProxy.Instance
  end
  self:AddListenEvt(ExpRaidEvent.MapViewClose, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.UpdateMatchSuccPanel)
  self:FindObjs()
  self:InitShow()
  self:AddEvents()
end

function ExpRaidDetailView:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.bannerTex = self:FindComponent("Banner", UITexture)
  self.leftLvLabel = self:FindComponent("LeftLvLabel", UILabel)
  self.rightLvLabel = self:FindComponent("RightLvLabel", UILabel)
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.matchButton = self:FindGO("MatchButton")
  self.matchBtn_BoxCollider = self.matchButton:GetComponent(BoxCollider)
  self.enterButton = self:FindGO("EnterButton")
  self.enterButton_BoxCollider = self.enterButton:GetComponent(BoxCollider)
  self.container = self:FindGO("Container")
  self.jobUp = self:FindComponent("JobUp", UITexture)
  self.baseUp = self:FindComponent("BaseUp", UITexture)
  self.tipStick = self:FindComponent("TipStick", UISprite)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.matchSuccPanel = self:FindGO("MatchSuccPanel")
  self.multiplySymbol = self:FindGO("MultiplySymbol")
  self.multiplySymbol_label = self:FindComponent("muLabel", UILabel, self.multiplySymbol.gameObject)
  local bottom = self:FindGO("Bottom")
  self.rewardTitle_normal = self:FindComponent("RewardTitle_normal", UILabel, bottom)
  self.rewardTitle_item = self:FindComponent("RewardTitle_Item", UILabel, bottom)
  self.rewardChooseIcon1 = self:FindComponent("RewardTitleBg", UISprite)
  self.rewardChooseIcon2 = self:FindComponent("RewardTitleBg2", UISprite)
  self.rewardChooseBtn = self:FindGO("RewardChooseBtn")
  self.rewardScrollView = self:FindComponent("RewardScrollView", UIScrollView)
  self.baseActivityGo = self:FindGO("BaseActivity")
end

function ExpRaidDetailView:InitShow()
  local id = self.viewdata.viewdata
  self.id = id
  self.raidData = Table_ExpRaid[id]
  self.titleLabel.text = Table_MapRaid[self.raidData.id].NameZh
  self.descLabel.text = self.raidData.Desc
  self.leftLvLabel.text = string.format(ZhString.ExpRaid_LeftLvLabel, self.raidData.Level)
  self.rightLvLabel.text = string.format(ZhString.ExpRaid_RightLvLabel, self.raidData.RecommendLv[1], self.raidData.RecommendLv[2] or 0)
  self.rewardCtl = UIGridListCtrl.new(self.grid, BagItemCell, "BagItemCell")
  self.expRaidRewardChoose = expIns:GetRewardSetting(self.id)
  self:UpdateRewardToggle()
  self:UpdateRewards()
  self:UpdateMatchSuccPanel()
  self:UpdateBtns()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.fakeTeamMatchData = {
    EnterLevel = self.raidData.Level,
    NoviceCanJoin = 1
  }
end

function ExpRaidDetailView:AddEvents()
  self:AddClickEvent(self.matchButton, function()
    self:OnMatchClick()
  end)
  self:AddClickEvent(self.enterButton, function()
    self:OnEnterClick()
  end)
  self:AddClickEvent(self.jobUp.gameObject, function()
    MsgManager.ShowMsg(nil, ZhString.ExpRaid_JobUpDesc, 1)
  end)
  self:AddClickEvent(self.baseUp.gameObject, function()
    MsgManager.ShowMsg(nil, ZhString.ExpRaid_BaseUpDesc, 1)
  end)
  self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self:AddClickEvent(self.rewardChooseBtn, function()
    self:SaveRewardChoose()
    self:SwitchReward()
    self:UpdateRewards()
  end)
end

function ExpRaidDetailView:HandleClickItem(cellCtl)
  if cellCtl and cellCtl.data then
    self.tipData.itemdata = cellCtl.data
    self:ShowItemTip(self.tipData, self.tipStick, NGUIUtil.AnchorSide.Up)
  end
end

function ExpRaidDetailView:OnEnter()
  ExpRaidDetailView.super.OnEnter(self)
  PictureManager.Instance:SetExpRaid(self.raidData.Banner, self.bannerTex)
  PictureManager.Instance:SetExpRaid(jobUpTexName, self.jobUp)
  PictureManager.Instance:SetExpRaid(baseUpTexName, self.baseUp)
  self:UpdateMultiplyInfo()
  self:UpdateBaseActivityInfo()
end

function ExpRaidDetailView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  ReusableTable.DestroyAndClearArray(self.rewardItemDataList)
  PictureManager.Instance:UnLoadExpRaid(self.raidData.Banner, self.bannerTex)
  PictureManager.Instance:UnLoadExpRaid(jobUpTexName, self.jobUp)
  PictureManager.Instance:UnLoadExpRaid(baseUpTexName, self.baseUp)
  ExpRaidDetailView.super.OnExit(self)
end

function ExpRaidDetailView:OnMatchClick()
  if self.btnClickDisabled then
    return
  end
  local matchStatus = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus then
    MsgManager.ShowMsgByID(25917)
    return
  end
  if not TeamProxy.Instance:CheckMatchValid(self.fakeTeamMatchData) then
    return
  end
  self:TryCheckBattleTimelenAndExpRaidTimes(self.CallMatch)
end

function ExpRaidDetailView:OnEnterClick()
  if self.btnClickDisabled then
    return
  end
  local matchStatus = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus then
    MsgManager.ShowMsgByID(25917)
    return
  end
  if MyselfProxy.Instance:RoleLevel() < self.raidData.Level then
    MsgManager.ShowMsgByID(7301, self.raidData.Level)
    return
  end
  if TeamProxy.Instance:IHaveTeam() then
    if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
      MsgManager.ShowMsgByID(25528)
      return
    end
    local memberListExceptMe = TeamProxy.Instance.myTeam:GetMembersListExceptMe()
    for i = 1, #memberListExceptMe do
      if memberListExceptMe[i].baselv < self.raidData.Level then
        MsgManager.ShowMsgByID(7305, self.raidData.Level)
        return
      end
    end
  end
  self:TryCheckBattleTimelenAndExpRaidTimes(self.CallEnter)
end

function ExpRaidDetailView:UpdateRewards()
  self.rewardItemDataList = ReusableTable.CreateArray()
  if not self.rewardValue then
    local jobItemData = ItemData.new("JobExp", 400)
    local baseItemData = ItemData.new("BaseExp", 300)
    local prestigeData = ItemData.new("Prestige", 750000)
    table.insert(self.rewardItemDataList, jobItemData)
    table.insert(self.rewardItemDataList, baseItemData)
    table.insert(self.rewardItemDataList, prestigeData)
  else
    self:UpdateRewardsByType("NormalReward", self.rewardItemDataList)
  end
  self.rewardCtl:ResetDatas(self.rewardItemDataList)
  self.rewardScrollView:ResetPosition()
end

function ExpRaidDetailView:UpdateRewardsByType(typeString, rewardItemDataList)
  local rewardTeamIds = self.raidData[typeString]
  if not rewardTeamIds or not next(rewardTeamIds) then
    return
  end
  for i = 1, #rewardTeamIds do
    local rewardItemIds = ItemUtil.GetRewardItemIdsByTeamId(rewardTeamIds[i])
    if rewardItemIds and next(rewardItemIds) then
      for _, data in pairs(rewardItemIds) do
        local item = ItemData.new("Reward", data.id)
        table.insert(rewardItemDataList, item)
      end
    end
  end
end

function ExpRaidDetailView:UpdateMatchSuccPanel()
  self.matchSuccPanel:SetActive(expIns:CheckIsMatching())
end

function ExpRaidDetailView:TryCheckBattleTimelenAndExpRaidTimes(succHandler)
  if expIns:CheckBattleTimelenAndRemainingTimes() then
    succHandler(self)
  else
    MsgManager.ConfirmMsgByID(28022, function()
      succHandler(self)
    end)
  end
end

function ExpRaidDetailView:CallMatch()
  self:TryJoinRoom(false)
end

function ExpRaidDetailView:CallEnter()
  self:TryJoinRoom(true)
end

function ExpRaidDetailView:TryJoinRoom(isEnter)
  if self.btnClickDisabled then
    return
  end
  local rewardType
  if not self.rewardValue then
    rewardType = 1
  else
    rewardType = 2
  end
  local raidId = self.raidData.id
  local _teamPy = TeamProxy.Instance
  if not _teamPy:CheckDiffServerValidByPvpType(expRaidType) or _teamPy:ForbiddenByRaidID(raidId) then
    local msg = isEnter and 42042 or 42041
    MsgManager.ShowMsgByID(msg)
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(expRaidType, raidId, nil, isEnter and true or nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, rewardType)
  self.btnClickDisabled = true
  TimeTickManager.Me():CreateOnceDelayTick(btnDisableDuration, function(self)
    self.btnClickDisabled = false
  end, self)
end

function ExpRaidDetailView:UpdateMultiplyInfo()
  local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(AERewardType.EXPRaid)
  if rewardInfo == nil then
    self.multiplySymbol:SetActive(false)
    return
  end
  local multiply = rewardInfo:GetMultiple() or 1
  if 1 < multiply then
    self.multiplySymbol_label.text = "*" .. multiply
    self.multiplySymbol:SetActive(true)
  else
    self.multiplySymbol:SetActive(false)
  end
end

function ExpRaidDetailView:UpdateBaseActivityInfo()
  self.baseActivityGo:SetActive(expIns:CheckShowBaseActivity(self.id))
end

function ExpRaidDetailView:UpdateRewardToggle()
  if self.id then
    self.rewardValue = expIns:GetSingleRewardSetting(self.id)
  end
  self:SwitchReward()
end

local availableColor = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)

function ExpRaidDetailView:SwitchReward()
  if self.rewardValue then
    self.rewardTitle_item.color = availableColor
    ColorUtil.BlackLabel(self.rewardTitle_normal)
    self.rewardChooseIcon1.spriteName = "com_bg_money3"
    self.rewardChooseIcon2.spriteName = "com_bg_property"
  else
    ColorUtil.BlackLabel(self.rewardTitle_item)
    self.rewardTitle_normal.color = availableColor
    self.rewardChooseIcon1.spriteName = "com_bg_property"
    self.rewardChooseIcon2.spriteName = "com_bg_money3"
  end
end

function ExpRaidDetailView:SaveRewardChoose()
  self.rewardValue = not self.rewardValue
  expIns:SaveRewardSetting(self.id)
end

function ExpRaidDetailView:UpdateBtns()
  local remainingCount = expIns:GetExpRaidTimesLeft()
  self.enterButton_BoxCollider.enabled = 0 < remainingCount
  self.matchBtn_BoxCollider.enabled = 0 < remainingCount
  if remainingCount == 0 then
    self:SetTextureGrey(self.enterButton)
    self:SetTextureGrey(self.matchButton)
  else
    self:SetTextureWhite(self.enterButton, LuaGeometry.GetTempColor(0.14901960784313725, 0.24313725490196078, 0.5490196078431373, 1))
    self:SetTextureWhite(self.matchButton, LuaGeometry.GetTempColor(0.14901960784313725, 0.24313725490196078, 0.5490196078431373, 1))
  end
end
