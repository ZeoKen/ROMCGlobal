autoImport("DisneyActivityOverviewCell")
autoImport("BagItemNewCell")
DisneyActivityOverview = class("DisneyActivityOverview", ContainerView)
DisneyActivityOverview.ViewType = UIViewType.NormalLayer
local _DisneyStageProxy = DisneyStageProxy.Instance
local _PictureMrg = PictureManager.Instance
local _QuestIns = QuestProxy.Instance
local _QuestSubmitType = SceneQuest_pb.EQUESTLIST_SUBMIT
local _QuestAcceptType = SceneQuest_pb.EQUESTLIST_ACCEPT
local _PageType = {
  active = 1,
  payable = 2,
  daily = 3,
  count = 3
}
local _pageHelpFunc = function(data)
  local desc = data:GetHelpDesc()
  if desc then
    TipsView.Me():ShowGeneralHelp(desc)
  end
end
local _bgTex = "Disney_Comics_bg_show"
local _dailyCount = 5
local _mickeyRewardCount = 3
local _zhGoStr = {
  ZhString.DisneyOverview_QuestAccept,
  ZhString.DisneyOverview_QuestComplete,
  ZhString.DisneyOverview_Time_Closed,
  ZhString.ActivityData_GoLabelText
}
local tempV3 = LuaVector3()
local _MickeyReward_status_cfg = {
  bg = {
    "new_email_icon_gift_a",
    "new_email_icon_gift_b",
    "new_email_icon_gift_a"
  },
  lab = {
    ZhString.DisneyOverview_MickeyReward_EUnfinished,
    ZhString.DisneyOverview_MickeyReward_EReceived,
    ZhString.DisneyOverview_MickeyReward_ECanReceive
  },
  labEffectColor = {
    "8e91b0",
    "8e91b0",
    "d38159"
  },
  labColor = {
    "8e91b0",
    "8e91b0",
    "fff297"
  }
}
local _ParseColor = function(hexStr)
  local success, c = ColorUtil.TryParseHexString(hexStr)
  if success then
    return c
  end
end
local _UpdateMickeyRewardItem = function(cell, status)
  local bg, lab, rewardbg = cell.bg, cell.lab, cell.rewardBg
  cell.status = status
  bg.spriteName = _MickeyReward_status_cfg.bg[status]
  bg.color = _ParseColor(_MickeyReward_status_cfg.labColor[status])
  lab.text = _MickeyReward_status_cfg.lab[status]
  lab.effectColor = _ParseColor(_MickeyReward_status_cfg.labEffectColor[status])
  rewardbg:SetActive(status == DisneyStageProxy.EMickeyRewardStatus.ECanReceive)
end
local _UpdatePageBaseFunc = function(texture, nameLab, descLab, timeLab, timeLabBg, helpBtn, activity_data)
  _PictureMrg:SetActivityTexture(activity_data.staticData.Texture, texture)
  nameLab.text = activity_data.staticData.Name
  descLab.text = activity_data.staticData.Context
  timeLab.text = ClientTimeUtil.GetTimeDate(activity_data.startTime, activity_data.endTime, ZhString.DisneyOverview_Time)
  timeLabBg.width = timeLab.width + 20
  helpBtn:SetActive(nil ~= activity_data:GetHelpDesc())
end
local _CallGotoMode = function(view, id)
  if type(id) == "table" and #id == 1 and id[1] == "Recharge" then
    FunctionNewRecharge.Instance():OpenUIDefaultPage()
    return
  end
  FuncShortCutFunc.Me():CallByID(id)
  view:CloseSelf()
end

function DisneyActivityOverview:Init()
  self:FindObj()
  self:AddEvent()
  self:InitUpdateFunc()
  self:InitView()
end

function DisneyActivityOverview:InitUpdateFunc()
  self.PageUpdateFunc = {
    [1] = self._UpdateActivePage,
    [2] = self._UpdatePayablePage,
    [3] = self._UpdateDailyPage
  }
end

