autoImport("MiniGameRewardCell")
autoImport("SnakeCoasterManager")
SnakeCoasterEntranceView = class("SnakeCoasterEntranceView", ContainerView)
SnakeCoasterEntranceView.ViewType = UIViewType.NormalLayer
local CoverTexture = "RollerCoaster_bg"
local DifficultyNameKey = {
  [1] = "SnakeCoaster_Difficulty1",
  [2] = "SnakeCoaster_Difficulty2",
  [3] = "SnakeCoaster_Difficulty3"
}
local DATA_FORMAT = "%Y/%m/%d %H:%M:%S"
local GetZh = function(key, default)
  return ZhString and ZhString[key] or default
end

function SnakeCoasterEntranceView:Init()
  self.manager = SnakeCoasterManager.Me()
  self.hasServerInfo = false
  self:FindObjs()
  self:AddEvts()
  self:InitShow()
  self.manager:RequestServerInfo()
end

function SnakeCoasterEntranceView:FindObjs()
  self.gameCover = self:FindGO("gameCover"):GetComponent(UITexture)
  self.helpBtn = self:FindGO("helpBtn")
  self.levelSelector = self:FindGO("levelSelector")
  if self.levelSelector then
    self.levelSelector:SetActive(true)
  end
  local popUpList = self:FindGO("popUpList")
  if popUpList then
    self.popUpList = popUpList:GetComponent(UIPopupList)
  end
  local typeGrid = self:FindGO("typeGrid")
  if typeGrid then
    typeGrid:SetActive(false)
  end
  local rewardGrid = self:FindGO("rewardGrid"):GetComponent(UIGrid)
  self.rewardGridCtrl = UIGridListCtrl.new(rewardGrid, MiniGameRewardCell, "MiniGameRewardCell")
  self.currentLv = self:FindGO("currentLv"):GetComponent(UILabel)
  self.gameLabel = self:FindGO("gameLabel"):GetComponent(UILabel)
  self.rewardStatus = self:FindGO("rewardStatus")
  self.rewardContainer = self:FindGO("RewardContainer")
  self.recordContainer = self:FindGO("RecordContainer")
  self.record = self:FindGO("record", self.recordContainer):GetComponent(UILabel)
  self.recordtime = self:FindGO("recordtime", self.recordContainer):GetComponent(UILabel)
  self.noRecordTip = self:FindGO("noRecordTip")
  self.recordContent = self:FindGO("recordContent")
  local noRecordLabel = self.noRecordTip and self.noRecordTip:GetComponent(UILabel)
  if noRecordLabel then
    noRecordLabel.text = GetZh("SnakeCoaster_NoRecord", "No record")
  end
  self.dailyContainer = self:FindGO("DailyContainer")
  if self.dailyContainer then
    self.dailyContainer:SetActive(false)
  end
  self.enterBtn = self:FindGO("enterBtn")
  self:AddOrRemoveGuideId(self.enterBtn, 574)
  self.enterLabel = self:FindGO("enterLabel"):GetComponent(UILabel)
end

function SnakeCoasterEntranceView:AddEvts()
  self:AddClickEvent(self.enterBtn, function()
    self:CallEnter()
  end)
  if self.helpBtn then
    local helpID = self:GetHelpID()
    if helpID then
      self:RegistShowGeneralHelpByHelpID(helpID, self.helpBtn)
    else
      self.helpBtn:SetActive(false)
    end
  end
  self.rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickItemCell, self)
  if self.popUpList then
    EventDelegate.Add(self.popUpList.onChange, function()
      self:OnDifficultyPopChange()
    end)
  end
  self:AddListenEvt(SnakeCoasterEvent.InfoUpdate, self.InitShow)
  self:AddListenEvt(SnakeCoasterEvent.StartResult, self.HandleStartResult)
  self:AddListenEvt(SnakeCoasterEvent.StateUpdate, self.HandleStateUpdate)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:AddClickEvent(self:FindGO("rankBtn"), function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SnakeCoasterRankPopUp
    })
  end)
end

function SnakeCoasterEntranceView:GetHelpID()
  local snakeConfig = GameConfig.SnakeCoaster
  return snakeConfig and (snakeConfig.HelpID or snakeConfig.helpID)
end

