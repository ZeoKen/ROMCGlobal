autoImport("SignIn21UnlockMenuCell")
autoImport("SignIn21TodayTargetCell")
autoImport("SignIn21RewardListCell")
autoImport("SignIn21Cell")
SignIn21View = class("SignIn21View", BaseView)
SignIn21View.ViewType = UIViewType.NormalLayer
local texObjStaticNameMap = {
  Bg0 = "sign_21days_bgbg1",
  Bg01 = "sign_21days_bgbg2",
  TitleBg = "sign_21days_bg_title0",
  Title0 = "sign_21days_bg_title",
  Title1 = "sign_21days_bg_title1",
  ProgressBg = "sign_21days_bg_progress-bar1",
  ProgressBar = "sign_21days_bg_progress-bar2",
  NoneTip = "sign_21days_pic_boliqiqiu"
}
local targetParamFields = {
  "Practical",
  "Difficult",
  "Frequency"
}
local picIns, sign21Ins

function SignIn21View:Init()
  if not picIns then
    picIns = PictureManager.Instance
    sign21Ins = SignIn21Proxy.Instance
  end
  self:FindObjs()
  self:InitData()
  self:InitShow()
  self:AddEvents()
end

function SignIn21View:FindObjs()
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.pointLabel = self:FindComponent("Point", UILabel)
  self.unlockMenuTitle = self:FindGO("UnlockMenuTitle")
  self.todayTargetTitle = self:FindGO("TodayTargetTitle")
  local curLabel = self:FindGO("curLabel"):GetComponent(UILabel)
  curLabel.text = ZhString.SignIn21View_Title
  self.listTable = self:FindComponent("ListTable", UITable)
  self.normalStick = self:FindComponent("NormalStick", UISprite)
  self.nextLvRewardLabel = self:FindComponent("NextLvRewardLabel", UILabel)
  self.nextLvRewardGrid = self:FindComponent("NextLvRewardGrid", UIGrid)
  self.nextLvRewardIcons = {}
  self.nextLvRewardItemIds = {}
  for i = 1, 2 do
    self.nextLvRewardIcons[i] = self:FindComponent("NextLvReward" .. i, UISprite)
    self:AddClickEvent(self.nextLvRewardIcons[i].gameObject, function()
      self:OnClickNextLvRewardIcon(i)
    end)
  end
  self.cellParentTrans = self:FindGO("Cells").transform
  self.cellScrollView = self:FindComponent("CellScrollView", UIScrollView)
  self.cellScrollViewTrans = self.cellScrollView.transform
  
  function self.cellScrollView.panel.onClipMove()
    if not self.bg0LocalPosY0 then
      return
    end
    self.bg0Trans.localPosition = LuaGeometry.GetTempVector3(self.bg0LocalPosX, self.bg0LocalPosY0 + self.cellScrollViewTrans.localPosition.y)
  end
  
  local maxDay = sign21Ins.MaxDay
  self.cells = {}
  for i = 1, 21 do
    self.cells[i] = SignIn21Cell.new(self:FindGO("SignIn21Cell" .. i), i)
    self:AddClickEvent(self.cells[i].gameObject, function()
      self:OnClickCell(i)
    end)
    if i > maxDay then
      self.cells[i]:Hide()
    end
  end
  self.lines = {}
  for i = 1, 20 do
    self.lines[i] = self:FindGO(tostring(i))
    self.lines[i]:SetActive(i < maxDay)
  end
  self.rewardListParent = self:FindGO("RewardListCtrl")
  self:RegisterChildPopObj(self.rewardListParent)
  self.targetTips = self:FindGO("TargetTips")
  self:RegisterChildPopObj(self.targetTips)
  self.targetTipsTitle = self:FindComponent("TargetTipsTitle", UILabel)
  self.targetTipsDesc = self:FindComponent("TargetTipsDesc", UILabel)
  self.targetStarMap = {}
  local starGrid
  for i = 1, #targetParamFields do
    self.targetStarMap[i] = self.targetStarMap[i] or {}
    starGrid = self:FindGO("StarGrid", self:FindGO("Param" .. i))
    for j = 1, 5 do
      self.targetStarMap[i][j] = self:FindGO("Star" .. j, starGrid)
    end
  end
  self.bg0Trans = self.Bg0.gameObject.transform
  local noneTipLabel = self:FindGO("NoneTipLabel"):GetComponent(UILabel)
  noneTipLabel.text = ZhString.SignIn21View_NoneTip