function DisneyActivityOverview:FindObj()
  self.titleLab = self:FindComponent("FixedTitle", UILabel)
  self.bgPoint = self:FindComponent("BgPoint", UISprite, self.titleLab.gameObject)
  self.activityHelpBtn = self:FindComponent("ActivityHelpBtn", UISprite, self.titleLab.gameObject)
  self.bgTex = self:FindComponent("BgTex", UITexture)
  local wrap = self:FindGO("WrapContent")
  local wrapConfig = {
    wrapObj = wrap,
    cellName = "DisneyActivityOverviewCell",
    control = DisneyActivityOverviewCell
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.OnClickActivityCell, self)
  self.mickeyRewardSlider = self:FindComponent("RewardSlider", UISlider)
  self.mickeyRewardNumLab = self:FindComponent("MikeyRewardNum", UILabel)
  self.mickeyRewardSp = self:FindComponent("mikeyRewardNum", UISprite)
  self.mickeyRewardTip = self:FindGO("MickeyRewardTip")
  self.mickeyRewardTipDesc = self:FindComponent("Label", UILabel, self.mickeyRewardTip)
  self.mickeyRewardTipGrid = self:FindComponent("Grid", UIGrid, self.mickeyRewardTip)
  self.mickeyRewardTipGridCtl = UIGridListCtrl.new(self.mickeyRewardTipGrid, BagItemNewCell, "BagItemNewCell")
  self.mickeyRewardTipGridCtl:AddEventListener(MouseEvent.MouseClick, self.ClickRewardItem, self)
end

function DisneyActivityOverview:AddEvent()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.DisneyActivityQueryDisneyGuideInfoCmd, self.UpdateInfoView)
  self:AddListenEvt(ServiceEvent.DisneyActivityReceiveMickeyRewardCmd, self._UpdateMickey)
  self:AddListenEvt(ServiceEvent.DisneyActivityReceiveGuideRewardCmd, self.UpdateCurGuideState)
  self:AddListenEvt(DisneyEvent.DisneyGuideShutDown, self.OnActiveShutDown)
end

function DisneyActivityOverview:OnActiveShutDown()
  MsgManager.ShowMsgByID(41346)
  self:CloseSelf()
end

function DisneyActivityOverview:InitView()
  self.typePage = {}
  for i = 1, _PageType.count do
    self.typePage[i] = self:FindGO("Type" .. i)
  end
  self.mickeyReward = {}
  local parent
  for i = 1, _mickeyRewardCount do
    local cell_daily = ReusableTable.CreateTable()
    parent = self:FindGO("MikeyReward" .. i)
    cell_daily.bg = parent:GetComponent(UISprite)
    cell_daily.lab = self:FindComponent("Lab", UILabel, parent)
    cell_daily.rewardBg = self:FindGO("RewardBg", parent)
    cell_daily.effContainer = self:FindGO("RewardEffectContainer", parent)
    cell_daily.index = i
    self.mickeyReward[i] = cell_daily
    self:AddClickEvent(parent, function(go)
      self:OnClickMickeyReward(i)
    end)
  end
  self.titleLab.text = _DisneyStageProxy:GetDisneyTitle()
  self.bgPoint.width = self.titleLab.width + 30
  local bubbleEffectContainer = self:FindGO("BubbleEffectContainer")
  self:PlayUIEffect(EffectMap.UI.DisneyBubble, bubbleEffectContainer)
  if self.activityHelpBtn then
    self:Hide(self.activityHelpBtn)
  end
  self.mickeyRewardSp.spriteName = _DisneyStageProxy:GetDisneyGuideRewardSp()
end

function DisneyActivityOverview:UpdateCurGuideState(note)
  local actID = note.body and note.body.mickey_reward_id
  if not actID then
    return
  end
  local cells = self.wraplist:GetCellCtls()
  if not cells then
    return
  end
  for i = 1, #cells do
    if cells[i].data.id == actID then
      cells[i]:UpdateMickeyState()
      break
    end
  end
end

function DisneyActivityOverview:OnClickActivityCell(cellCtl, isFirst)
  local data = cellCtl and cellCtl.data
  if data then
    if data:IsComming() then
      return
    end
    self.curActivityData = data
    self:UpdateInfoView()
    if not isFirst then
      _DisneyStageProxy:CallReceiveGuideReward(data)
    end
  end
end

local rewards = {}

function DisneyActivityOverview:UpdateInfoView()
  self.wraplist:ResetDatas(_DisneyStageProxy:GetOverviewActivity())
  local cur = self.curActivityData
  if not cur then
    return
  end
  self:_UpdateMickey()
  local t = cur.staticData.Type
  for k, go in pairs(self.typePage) do
    go:SetActive(k == t)
  end
  local func = self.PageUpdateFunc[t]
  if func then
    func(self, cur)
  end
  self:SetChooseAct(cur.id)
end

function DisneyActivityOverview:SetChooseAct(id)
  local cells = self.wraplist:GetCellCtls()
  for i = 1, #cells do
    cells[i]:SetChooseId(id)
  end