function SnakeCoasterEntranceView:GetDifficultyUIConfig(difficulty)
  local snakeConfig = GameConfig.SnakeCoaster
  local clientUI = snakeConfig and (snakeConfig.ClientUI or snakeConfig.clientUI)
  if clientUI then
    return clientUI[difficulty] or clientUI[tostring(difficulty)]
  end
  return self.manager:GetDifficultyConfig(difficulty)
end

function SnakeCoasterEntranceView:GetDifficultyConfig(difficulty)
  local snakeConfig = GameConfig.SnakeCoaster
  local difficulties = snakeConfig and snakeConfig.Difficulties
  if difficulties then
    return difficulties[difficulty] or difficulties[tostring(difficulty)]
  end
end

function SnakeCoasterEntranceView:GetFirstPassRewardID(difficulty)
  local config = self:GetDifficultyConfig(difficulty)
  return config and (config.FirstPassRewardID or config.firstPassRewardID) or 0
end

function SnakeCoasterEntranceView:GetDifficultyMaxScore(difficulty)
  local config = self:GetDifficultyConfig(difficulty)
  return config and (config.MaxScore or config.max_score) or 0
end

function SnakeCoasterEntranceView:GetDifficultyName(difficulty)
  local config = self:GetDifficultyUIConfig(difficulty)
  return config and (config.Name or config.NameZh or config.name) or GetZh(DifficultyNameKey[difficulty], string.format("Difficulty %s", tostring(difficulty)))
end

function SnakeCoasterEntranceView:GetCoverTexture(difficulty)
  return CoverTexture
end

function SnakeCoasterEntranceView:IsEntranceDifficultyVisible(difficulty)
  if difficulty == nil then
    return false
  end
  local config = self:GetDifficultyUIConfig(difficulty)
  if config ~= nil then
    if config.ShowInEntrance ~= nil then
      return config.ShowInEntrance == true
    end
    if config.showInEntrance ~= nil then
      return config.showInEntrance == true
    end
    if config.HideInEntrance ~= nil then
      return config.HideInEntrance ~= true
    end
    if config.hideInEntrance ~= nil then
      return config.hideInEntrance ~= true
    end
    if config.ShowInUI ~= nil then
      return config.ShowInUI == true
    end
    if config.showInUI ~= nil then
      return config.showInUI == true
    end
  end
  return 1 <= difficulty and difficulty <= 3
end

function SnakeCoasterEntranceView:BuildLocalDifficultyInfos()
  local snakeConfig = GameConfig.SnakeCoaster
  local difficulties = snakeConfig and snakeConfig.Difficulties
  local infos = {}
  if difficulties == nil then
    return infos
  end
  for difficulty, config in pairs(difficulties) do
    local numericDifficulty = tonumber(difficulty) or difficulty
    if self:IsEntranceDifficultyVisible(numericDifficulty) then
      infos[#infos + 1] = {
        difficulty = numericDifficulty,
        unlocked = config.Unlocked ~= false and config.unlocked ~= false,
        rewardid = self:GetFirstPassRewardID(numericDifficulty),
        first_rewarded = config.FirstRewarded == true or config.first_rewarded == true,
        max_score = self:GetDifficultyMaxScore(numericDifficulty)
      }
    end
  end
  return infos
end

function SnakeCoasterEntranceView:BuildDifficultyDatas()
  local infos = self.manager:GetServerInfos() or {}
  if #infos == 0 then
    infos = self:BuildLocalDifficultyInfos()
  end
  local datas = {}
  for i = 1, #infos do
    local info = infos[i]
    if info and info.difficulty and self:IsEntranceDifficultyVisible(info.difficulty) then
      local difficulty = info.difficulty
      local viewInfo = {}
      for key, value in pairs(info) do
        viewInfo[key] = value
      end
      viewInfo.rewardid = self:GetFirstPassRewardID(difficulty)
      viewInfo.max_score = self:GetDifficultyMaxScore(difficulty)
      datas[#datas + 1] = {
        id = difficulty,
        name = self:GetDifficultyName(difficulty),
        info = viewInfo
      }
    end
  end
  table.sort(datas, function(a, b)
    return (a.id or 0) < (b.id or 0)
  end)
  return datas
end