end

function SignIn21View:InitData()
  self.tipData = {
    funcConfig = _EmptyTable
  }
  self.tipOffset = {0, 0}
  local rootSize = UIManagerProxy.Instance:GetUIRootSize()
  self.uiWidth, self.uiHeight = rootSize[1], rootSize[2]
end

function SignIn21View:InitShow()
  self.unlockMenuListCtrl = ListCtrl.new(self:FindComponent("UnlockMenuContainer", UITable), SignIn21UnlockMenuCell, "SignIn21UnlockMenuCell")
  self.unlockMenuListCtrl:AddEventListener(ServantRaidStatEvent.GoToBtnClick, self.OnClickGotoBtn, self)
  self.todayTargetListCtrl = ListCtrl.new(self:FindComponent("TodayTargetContainer", UITable), SignIn21TodayTargetCell, "SignIn21TodayTargetCell")
  self.todayTargetListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickTodayTargetListCell, self)
  self.todayTargetListCtrl:AddEventListener(ServantRaidStatEvent.GoToBtnClick, self.OnClickGotoBtn, self)
  self.rewardListCtrl = ListCtrl.new(self:FindComponent("RewardListContainer", UIGrid), SignIn21RewardListCell, "SignIn21RewardListCell")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardListIconCell, self)
  self.tipData.ignoreBounds = {
    self.rewardListCtrl.layoutCtrl.gameObject
  }
  self:AdjustScreen()
end

function SignIn21View:AddEvents()
  self:AddButtonEvent("RewardListBtn", function()
    self.targetTips:SetActive(false)
    self.rewardListParent:SetActive(true)
  end)
  self:AddButtonEvent("RewardListCloseBtn", function()
    self.rewardListParent:SetActive(false)
  end)
  self:AddButtonEvent("TargetTipsCloseBtn", function()
    self.targetTips:SetActive(false)
  end)
  self:AddListenEvt(MyselfEvent.NoviceTargetPointChange, self.OnPointChange)
  self:AddListenEvt(ServiceEvent.NUserNoviceTargetUpdateUserCmd, self.OnTargetUpdate)
end

local setScrollViewClipHeight = function(scrollView, h)
  local panel = scrollView.panel
  local tmpClipRegion = panel.baseClipRegion
  tmpClipRegion.w = h
  panel.baseClipRegion = tmpClipRegion
end

function SignIn21View:AdjustScreen()
  local listScrollView = self:FindComponent("ListScrollView", UIScrollView)
  local _, y = LuaGameObject.GetLocalPosition(listScrollView.transform)
  setScrollViewClipHeight(listScrollView, self.uiHeight + 2 * y)
  setScrollViewClipHeight(self.cellScrollView, self.uiHeight)
end

function SignIn21View:OnEnter()
  SignIn21View.super.OnEnter(self)
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:SetSignIn(texName, self[objName])
  end
  self.rewardListParent:SetActive(false)
  self.targetTips:SetActive(false)
  self.bg0LocalPosX = self.bg0Trans.localPosition.x
  self.bg0LocalPosY0 = self.cellParentTrans.localPosition.y + self.bg0Trans.localPosition.y
  self.bg0Trans.localPosition = LuaGeometry.GetTempVector3(self.bg0LocalPosX, self.bg0LocalPosY0, 0)
  self:UpdateTitle()
  self:UpdateSignInCellsAndList(sign21Ins:GetFirstDayWithUnrewardedTarget() or sign21Ins.today)
  self:UpdateRewardList()
end

function SignIn21View:OnExit()
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:UnLoadSignIn(texName, self[objName])
  end
  self:DestroyHint()
  TimeTickManager.Me():ClearTick(self)
  SignIn21View.super.OnExit(self)
end

function SignIn21View:OnTargetUpdate()
  self:UpdateSignInCellsAndList(sign21Ins:GetFirstDayWithUnrewardedTarget())
end

function SignIn21View:OnClickTodayTargetListCell(cellCtl)
  self:UpdateTargetTips(cellCtl and cellCtl.data)
end

function SignIn21View:OnClickCell(index)
  local cellCtl = self.cells[index]
  if not cellCtl then
    return
  end
  self:AddHintToCell(index)
  self:UpdateList(cellCtl.day)
end

