QuestLimitTimeView = class("QuestLimitTimeView", BaseView)
QuestLimitTimeView.ViewType = UIViewType.NormalLayer
autoImport("QuestLimitTaskCell")
autoImport("RewardGridCell")
local _MissionType = {
  [1] = {
    type = "Main",
    Name = ZhString.MapTransmitter_Main
  },
  [2] = {
    type = "Branch",
    Name = ZhString.MapTransmitter_Branch
  },
  [3] = {
    type = "Collection",
    Name = ZhString.MapTransmitter_Collection
  }
}

function QuestLimitTimeView:OnEnter()
  QuestLimitTimeView.super.OnEnter(self)
  PictureManager.Instance:SetUI("mall_twistedegg_bg_bottom", self.bgTexture)
  PictureManager.ReFitFullScreen(self.bgTexture, 1)
  PictureManager.Instance:SetUI(self.bgName, self.replaceBg)
end

function QuestLimitTimeView:OnExit()
  QuestLimitTimeView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI("mall_twistedegg_bg_bottom", self.bgTexture)
  PictureManager.Instance:UnLoadUI(self.bgName, self.replaceBg)
end

function QuestLimitTimeView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitData()
  self:InitShow()
end

function QuestLimitTimeView:FindObjs()
  self.leftTimeLabel = self:FindGO("TimeLimitLabel"):GetComponent(UILabel)
  self.desc = self:FindGO("Desc")
  self.desc = SpriteLabel.new(self.desc, nil, nil, nil, true)
  self.togs = {}
  for i = 1, 3 do
    local go = self:FindGO("Tog" .. i)
    local name = self:FindGO("Name", go):GetComponent(UILabel)
    local process = self:FindGO("Process", go):GetComponent(UILabel)
    local icon = go:GetComponent(UISprite)
    local finishSymbol = self:FindGO("FinishSymbol", go):GetComponent(UISprite)
    name.text = _MissionType[i].Name
    self.togs[i] = {
      go = go,
      name = name,
      process = process,
      icon = icon,
      finishSymbol = finishSymbol
    }
    self:AddClickEvent(go, function()
      self:SwitchToPage(i)
    end)
  end
  self.totalCell = self:FindGO("TotalCell")
  self.totalCell_Name = self:FindGO("Label", self.totalCell):GetComponent(UILabel)
  self.totalCell_Process = self:FindGO("Process", self.totalCell):GetComponent(UILabel)
  self.totalCell_ConfirmBtn = self:FindGO("ConfirmBtn")
  self.totalCell_ConfirmBtnBoxCollider = self.totalCell_ConfirmBtn:GetComponent(BoxCollider)
  self.totalCell_FinishSymbol = self:FindGO("FinishSymbol", self.totalCell)
  self.totalCell_Slider = self:FindGO("Slider", self.totalCell):GetComponent(UISlider)
  local cellContainer = self:FindGO("CellContainer", self.totalCell)
  local cellGO = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("RewardGridCellType2"), cellContainer)
  self.totalCellCtrl = RewardGridCell.new(cellGO)
  self.totalCellCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleShowReward, self)
  self.taskScrollView = self:FindGO("TaskScrollView"):GetComponent(UIScrollView)
  self.taskGrid = self:FindGO("TaskGrid"):GetComponent(UIGrid)
  self.taskCtrl = UIGridListCtrl.new(self.taskGrid, QuestLimitTaskCell, "QuestLimitTaskCell")
  self.taskCtrl:AddEventListener(UICellEvent.OnCellClicked, self.HandleClickTaskEvent, self)
  self.taskCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.HandleClickRewardEvent, self)
  self.taskCtrl:AddEventListener(UICellEvent.OnMidBtnClicked, self.HandleShowReward, self)
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  self.replaceBg = self:FindComponent("Texture", UITexture)
end

function QuestLimitTimeView:AddEvts()
  self:AddClickEvent(self.totalCell_ConfirmBtn, function()
    xdlog("领取全部奖励")
    ServiceActivityCmdProxy.Instance:CallMissionRewardGetRewardCmd(self.actid, nil, true)
  end)