function SnakeCoasterEntranceView:IsFirstPassRewarded(info)
  if info == nil then
    return false
  end
  return info.first_rewarded == true or info.first_pass_rewarded == true or info.firstPassRewarded == true or info.rewarded == true or info.first_pass_reward == true
end

function SnakeCoasterEntranceView:RefreshDifficultySelector(datas)
  self.difficultyDatas = datas
  self.difficultyDataMap = {}
  if not self.popUpList then
    return
  end
  self.ignoreDifficultyPopChange = true
  self.popUpList:Clear()
  for i = 1, #datas do
    self.difficultyDataMap[datas[i].name] = datas[i]
    self.popUpList:AddItem(datas[i].name, datas[i])
  end
  if 0 < #datas then
    self.popUpList.value = datas[1].name
  else
    self.popUpList.value = ""
  end
  self.ignoreDifficultyPopChange = false
end

function SnakeCoasterEntranceView:InitShow(note)
  if note ~= nil then
    self.hasServerInfo = true
  end
  local datas = self:BuildDifficultyDatas()
  if 0 < #datas then
    self.hasServerInfo = true
  end
  self:RefreshDifficultySelector(datas)
  if #datas == 0 then
    self.currentType = nil
    self.gameLabel.text = ""
    self.currentLv.text = self.hasServerInfo and GetZh("SnakeCoaster_NotOpen", "Not open") or GetZh("SnakeCoaster_Loading", "Loading...")
    self.rewardGridCtrl:ResetDatas({})
    self.rewardContainer:SetActive(false)
    self:SetRecord()
    self:SetEnterActive(false)
    return
  end
  local currentData
  for i = 1, #datas do
    if datas[i].id == self.currentType then
      currentData = datas[i]
      break
    end
  end
  self:SelectDifficulty(currentData or datas[1])
end

function SnakeCoasterEntranceView:OnDifficultyPopChange()
  if self.ignoreDifficultyPopChange or not self.popUpList then
    return
  end
  local data = not self.popUpList.data and self.difficultyDataMap and self.difficultyDataMap[self.popUpList.value]
  if not data then
    return
  end
  self:SelectDifficulty(data)
end

function SnakeCoasterEntranceView:SelectDifficulty(data)
  if not data then
    return
  end
  if self.popUpList and self.popUpList.value ~= data.name then
    self.ignoreDifficultyPopChange = true
    self.popUpList.value = data.name
    self.ignoreDifficultyPopChange = false
  end
  self.currentType = data.id
  self.currentInfo = data.info
  self:SetUpUI(data)
end

function SnakeCoasterEntranceView:SetUpUI(data)
  local info = data.info
  local difficulty = data.id
  if self.pic and self.pic ~= self:GetCoverTexture(difficulty) then
    PictureManager.Instance:UnLoadUI(self.pic, self.gameCover)
  end
  self.pic = self:GetCoverTexture(difficulty)
  PictureManager.Instance:SetUI(self.pic, self.gameCover)
  self.gameLabel.text = ""
  self:SetReward(info, difficulty)
  self:SetRecord()
  self.currentLv.text = string.format("难度： %d分", self:GetDifficultyMaxScore(difficulty))
  if info and not info.unlocked then
    self:SetEnterActive(false)
  elseif info then
    self:SetEnterActive(true)
  else
    self.currentLv.text = GetZh("SnakeCoaster_NotOpen", "Not open")
    self:SetEnterActive(false)
  end
end

