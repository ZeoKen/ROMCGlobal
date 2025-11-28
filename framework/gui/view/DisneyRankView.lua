autoImport("DisneyRankCell")
autoImport("WrapCellHelper")
autoImport("DisneyQuestListCell")
DisneyRankView = class("DisneyRankView", ContainerView)
DisneyRankView.ViewType = UIViewType.NormalLayer
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail"
}

function DisneyRankView:Init()
  self:FindObjs()
  self:InitView()
  self:AddEvts()
  self:InitData()
end

function DisneyRankView:LoadCellPfb(cName, holderObj)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(holderObj.transform, false)
  return cellpfb
end

function DisneyRankView:FindObjs()
  self.mainTitle = self:FindGO("Title"):GetComponent(UILabel)
  self.leftTime = self:FindGO("LeftTime"):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn")
  local helpID = GameConfig.DisneyChallengeTask[self.activityID].HelpID or 561
  self:TryOpenHelpViewById(helpID, nil, self.helpBtn)
  self.closeBtn = self:FindGO("CloseBtn")
  self:AddClickEvent(self.closeBtn, function(go)
    self:CloseSelf()
  end)
  self.questInfoBtn = self:FindGO("QuestInfoBtn")
  self.questInfoBtn_Icon = self:FindGO("BtnIcon", self.questInfoBtn):GetComponent(UISprite)
  self.questTipPanel = self:FindGO("QuestTips")
  self.questTipTweenScale = self.questTipPanel:GetComponent(TweenScale)
  self.questTipTweenPosition = self.questTipPanel:GetComponent(TweenPosition)
  self.questTipTweenScale:ResetToBeginning()
  self.questTipTweenPosition:ResetToBeginning()
  self.bgCollider = self:FindGO("BgCollider", self.questTipPanel)
  self.rankScrollView = self:FindGO("RankScrollView"):GetComponent(UIScrollView)
  self.rankGrid = self:FindGO("Grid")
  self.playerModelPanel = self:FindGO("PlayerModelPanel")
  self.charModelHolder = self:FindGO("charModelHolder")
  self.charModelTex = self.charModelHolder:GetComponent(UITexture)
  self.playerName = self:FindGO("PlayerName"):GetComponent(UILabel)
  self.playerGuildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.noRank = self:FindGO("NoRankLabel")
  self.noRankLabel = self.noRank:GetComponent(UILabel)
  self.loading = self:FindGO("Loading")
  self.tipinfoPanel = self:FindGO("TipInfoPanel")
  self.questNameLabel = self:FindGO("QuestName"):GetComponent(UILabel)
  self.questDesc = self:FindGO("QuestDesc"):GetComponent(UILabel)
  self.pageInfoLabel = self:FindGO("PageInfoLabel"):GetComponent(UILabel)
  self.questLeftIndicator = self:FindGO("LeftIndicator")
  self.questLeftIndicator_Sprite = self.questLeftIndicator:GetComponent(UISprite)
  self.questRightIndicator = self:FindGO("RightIndicator")
  self.questRightIndicator_Sprite = self.questRightIndicator:GetComponent(UISprite)
  self.nextTipLabel = self:FindGO("NextTipLabel"):GetComponent(UILabel)
  self.firstChallengeInfo = self:FindGO("FirstChallengeInfo"):GetComponent(UILabel)
  self:AddClickEvent(self.questLeftIndicator, function(go)
    self:GoLeft()
  end)
  self:AddClickEvent(self.questRightIndicator, function(go)
    self:GoRight()
  end)
  self.listInfoPanel = self:FindGO("ListInfoPanel")
  self.listScrollView = self:FindGO("ListScrollView"):GetComponent(UIScrollView)
  self.listGrid = self:FindGO("ListGrid"):GetComponent(UITable)
  self.listCtrl = UIGridListCtrl.new(self.listGrid, DisneyQuestListCell, "DisneyQuestListCell")
  local tipTog = self:FindGO("TipTog")
  self.tipTog = tipTog:GetComponent(UIToggle)
  self.tipTog_Sprite = self:FindGO("Icon", tipTog):GetComponent(UISprite)
  local listTog = self:FindGO("ListTog")
  self.listTog = listTog:GetComponent(UIToggle)
  self.listTog_Sprite = self:FindGO("Icon", listTog):GetComponent(UISprite)
  self:AddClickEvent(self.questInfoBtn, function()
    self:UpdateQuestTipShow()
  end)
  self:AddClickEvent(self.bgCollider, function()
    self:UpdateQuestTipShow()
  end)
  self:AddClickEvent(tipTog, function(go)
    if self.maxTipPage == 0 then
      local str = ""
      if 0 < self.leftDay then
        str = string.format(ZhString.DisneyChallengeRefreshTime, self.leftDay, ZhString.ItemTip_DelRefreshTip_Day)
      elseif 0 < self.leftHour then
        str = string.format(ZhString.DisneyChallengeRefreshTime, self.leftHour, ZhString.ItemTip_DelRefreshTip_Hour)
      else
        str = string.format(ZhString.DisneyChallengeRefreshTime, self.leftMin, ZhString.ItemTip_DelRefreshTip_Min)
      end
      MsgManager.FloatMsg(nil, str)
      return
    end
    self:UpdateTipInfo(1)
  end)
  self:AddClickEvent(listTog, function(go)
    self:UpdateTipInfo(2)
  end)