function SignIn21View:OnClickGotoBtn(cellData)
  local guideId = cellData.GuideId
  if guideId ~= nil and 0 < guideId then
    ServiceUserEventProxy.Instance:CallGuideQuestEvent(cellData.id)
    self:CloseSelf()
    return
  end
  local g = cellData and cellData.Goto
  if type(g) ~= "table" or not next(g) then
    if not StringUtil.IsEmpty(cellData.Message) then
      MsgManager.FloatMsg("", cellData.Message)
    end
    return
  end
  local questIds = cellData.Param.quest_id
  if 1 < #g then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShortCutOptionPopUp,
      viewdata = {
        data = questIds or g,
        gotomode = g,
        functiontype = questIds and 2 or 1,
        alignIndex = true
      }
    })
  else
    local t, questData = ReusableTable.CreateArray()
    if cellData.TargetType == 2 and questIds then
      for i = 1, #questIds do
        local servantQuestStepList = Table_ServantQuestfinishStep[questIds[i]]
        if servantQuestStepList then
          local stepList = servantQuestStepList.QuestStep
          if stepList and 0 < #stepList then
            for j = 1, #stepList do
              questData = QuestProxy.Instance:GetQuestDataBySameQuestID(stepList[j])
              if questData then
                TableUtility.ArrayPushBack(t, questData)
              end
            end
          end
        end
      end
    end
    if t[1] then
      FuncShortCutFunc.Me():CallByQuestFinishID(nil, nil, t[1])
    else
      FuncShortCutFunc.Me():CallByID(g[1])
    end
    ReusableTable.DestroyAndClearArray(t)
  end
  self:CloseSelf()
end

function SignIn21View:OnClickRewardListIconCell(id)
  self:ShowItemTip(id, -200)
end

function SignIn21View:OnClickNextLvRewardIcon(index)
  self:ShowItemTip(self.nextLvRewardItemIds[index], 65)
end

function SignIn21View:OnPointChange()
  self:UpdateTitle()
  self:UpdateRewardList()
end

function SignIn21View:ShowItemTip(id, offsetX)
  if not id then
    return
  end
  self.tipData.itemdata = ItemData.new("Tip", id)
  self.tipOffset[1] = offsetX or 0
  SignIn21View.super.ShowItemTip(self, self.tipData, self.normalStick, NGUIUtil.AnchorSide.Left, self.tipOffset)
end

function SignIn21View:UpdateTitle()
  local level, progress = sign21Ins:GetLevelAndProgressFromTargetPoint()
  if not level then
    LogUtility.Warning("Cannot get Level&progress from targetPoint!!")
    return
  end
  self.pointLabel.text = "Lv." .. level
  self.ProgressBar.fillAmount = progress
  self.nextLvRewardLabel.gameObject:SetActive(level < sign21Ins:GetMaxLevel())
  local nextLvRewardItemIds = sign21Ins:GetRewardItemIdsFromTargetLevel(level + 1)
  self.nextLvRewardGrid.gameObject:SetActive(nextLvRewardItemIds ~= nil and next(nextLvRewardItemIds) ~= nil)
  local rewardCount, icon = nextLvRewardItemIds and #nextLvRewardItemIds or 0
  for i = 1, rewardCount do
    icon = self.nextLvRewardIcons[i]
    if icon then
      icon.gameObject:SetActive(true)
      self.nextLvRewardItemIds[i] = nextLvRewardItemIds[i].id
      IconManager:SetItemIcon(Table_Item[self.nextLvRewardItemIds[i]].Icon, icon)
    end
  end
  for i = rewardCount + 1, #self.nextLvRewardIcons do
    icon = self.nextLvRewardIcons[i]
    if icon then
      icon.gameObject:SetActive(false)
    end
  end
  self.nextLvRewardGrid:Reposition()
end

function SignIn21View:UpdateSignInCells(scrollCellsTo)
  local lastDayComplete = true
  local maxDay = sign21Ins.MaxDay
  local today = sign21Ins.today
  for i = 1, maxDay do
    if i <= today then
      if not lastDayComplete then
        self.cells[i]:SwitchToState(SignIn21CellState.Locked)
      else
        self.cells[i]:SwitchToState(SignIn21CellState.Unsigned)
        if sign21Ins:IsAllTargetOfDayComplete(i) then
          self.cells[i]:SwitchToState(SignIn21CellState.Signed)
          lastDayComplete = true
        else
          lastDayComplete = false
        end
      end
    else
      self.cells[i]:SwitchToState(SignIn21CellState.Locked)
    end
  end
  if scrollCellsTo then
    self.cellScrollView:SetDragAmount(0, (scrollCellsTo - 1) / (maxDay - 1), false)
  end