function SnakeCoasterEntranceView:SetReward(info, difficulty)
  local rewardDatas = {}
  local rewardId = self:GetFirstPassRewardID(difficulty or info and info.difficulty)
  if rewardId and rewardId ~= 0 then
    local items = ItemUtil.GetRewardItemIdsByTeamId(rewardId) or {}
    for i = 1, #items do
      local item = items[i]
      rewardDatas[#rewardDatas + 1] = {
        itemid = item.id or item.itemid or item[1],
        num = item.num or item.count or item[2] or 1
      }
    end
  end
  self.rewardGridCtrl:ResetDatas(rewardDatas)
  self.rewardContainer:SetActive(0 < #rewardDatas)
  if self.rewardStatus then
    self.rewardStatus:SetActive(self:IsFirstPassRewarded(info))
  end
end

function SnakeCoasterEntranceView:SetRecord()
  local record = self.manager:GetServerRecord()
  local score = record and record.score or 0
  self.recordContent:SetActive(score ~= nil and 0 < score)
  self.noRecordTip:SetActive(score == nil or score <= 0)
  if self.gameLabel then
    self.gameLabel.gameObject:SetActive(score ~= nil and 0 < score)
  end
  self.recordContainer:SetActive(true)
  if score and 0 < score then
    self.record.text = tostring(score)
    self.recordtime.text = record.timestamp and 0 < record.timestamp and os.date(DATA_FORMAT, record.timestamp) or ""
  end
end

function SnakeCoasterEntranceView:SetEnterActive(active)
  self.disableEnter = not active
  self.enterLabel.text = active and GetZh("SnakeCoaster_StartGame", "Start") or GetZh("SnakeCoaster_StartLocked", "Locked")
  if active then
    self:SetTextureWhite(self.enterBtn, ColorUtil.ButtonLabelGreen)
  else
    self:SetTextureGrey(self.enterBtn)
  end
end

function SnakeCoasterEntranceView:CallEnter()
  if (Game.Myself.handInHandAction or 0) ~= 0 then
    MsgManager.ShowMsgByID(856)
    return
  end
  if self.disableEnter then
    if self.currentInfo and not self.currentInfo.unlocked then
      MsgManager.FloatMsg("", GetZh("SnakeCoaster_LockedTip", "Locked"))
    end
    return
  end
  if not self.currentType then
    return
  end
  self.disableEnter = true
  self.waitingEnterReply = true
  self.enterLabel.text = GetZh("SnakeCoaster_Loading", "Loading...")
  self:SetTextureGrey(self.enterBtn)
  if not self.manager:RequestServerStart(self.currentType) then
    self.waitingEnterReply = false
    self:SetEnterActive(self.currentInfo ~= nil and self.currentInfo.unlocked == true)
  end
end

function SnakeCoasterEntranceView:HandleStartResult(note)
  local data = note and note.body or note
  if not data then
    return
  end
  if data.errcode ~= nil and data.errcode ~= 0 then
    self.waitingEnterReply = false
    MsgManager.FloatMsg("", self:GetErrMsg(data.errcode))
    self:SetEnterActive(self.currentInfo ~= nil and self.currentInfo.unlocked == true)
    return
  end
  self.waitingEnterReply = false
  self:CloseSelf()
end

function SnakeCoasterEntranceView:HandleStateUpdate(note)
  if not self.waitingEnterReply then
    return
  end
  local data = note and note.body or note
  if not data then
    return
  end
  self.waitingEnterReply = false
  self:CloseSelf()
end

function SnakeCoasterEntranceView:GetErrMsg(errcode)
  if errcode == FuBenCmd_pb.ESNAKECOASTER_ERROR_CONFIG then
    return GetZh("SnakeCoaster_ErrorConfig", "Config error")
  elseif errcode == FuBenCmd_pb.ESNAKECOASTER_ERROR_LOCKED then
    return GetZh("SnakeCoaster_LockedTip", "Locked")
  elseif errcode == FuBenCmd_pb.ESNAKECOASTER_ERROR_RAID then
    return GetZh("SnakeCoaster_ErrorRaid", "Raid error")
  elseif errcode == FuBenCmd_pb.ESNAKECOASTER_ERROR_STATE then
    return GetZh("SnakeCoaster_ErrorState", "State error")
  elseif errcode == FuBenCmd_pb.ESNAKECOASTER_ERROR_SCORE then
    return GetZh("SnakeCoaster_ErrorScore", "Score error")
  end
  return GetZh("SnakeCoaster_ErrorUnknown", "Start failed")
end

function SnakeCoasterEntranceView:ClickItemCell(cell)
  local itemid = cell.itemid
  if not itemid then
    self:ShowItemTip()
    return
  end
  local sdata = {
    itemdata = ItemData.new("", itemid),
    funcConfig = {},
    hideGetPath = true
  }
  self:ShowItemTip(sdata, cell.icon, NGUIUtil.AnchorSide.Left, {-212, 0})
end

function SnakeCoasterEntranceView:OnExit()
  if self.pic then
    PictureManager.Instance:UnLoadUI(self.pic, self.gameCover)
  end
  SnakeCoasterEntranceView.super.OnExit(self)
end