end

function QuestLimitTimeView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdMissionRewardInfoSyncCmd, self.HandleStatusUpdate, self)
end

function QuestLimitTimeView:InitData()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.actid = viewdata and viewdata.actid or 106201
  local actPersonalData = Table_ActPersonalTimer[self.actid]
  self.bgName = actPersonalData and actPersonalData.Misc and actPersonalData.Misc.Texture or "Limitedtime_bg_01"
  local gameConfig = GameConfig.LimitTimeQuestReward and GameConfig.LimitTimeQuestReward[self.actid]
  self.desc:SetText(gameConfig.Desc)
  self.questMap = {}
  local groupData = LimitTimeQuestProxy.Instance:GetMissionStaticData(self.actid)
  for _type, _indexMap in pairs(groupData) do
    if not self.questMap[_type] then
      self.questMap[_type] = {}
    end
    for _index, _staticID in pairs(_indexMap) do
      table.insert(self.questMap[_type], _staticID)
    end
  end
  for i = 1, 3 do
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_MISSION_REWARD, self.togs[i].go, 150, {-15, -15}, nil, self.actid * 100 + i)
  end
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_MISSION_REWARD, self.totalCell_ConfirmBtn, 150, {-15, -15}, nil, self.actid * 100 + 99)
end

function QuestLimitTimeView:InitShow()
  local endTime = LimitTimeQuestProxy.Instance:GetEndTime(self.actid)
  if endTime then
    local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(endTime)
    if 0 < leftDay then
      self.leftTimeLabel.text = string.format(ZhString.FlipCard_RemainDay, leftDay)
    else
      self.leftTimeLabel.text = string.format(ZhString.FlipCard_RemainHour, leftHour)
    end
  else
    self.leftTimeLabel.gameObject:SetActive(false)
  end
  local missionRewardInfo = LimitTimeQuestProxy.Instance:GetMissionRewardInfoByActID(self.actid)
  local finishCountMap = LimitTimeQuestProxy.Instance:GetFinishCountByActID(self.actid)
  local allFinishCount = 0
  local totalCount = 0
  for i = 1, 3 do
    local type = _MissionType[i].type
    local finishData = finishCountMap[type]
    local _finishCount = finishData.finishCount
    local _totalCount = finishData.totalCount
    totalCount = totalCount + _totalCount
    allFinishCount = allFinishCount + _finishCount
    self.togs[i].finishSymbol.gameObject:SetActive(_finishCount == _totalCount)
    self.togs[i].process.gameObject:SetActive(_finishCount < _totalCount)
    self.togs[i].process.text = _finishCount .. "/" .. _totalCount
  end
  self.totalCell_Process.text = allFinishCount .. "/" .. totalCount
  self.totalCell_Slider.value = allFinishCount / totalCount
  if totalCount > allFinishCount then
    self.totalCell_ConfirmBtn:SetActive(true)
    self.totalCell_FinishSymbol:SetActive(false)
    self:SetTextureGrey(self.totalCell_ConfirmBtn)
    self.totalCell_ConfirmBtnBoxCollider.enabled = false
  else
    local isAllFinish = missionRewardInfo and missionRewardInfo.allFinish or false
    if not isAllFinish then
      self.totalCell_ConfirmBtn:SetActive(true)
      self.totalCell_FinishSymbol:SetActive(false)
      self:SetTextureWhite(self.totalCell_ConfirmBtn, LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1))
      self.totalCell_ConfirmBtnBoxCollider.enabled = true
    else
      self.totalCell_FinishSymbol:SetActive(true)
      self.totalCell_ConfirmBtn:SetActive(false)
    end
  end
  local totalReward = self.questMap.AllReward
  if totalReward and totalReward[1] then
    local staticid = totalReward[1]
    local staticData = staticid and Table_MissionReward[staticid]
    local rewards
    local myGender = MyselfProxy.Instance:GetMySex()
    if myGender == 1 then
      rewards = staticData.MaleReward
    else
      rewards = staticData.FeMaleReward
    end
    if rewards and 0 < #rewards then
      local itemData = ItemData.new("Reward", rewards[1][1])
      local _itemData = {
        itemData = itemData,
        num = rewards[1][2]
      }
      self.totalCellCtrl:SetData(_itemData)
    end
  end
  self:SwitchToPage(self.curPageIndex or 1)