end

local _tipPos = {
  [1] = {
    -170,
    -182,
    0
  },
  [2] = {
    172,
    -182,
    0
  },
  [3] = {
    485,
    -182,
    0
  }
}

function DisneyActivityOverview:OnClickMickeyReward(i)
  LuaVector3.Better_Set(tempV3, _tipPos[i][1], _tipPos[i][2], _tipPos[i][3])
  local data = _DisneyStageProxy:GetMickeyRewardList(i)
  if not data or data.status ~= DisneyStageProxy.EMickeyRewardStatus.ECanReceive then
    self:Show(self.mickeyRewardTip)
    self.mickeyRewardTip.transform.localPosition = tempV3
    local mickeyRewards = _DisneyStageProxy.mickeyRewardsCfg[data.num]
    self.mickeyRewardTipDesc.text = string.format(_DisneyStageProxy:GetMickyRewardTipDesc(), data.num)
    self.mickeyRewardTipGridCtl:ResetDatas(mickeyRewards)
    return
  end
  _DisneyStageProxy:DoReceiveMickeyReward(data.num)
end

function DisneyActivityOverview:_UpdateMickey()
  local all = _DisneyStageProxy:GetAllMickeyNum()
  if all == 0 then
    return
  end
  local cur = _DisneyStageProxy:GetMickeyNum()
  self.mickeyRewardSlider.value = cur / all
  self.mickeyRewardNumLab.text = cur .. "/" .. all
  for i = 1, _mickeyRewardCount do
    local data = _DisneyStageProxy:GetMickeyRewardList(i)
    if data then
      local cell = self.mickeyReward[i]
      _UpdateMickeyRewardItem(cell, data.status)
      self:SetRewardEffTip(cell)
    end
  end
end

function DisneyActivityOverview:SetRewardEffTip(cell)
  self.rewardTipEffs = self.rewardTipEffs or {}
  local i = cell.index
  if cell.status == DisneyStageProxy.EMickeyRewardStatus.ECanReceive then
    if nil == self.rewardTipEffs[i] then
      self:PlayUIEffect(EffectMap.UI.DisneySliderReward, cell.effContainer, false, function(obj, args, assetEffect)
        self.rewardTipEffs[i] = assetEffect
        self.rewardTipEffs[i]:SetActive(true)
      end)
    else
      self.rewardTipEffs[i]:SetActive(true)
    end
  elseif self.rewardTipEffs[i] then
    self.rewardTipEffs[i]:SetActive(false)
  end
end

function DisneyActivityOverview:_UpdateActivePage(data)
  if not self._initActivePage then
    self:_InitActivePage(data)
    self._initActivePage = true
  end
  self:AddClickEvent(self.active_GoBtn, function(go)
    _CallGotoMode(self, data.staticData.GotoMode)
  end)
  self:AddClickEvent(self.active_TipSp, function(go)
    _pageHelpFunc(data)
  end)
  _UpdatePageBaseFunc(self.active_Tex, self.active_Name, self.active_Desc, self.active_Time, self.active_Time_Bg, self.active_TipSp, data)
  local rewards = data:GetRewards()
  self.active_rewardCtl:ResetDatas(rewards)
  self.active_rewardCtl:ResetPosition()
  self.active_GoBtn:SetActive(_DisneyStageProxy:CheckGoModelCanShow(data))
end

function DisneyActivityOverview:_UpdatePayablePage(data)
  if not self._initPayablePage then
    self:_InitPayablePage(data)
    self._initPayablePage = true
  end
  self:AddClickEvent(self.payable_GoBtn, function(go)
    _CallGotoMode(self, data.staticData.GotoMode)
  end)
  self:AddClickEvent(self.payable_TipSp, function(go)
    _pageHelpFunc(data)
  end)
  self.payable_GoBtn:SetActive(_DisneyStageProxy:CheckGoModelCanShow(data))
  _UpdatePageBaseFunc(self.payable_Tex, self.payable_Name, self.payable_Desc, self.payable_Time, self.payable_Time_Bg, self.payable_TipSp, data)
  self.payableTipArrow:UpdateAnchors()
end

function DisneyActivityOverview:_UpdateDailyPage(data)
  if not self._initDailyPage then
    self:_InitDailyPage(data)
    self._initDailyPage = true
  end
  _UpdatePageBaseFunc(self.daily_Tex, self.daily_Name, self.daily_Desc, self.daily_Time, self.daily_Time_Bg, self.daily_TipSp, data)