end

function DisneyRankView:InitView()
  local wrapCfg = {
    wrapObj = self.rankGrid,
    pfbNum = 8,
    cellName = "DisneyRankCell",
    control = DisneyRankCell,
    dir = 1,
    disableDragIfFit = false
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapCfg)
  self.itemWrapHelper:AddEventListener(DisneyEvent.RankViewSelectHead, self.HandleClickHead, self)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickRankCell, self)
  self.isShowQuestTip = false
  self:UpdateTipInfo(1)
end

function DisneyRankView:AddEvts()
  self:AddListenEvt(ServiceEvent.DisneyActivityDisneyChallengeTaskRankCmd, self.UpdateRank)
  self:AddListenEvt(ServiceEvent.DisneyActivityDisneyChallengeTaskPointCmd, self.RefreshListInfo)
end

function DisneyRankView:InitData()
  self.playerTipOffset = {-70, 14}
  self.playerTipInitData = {}
  self.curTipInfoPage = 1
  self.curChoosePlayerIndex = 1
  self.activityID = DisneyProxy.Instance:GetCurActivityID()
  xdlog("当前开启的迪士尼挑战id", self.activityID)
  self.maxTipPage, self.leftDay, self.leftHour, self.leftMin = DisneyProxy.Instance:GetMaxTaskTip(self.activityID)
  xdlog("最大页数，剩余天数，剩余小时", self.maxTipPage, self.leftDay, self.leftHour)
  if self.leftDay and self.leftDay > 0 then
    self.nextTipLabel.text = string.format(ZhString.DisneyChallengeNextTip, self.leftDay, ZhString.ItemTip_DelRefreshTip_Day)
  elseif self.leftHour and self.leftHour > 0 then
    self.nextTipLabel.text = string.format(ZhString.DisneyChallengeNextTip, self.leftHour, ZhString.ItemTip_DelRefreshTip_Hour)
  elseif self.leftMin and self.leftMin > 0 then
    self.nextTipLabel.text = string.format(ZhString.DisneyChallengeNextTip, self.leftMin, ZhString.ItemTip_DelRefreshTip_Min)
  else
    self.nextTipLabel.gameObject:SetActive(false)
  end
  local activityName = GameConfig.DisneyChallengeTask[self.activityID].ActivityName
  self.mainTitle.text = activityName or "--"
  local day, hour, min, sec = DisneyProxy.Instance:GetActivityEndTime(self.activityID)
  if day and 0 < day then
    self.leftTime.text = string.format(ZhString.DisneyChallengeHourDes, day)
  else
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(0, 1000, self.RefreshLeftTime, self, 1)
  end
  if self.activityID then
    ServiceDisneyActivityProxy.Instance:CallDisneyChallengeTaskRankCmd(self.activityID)
    ServiceDisneyActivityProxy.Instance:CallDisneyChallengeTaskTipCmd(self.activityID)
    ServiceDisneyActivityProxy.Instance:CallDisneyChallengeTaskPointCmd(self.activityID)
  end
end

function DisneyRankView:RefreshLeftTime()
  local day, hour, min, sec = DisneyProxy.Instance:GetActivityEndTime(self.activityID)
  self.leftTime.text = string.format(ZhString.DisneyChallengeTimeLineDes, hour, min)
  if hour <= 0 and min <= 0 and sec <= 0 then
    self:CloseSelf()
  end
end