end

function SignIn21View:UpdateList(day)
  local exDay = self.day
  self.day = day or self.day
  local isLayout = day ~= nil and self.day ~= exDay
  local datas, data = sign21Ins:GetTargetDataByDay(self.day)
  local unlockMenuData, todayTargetData = ReusableTable.CreateArray(), ReusableTable.CreateArray()
  if self.day <= sign21Ins.today then
    for i = 1, #datas do
      data = datas[i]
      if data.id >= GameConfig.NoviceTargetPointCFG.UnlockFunctionId then
        TableUtility.ArrayPushBack(unlockMenuData, data)
      else
        TableUtility.ArrayPushBack(todayTargetData, data)
      end
    end
  end
  self.unlockMenuListCtrl:ResetDatas(unlockMenuData)
  self.todayTargetListCtrl:ResetDatas(todayTargetData)
  self.unlockMenuTitle:SetActive(0 < #unlockMenuData)
  self.NoneTip.gameObject:SetActive(#unlockMenuData + #todayTargetData == 0)
  self.targetTips:SetActive(false)
  if isLayout then
    TimeTickManager.Me():CreateOnceDelayTick(33, function()
      if not self or not self.unlockMenuListCtrl then
        return
      end
      self.unlockMenuListCtrl:ResetPosition()
      self.todayTargetListCtrl:ResetPosition()
      self.listTable:Reposition()
      self.unlockMenuListCtrl.scrollView:ResetPosition()
      local isShow = self.unlockMenuTitle.activeSelf
      self.unlockMenuTitle:SetActive(false)
      if isShow then
        self.unlockMenuTitle:SetActive(true)
      end
    end, self)
  end
  ReusableTable.DestroyAndClearArray(unlockMenuData)
  ReusableTable.DestroyAndClearArray(todayTargetData)
end

function SignIn21View:UpdateSignInCellsAndList(day)
  self:UpdateSignInCells(day)
  self:AddHintToCell(day)
  self:UpdateList(day)
end

function SignIn21View:UpdateRewardList()
  local arr, element, rewardIds = ReusableTable.CreateArray()
  for i = 1, sign21Ins:GetMaxLevel() do
    element = {}
    element.level = i
    rewardIds = sign21Ins:GetRewardItemIdsFromTargetLevel(i)
    if rewardIds then
      for j = 1, #rewardIds do
        element[j] = rewardIds[j]
      end
    end
    TableUtility.ArrayPushBack(arr, element)
  end
  self.rewardListCtrl:ResetDatas(arr)
  ReusableTable.DestroyAndClearArray(arr)
end

function SignIn21View:UpdateTargetTips(data)
  if not data then
    LogUtility.Warning("Cannot get NoviceTarget data while updating target tips!")
    self.targetTips:SetActive(false)
    return
  end
  self.targetTips:SetActive(true)
  self.targetTipsTitle.text = data.Title
  self.targetTipsDesc.text = data.Description
  local value
  for i = 1, #targetParamFields do
    value = math.clamp(data[targetParamFields[i]], 0, 5)
    for j = 1, value do
      self.targetStarMap[i][j]:SetActive(true)
    end
    for j = value + 1, 5 do
      self.targetStarMap[i][j]:SetActive(false)
    end
  end
end

function SignIn21View:AddHintToCell(index)
  local cellCtl = self.cells[index]
  if not cellCtl then
    return
  end
  if not self.hintTrans then
    local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.EffectUI("Eff_SignIn21View"), cellCtl.gameObject)
    if go then
      self.hintTrans = go.transform
      self.hintTrans.localScale = LuaGeometry.Const_V3_one
    else
      LogUtility.Warning("Cannot load Eff_SignIn21View")
      return
    end
  else
    self.hintTrans:SetParent(cellCtl.gameObject.transform, false)
  end
  local cfg = GameConfig.NoviceTargetPointCFG.GearPosition
  cfg = cfg and cfg[index]
  self.hintTrans.localPosition = LuaGeometry.GetTempVector3(cfg and cfg[1], cfg and cfg[2])
end

function SignIn21View:DestroyHint()
  if self.hintTrans then
    GameObject.Destroy(self.hintTrans.gameObject)
    self.hintTrans = nil
  end
end