end

function DisneyActivityOverview:_InitActivePage(data)
  local parent = self.typePage[1]
  if not parent then
    return
  end
  self.active_Tex = parent:GetComponent(UITexture)
  self.active_TexName = data.staticData.Texture
  self.active_Name = self:FindComponent("NameLab", UILabel, parent)
  self.active_Desc = self:FindComponent("DescLab", UILabel, parent)
  self.active_Time = self:FindComponent("TimeLab", UILabel, parent)
  self.active_Time_Bg = self:FindComponent("Sprite", UISprite, self.active_Time.gameObject)
  self.active_Reward_Tip = self:FindComponent("RewardDescLab", UILabel, parent)
  self.active_Reward_Tip.text = ZhString.DisneyOverview_Reward_Tip
  self.active_GoBtn = self:FindGO("GoBtn", parent)
  self.active_GoBtnLab = self:FindComponent("Lab", UILabel, self.active_GoBtn)
  self.active_GoBtnLab.text = _zhGoStr[4]
  self.active_TipSp = self:FindGO("TipSp", parent)
  self.active_rewardGrid = self:FindComponent("RewardGrid", UIGrid)
  self.active_rewardCtl = UIGridListCtrl.new(self.active_rewardGrid, BagItemNewCell, "BagItemNewCell")
  self.active_rewardCtl:AddEventListener(MouseEvent.MouseClick, self.ClickRewardItem, self)
end

function DisneyActivityOverview:_InitPayablePage(data)
  local parent = self.typePage[2]
  if not parent then
    return
  end
  self.payable_Tex = parent:GetComponent(UITexture)
  self.payable_TexName = data.staticData.Texture
  self.payable_Name = self:FindComponent("NameLab", UILabel, parent)
  self.payableTipArrow = self:FindComponent("TipSp", UISprite, self.payable_Name.gameObject)
  self.payable_Desc = self:FindComponent("DescLab", UILabel, parent)
  self.payable_Time = self:FindComponent("TimeLab", UILabel, parent)
  self.payable_Time_Bg = self:FindComponent("Sprite", UISprite, self.payable_Time.gameObject)
  self.payable_GoBtn = self:FindGO("GoBtn", parent)
  self.payable_GoBtnLab = self:FindComponent("Lab", UILabel, self.payable_GoBtn)
  self.payable_GoBtnLab.text = _zhGoStr[4]
  self.payable_TipSp = self:FindGO("TipSp", parent)
end