function DisneyRankView:UpdateTipInfo(togId)
  if togId == 1 then
    self.tipTog.value = true
    self.tipinfoPanel:SetActive(true)
    self.listInfoPanel:SetActive(false)
    self.tipTog_Sprite.alpha = 1
    self.listTog_Sprite.alpha = 0.4
  elseif togId == 2 then
    self.listTog.value = true
    self.tipinfoPanel:SetActive(false)
    self.listInfoPanel:SetActive(true)
    self.tipTog_Sprite.alpha = 0.4
    self.listTog_Sprite.alpha = 1
  end
end

function DisneyRankView:UpdateRank()
  self.loading:SetActive(false)
  local data = DisneyProxy.Instance.allRankInfo
  self.itemWrapHelper:ResetDatas(data)
  self.itemWrapHelper:ResetPosition()
  if data and next(data) then
    self.noRank:SetActive(false)
    local datas = self.itemWrapHelper:GetDatas()
    if datas then
      local showData = datas[1]
      self:ShowPlayerModel(showData)
      self.playerName.text = showData.name
      self.playerGuildName.text = showData.guildname
    end
    self:UpdateChoose(1)
  else
    self.noRank:SetActive(true)
    local showData = DisneyRankShowData.new(1, nil, DisneyProxy.Instance.rankinAll)
    if showData then
      self:ShowPlayerModel(showData)
      self.playerName.text = showData.name
      self.playerGuildName.text = showData.guildname
    end
  end
  if not self.selfRankCell then
    local go = self:LoadCellPfb("DisneyRankCell", self:FindGO("Container"))
    self.selfRankCell = DisneyRankCell.new(go)
  end
  self.selfRankCell:SetData(DisneyRankShowData.new(1, nil, DisneyProxy.Instance.rankinAll))
  self.selfRankCell:HideBackground()
end

function DisneyRankView:GoLeft()
  if self.curTipInfoPage > 1 then
    self.curTipInfoPage = self.curTipInfoPage - 1
  end
  self:UpdateIndicator()
  self:RefreshTipInfo()
end

function DisneyRankView:GoRight()
  local taskList = DisneyProxy.Instance.challengeTaskList[self.activityID]
  local listNum = #taskList
  if self.curTipInfoPage < self.maxTipPage and listNum > self.curTipInfoPage then
    self.curTipInfoPage = self.curTipInfoPage + 1
  end
  self:UpdateIndicator()
  self:RefreshTipInfo()
end

function DisneyRankView:UpdateIndicator()
  if self.curTipInfoPage <= 1 then
    self.questLeftIndicator_Sprite.alpha = 0.4
  else
    self.questLeftIndicator_Sprite.alpha = 1
  end
  if self.curTipInfoPage >= self.maxTipPage then
    self.questRightIndicator_Sprite.alpha = 0.4
  else
    self.questRightIndicator_Sprite.alpha = 1
  end
end

function DisneyRankView:RefreshTipInfo()
  local taskList = DisneyProxy.Instance.challengeTaskList[self.activityID]
  if taskList then
    local id = taskList[self.curTipInfoPage] or 1
    local config = Table_DisneyChallengeTask[id]
    self.questNameLabel.text = config.QuestName or "任务名还没填"
    self.questDesc.text = config.Tips or "Tip还没填"
    self.pageInfoLabel.text = self.curTipInfoPage .. "/" .. self.maxTipPage
    local challengerList = DisneyProxy.Instance:GetDisneyFirstChallengePlayer(self.activityID)
    local curQuestId = config.QuestId
    if challengerList and challengerList[curQuestId] then
      self.firstChallengeInfo.gameObject:SetActive(true)
      self.firstChallengeInfo.text = string.format(ZhString.DisneyChallengeFirstChallenger, challengerList[curQuestId])
    else
      redlog("没有首通玩家")
      self.firstChallengeInfo.gameObject:SetActive(false)
    end
  else
    redlog("NoTaskList!!!!")
  end
end

function DisneyRankView:RefreshListInfo()
  xdlog("刷新自己挑战情况")
  local taskList = DisneyProxy.Instance.challengeTaskList[self.activityID]
  local myselfChallengeInfo = DisneyProxy.Instance.myselfChallengeInfo[self.activityID]
  local datas = {}
  if taskList then
    for i = 1, #taskList do
      local data = {}
      local id = taskList[i]
      data.config = Table_DisneyChallengeTask[id]
      if myselfChallengeInfo and myselfChallengeInfo[data.config.QuestId] then
        data.score = myselfChallengeInfo[data.config.QuestId]
      end
      table.insert(datas, data)
    end
  end
  self.listCtrl:ResetDatas(datas)