end

function QuestLimitTimeView:SwitchToPage(index)
  if not index then
    return
  end
  local typeData = _MissionType[index]
  if not typeData then
    return
  end
  self.curPageIndex = index
  local type = typeData.type
  local result = {}
  local indexs = self.questMap[type]
  for i = 1, #indexs do
    local _tempData = LimitTimeQuestProxy.Instance:GetQuestStatusInfo(indexs[i])
    table.insert(result, _tempData)
  end
  table.sort(result, function(l, r)
    local l_canReward = l.cellStatus == 2 and 1 or 0
    local r_canReward = r.cellStatus == 2 and 1 or 0
    if l_canReward ~= r_canReward then
      return l_canReward > r_canReward
    end
    local l_inProcess = l.cellStatus == 1 and 1 or 0
    local r_inProcess = r.cellStatus == 1 and 1 or 0
    if l_inProcess ~= r_inProcess then
      return l_inProcess > r_inProcess
    end
    local l_isFinish = l.cellStatus == 3 and 1 or 0
    local r_isFinish = r.cellStatus == 3 and 1 or 0
    if l_isFinish ~= r_isFinish then
      return l_isFinish < r_isFinish
    end
    local l_id = l.id
    local r_id = r.id
    if l_id ~= r_id then
      return l_id < r_id
    end
  end)
  self.taskCtrl:ResetDatas(result)
  self.taskScrollView:ResetPosition()
  for i = 1, 3 do
    self.togs[i].icon.spriteName = i == index and "Limitedtime_bth_01" or "Limitedtime_bth_02"
    self.togs[i].name.color = i == index and LuaGeometry.GetTempVector4(0.7019607843137254, 0.4196078431372549, 0.1411764705882353, 1) or LuaGeometry.GetTempVector4(0.24313725490196078, 0.34901960784313724, 0.6549019607843137, 1)
    self.togs[i].process.color = i == index and LuaGeometry.GetTempVector4(0.7019607843137254, 0.4196078431372549, 0.1411764705882353, 1) or LuaGeometry.GetTempVector4(0.24313725490196078, 0.34901960784313724, 0.6549019607843137, 1)
    self.togs[i].finishSymbol.color = i == index and LuaGeometry.GetTempVector4(0.7019607843137254, 0.4196078431372549, 0.1411764705882353, 1) or LuaGeometry.GetTempVector4(0.24313725490196078, 0.4627450980392157, 0.788235294117647, 1)
  end
end

function QuestLimitTimeView:HandleClickTaskEvent(cell)
  xdlog("执行任务事件")
  local data = cell.data
  if not data then
    return
  end
  xdlog("执行任务追踪")
  local questid = data.questid
  local questData = questid and QuestProxy.Instance:getQuestDataByIdAndType(questid)
  if questData then
    FunctionQuest.Me():executeQuest(questData)
    self:CloseSelf()
  else
    redlog("没有指定追踪任务", questid)
  end
end

function QuestLimitTimeView:HandleClickRewardEvent(cell)
  local data = cell.data
  if not data then
    return
  end
  local staticID = data.id
  local staticData = staticID and Table_MissionReward[staticID]
  local index = staticData and staticData.Index
  xdlog("执行单个领奖", self.actid, index)
  ServiceActivityCmdProxy.Instance:CallMissionRewardGetRewardCmd(self.actid, index)
end

function QuestLimitTimeView:HandleStatusUpdate()
  self:InitShow()
end

function QuestLimitTimeView:HandleShowReward(cellCtrl)
  xdlog("显示奖励")
  if cellCtrl and cellCtrl.data then
    local tipData = {
      itemdata = cellCtrl.data.itemData,
      funcConfig = {}
    }
    self:ShowItemTip(tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-300, 0})
  end
end