function DisneyActivityOverview:_InitDailyPage(data)
  local parent = self.typePage[3]
  if not parent then
    return
  end
  self.daily_Tex = parent:GetComponent(UITexture)
  self.daily_TexName = data.staticData.Texture
  self.daily_Name = self:FindComponent("NameLab", UILabel, parent)
  self.daily_Desc = self:FindComponent("DescLab", UILabel, parent)
  self.daily_Time = self:FindComponent("TimeLab", UILabel, parent)
  self.daily_Time_Bg = self:FindComponent("Sprite", UISprite, self.daily_Time.gameObject)
  self.daily_TipSp = self:FindGO("TipSp", parent)
  self:AddClickEvent(self.daily_TipSp, function(go)
    _pageHelpFunc(data)
  end)
  self.dailyInfo = {}
  local yAxisOffset
  local todayIndex = 0
  for i = 1, _dailyCount do
    local questId = data.staticData.Param[i]
    if nil == _QuestIns:getQuestDataFromCityScope(questId, _QuestSubmitType) then
      if nil ~= _QuestIns:getQuestDataFromCityScope(questId, _QuestAcceptType) then
        todayIndex = i
        break
      end
      todayIndex = i - 1
      break
    end
  end
  for i = 1, _dailyCount do
    local parent = self:FindGO("Day" .. i)
    local cell_daily = ReusableTable.CreateTable()
    cell_daily.rewardRoot = self:FindGO("Reward", parent)
    cell_daily.reward2Root = self:FindGO("Reward2", parent)
    cell_daily.normalPos = self:FindGO("Normal", parent)
    cell_daily.normalBg = self:FindComponent("Bg", UISprite, cell_daily.normalPos)
    cell_daily.todayPos = self:FindGO("Today", parent)
    cell_daily.todayGoLab = self:FindComponent("GoLab", UILabel, cell_daily.todayPos)
    cell_daily.todayGoColider = self:FindComponent("Sprite", BoxCollider, cell_daily.todayPos)
    cell_daily.completeFlag = self:FindGO("Completed", cell_daily.rewardRoot)
    local questId = data.staticData.Param[i]
    local hasComplete = nil ~= _QuestIns:getQuestDataFromCityScope(questId, _QuestSubmitType)
    local hasAccept = nil ~= _QuestIns:getQuestDataFromCityScope(questId, _QuestAcceptType)
    local idToday = i == todayIndex
    cell_daily.completeFlag:SetActive(hasComplete and not idToday)
    self:AddClickEvent(cell_daily.todayGoColider.gameObject, function(go)
      if idToday then
        _CallGotoMode(self, data.staticData.GotoMode[i])
      end
    end)
    local xAxisOffset = i == _dailyCount and -37 or 0
    local xAxisOffset2 = i == _dailyCount and 39 or 0
    local reward1, reward2 = BagItemNewCell.new(cell_daily.rewardRoot)
    reward1:SetData(data:GetRewardByDayIndex(i))
    self:AddClickEvent(cell_daily.rewardRoot, function(go)
      self:ClickRewardItem(reward1)
    end)
    if cell_daily.reward2Root then
      reward2 = BagItemNewCell.new(cell_daily.reward2Root)
      reward2:SetData(data:GetRewardByDayIndex(6))
      self:AddClickEvent(cell_daily.reward2Root, function(go)
        self:ClickRewardItem(reward2)
      end)
    end
    local isRunning = data:IsRunning()
    cell_daily.normalPos:SetActive(not idToday)
    cell_daily.todayPos:SetActive(idToday)
    cell_daily.todayGoColider.enabled = hasAccept and isRunning
    if not isRunning then
      cell_daily.todayGoLab.text = _zhGoStr[3]
    else
      cell_daily.todayGoLab.text = hasAccept and _zhGoStr[1] or _zhGoStr[2]
    end
    yAxisOffset = idToday and 16 or 0
    LuaVector3.Better_Set(tempV3, xAxisOffset, yAxisOffset, 0)
    reward1.gameObject.transform.localPosition = tempV3
    if reward2 then
      LuaVector3.Better_Set(tempV3, xAxisOffset2, yAxisOffset, 0)
      reward2.gameObject.transform.localPosition = tempV3
    end
    self.dailyInfo[i] = cell_daily
  end
end

function DisneyActivityOverview:SelectFirstActivity()
  local data = self.wraplist:GetCellCtls()
  local first = data[1]
  if first then
    self:OnClickActivityCell(first, true)
  end
end

function DisneyActivityOverview:ClickRewardItem(cellctl)
  if cellctl and cellctl ~= self.chooseReward then
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponent(UIWidget)
    if data then
      local callback = function()
        self:CancelChooseReward()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-250, 0})
    end
    self.chooseReward = cellctl
  else
    self:CancelChooseReward()
  end
end

function DisneyActivityOverview:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end

function DisneyActivityOverview:OnEnter()
  DisneyActivityOverview.super.OnEnter(self)
  self.curActivityData = nil
  self.wraplist:ResetDatas(_DisneyStageProxy:GetOverviewActivity())
  self:SelectFirstActivity()
  _DisneyStageProxy:CallQueryDisneyGuideInfoCmd(true)
  _PictureMrg:SetActivityTexture(_bgTex, self.bgTex)
end

function DisneyActivityOverview:OnExit()
  DisneyActivityOverview.super.OnExit(self)
  TipsView.Me():HideCurrent()
  self:_Clear()
  _DisneyStageProxy:ClearRedTip()
end

function DisneyActivityOverview:_Clear()
  if self.dailyInfo then
    for k, v in pairs(self.dailyInfo) do
      ReusableTable.DestroyTable(v)
    end
    self.dailyInfo = nil
  end
  for k, v in pairs(self.mickeyReward) do
    ReusableTable.DestroyTable(v)
  end
  self.mickeyReward = nil
  local cur = self.curActivityData
  if cur then
    if self.active_TexName then
      _PictureMrg:UnloadActivityTexture(self.active_TexName, self.active_Tex)
      self.active_TexName = nil
    end
    if self.payable_TexName then
      _PictureMrg:UnloadActivityTexture(self.payable_TexName, self.payable_Tex)
      self.payable_TexName = nil
    end
    if self.daily_TexName then
      _PictureMrg:UnloadActivityTexture(self.daily_TexName, self.daily_Tex)
      self.daily_TexName = nil
    end
  end
  _PictureMrg:UnloadActivityTexture(_bgTex, self.bgTex)
end