end

function DisneyRankView:HandleClickHead(cellCtl)
  local cellData = cellCtl.data
  if cellCtl == self.curCell or cellData.charID == Game.Myself.data.id then
    FunctionPlayerTip.Me():CloseTip()
    self.curCell = nil
    return
  end
  self.curCell = cellCtl
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellCtl.headIcon.frameSp, NGUIUtil.AnchorSide.TopRight, self.playerTipOffset)
  local player = PlayerTipData.new()
  player:SetByBattlePassRankShowData(cellData)
  TableUtility.TableClear(self.playerTipInitData)
  self.playerTipInitData.playerData = player
  self.playerTipInitData.funckeys = FriendProxy.Instance:IsFriend(cellData.charID) and playerTipFunc_Friend or playerTipFunc
  playerTip:SetData(self.playerTipInitData)
  playerTip:AddIgnoreBound(cellCtl.headIcon.gameObject)
  
  function playerTip.clickcallback(funcData)
    if funcData.key == "SendMessage" then
      self:OnExit()
    end
  end
  
  function playerTip.closecallback()
    self.curCell = nil
  end
end

function DisneyRankView:HandleClickRankCell(cellCtl)
  if cellCtl.data then
    local showData = cellCtl.data
    self:ShowPlayerModel(showData)
    self.playerName.text = showData.name
    self.playerGuildName.text = showData.guildname
    self.curChoosePlayerIndex = showData.rank
  end
  self:UpdateChoose()
end

function DisneyRankView:UpdateChoose()
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    local cell = cells[i]
    if cell.rank == self.curChoosePlayerIndex then
      cell:SetChoose(true)
    else
      cell:SetChoose(false)
    end
  end
end

function DisneyRankView:UpdateQuestTipShow()
  self.isShowQuestTip = not self.isShowQuestTip
  xdlog("IsShow", self.isShowQuestTip)
  if self.isShowQuestTip then
    self.questTipTweenScale:PlayForward()
    self.questTipTweenPosition:PlayForward()
    if self.maxTipPage == 0 then
      self:UpdateTipInfo(2)
    else
      self:UpdateTipInfo(1)
    end
    self:RefreshTipInfo()
    self:UpdateIndicator()
  else
    self.questTipTweenScale:PlayReverse()
    self.questTipTweenPosition:PlayReverse()
  end
  self.questInfoBtn_Icon.spriteName = self.isShowQuestTip and "new_recharge_icon_return" or "new_recharge_icon_detailed"
  self.questInfoBtn_Icon:MakePixelPerfect()
end

function DisneyRankView:ShowPlayerModel(rankShowData)
  if rankShowData then
    local parts = Asset_Role.CreatePartArray()
    local partIndex = Asset_Role.PartIndex
    local partIndexEx = Asset_Role.PartIndexEx
    parts[partIndex.Body] = rankShowData.bodyID or 0
    parts[partIndex.Hair] = rankShowData.hairID or 0
    parts[partIndex.LeftWeapon] = rankShowData.lefthand or 0
    parts[partIndex.RightWeapon] = rankShowData.righthand or 0
    parts[partIndex.Head] = rankShowData.headID or 0
    parts[partIndex.Wing] = rankShowData.back or 0
    parts[partIndex.Face] = rankShowData.faceID or 0
    parts[partIndex.Tail] = rankShowData.tail or 0
    parts[partIndex.Eye] = rankShowData.eyeID or 0
    parts[partIndex.Mount] = rankShowData.mount or 0
    parts[partIndex.Mouth] = rankShowData.mouthID or 0
    parts[partIndexEx.Gender] = rankShowData.gender or 0
    parts[partIndexEx.HairColorIndex] = rankShowData.haircolor or 0
    parts[partIndexEx.EyeColorIndex] = rankShowData.eyecolor or 0
    parts[partIndexEx.BodyColorIndex] = rankShowData.clothcolor or 0
    UIModelUtil.Instance:ChangeBGMeshRenderer("Disney_bg_Roles", self.charModelTex)
    UIModelUtil.Instance:SetRoleModelTexture(self.charModelTex, parts, UIModelCameraTrans.BattlePassRank)
    Asset_Role.DestroyPartArray(parts)
  end
end

function DisneyRankView:OnEnter()
  DisneyRankView.super.OnEnter(self)
end

function DisneyRankView:OnExit()
  DisneyRankView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self, 1)
end
