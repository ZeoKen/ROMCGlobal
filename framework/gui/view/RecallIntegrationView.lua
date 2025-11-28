RecallIntegrationView = class("RecallIntegrationView", ContainerView)
RecallIntegrationView.ViewType = UIViewType.NormalLayer
autoImport("RecallIntegrationTabCell")
autoImport("RecallActivityBattlePassView")
autoImport("RecallSignSubView")
autoImport("RecallWeeklyTaskSubView")
autoImport("RecallFundSubView")
autoImport("RecallShopSubView")
autoImport("RecallCatchUpSubView")
autoImport("RecallMvpCardComposeView")
local picIns = PictureManager.Instance
local DefaultDecorateTexName = "activityintegration_bg_bottom_01"

function RecallIntegrationView:Init()
  self:CallServerData()
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function RecallIntegrationView:CallServerData()
  ServiceRecallCCmdProxy.Instance:CallSignQueryInfoRecallCmd({})
  ServiceRecallCCmdProxy.Instance:CallWeeklyTaskQueryInfoRecallCmd({})
  ServiceRecallCCmdProxy.Instance:CallBattlePassQueryInfoRecallCmd({})
  RecallFundProxy.Instance:RequestFundData()
  ServiceRecallCCmdProxy.Instance:CallShopQueryInfoRecallCmd({index = 1})
  ServiceRecallCCmdProxy.Instance:CallCatchUpQueryInfoRecallCmd({})
  ServiceRecallCCmdProxy.Instance:CallMvpCardQueryInfoRecallCmd({})
end

function RecallIntegrationView:FindObjs()
  self.goBTNBack = self:FindGO("BTN_Back", self.gameObject)
  self.u_bgTex = self:FindComponent("MainBG", UITexture, self.gameObject)
  PictureManager.ReFitFullScreen(self.u_bgTex, 1)
  self.tabLine = self:FindGO("TabLine", self.gameObject):GetComponent(UISprite)
  self.tagScrollView = self:FindGO("TagScrollView"):GetComponent(UIScrollView)
  self.tabGrid = self:FindGO("TabGrid"):GetComponent(UIGrid)
  self.tabSelectListCtrl = UIGridListCtrl.new(self.tabGrid, RecallIntegrationTabCell, "ActivityIntegrationTabCell")
  self.tabSelectListCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickTabCell, self)
  self.bottom_01 = self:FindComponent("bottom_01", UITexture, self.gameObject)
end

function RecallIntegrationView:AddMapEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.RecallCCmdQueryRecallInfoRecallCmd, self.OnRecvQueryRecallInfo)
  self:AddListenEvt(ServiceEvent.RecallCCmdSignQueryInfoRecallCmd, self.OnRecvSignQueryInfo)
  self:AddListenEvt(ServiceEvent.RecallCCmdWeeklyTaskQueryInfoRecallCmd, self.OnRecvWeeklyTaskQueryInfo)
  self:AddListenEvt(ServiceEvent.RecallCCmdBattlePassQueryInfoRecallCmd, self.OnRecvBattlePassQueryInfo)
  self:AddListenEvt(ServiceEvent.RecallCCmdFundQueryInfoRecallCmd, self.OnRecvFundQueryInfo)
  self:AddListenEvt(ServiceEvent.RecallCCmdShopQueryInfoRecallCmd, self.OnRecvShopQueryInfo)
  self:AddListenEvt(ServiceEvent.RecallCCmdCatchUpQueryInfoRecallCmd, self.OnRecvCatchUpQueryInfo)
  self:AddListenEvt(ServiceEvent.RecallCCmdMvpCardQueryInfoRecallCmd, self.OnRecvMvpCardQueryInfo)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.RecallCCmdMvpCardSetUpCardRecallCmd, self.HandleMvpCardSetUpCardRecallCmd)
  self:AddListenEvt(ServiceEvent.RecallCCmdMvpCardRandCardRecallCmd, self.HandleMvpCardRandCardRecallCmd)
end

function RecallIntegrationView:AddViewEvts()
  self:AddClickEvent(self.goBTNBack, function()
    self:CloseSelf()
  end)
end

function RecallIntegrationView:InitDatas()
  self:InitTypeConfigs()
  self:InitSubViewLoaders()
end

function RecallIntegrationView:InitTypeConfigs()
  if not Table_UserRecall then
    redlog("表格不存在 Table_UserRecall")
    self.typeConfigs = {}
    return
  end
  self.typeConfigs = {}
  for id, config in pairs(Table_UserRecall) do
    local activityType = config.Type
    if not self.typeConfigs[activityType] or id < self.typeConfigs[activityType].id then
      self.typeConfigs[activityType] = {id = id, config = config}
    end
  end
end

function RecallIntegrationView:InitSubViewLoaders()
  self.subViews = {}
  
  function self.subViews.SignIn(data)
    if not self.signInView then
      self.signInView = self:AddSubView("RecallSignSubView", RecallSignSubView, nil, nil)
      self.signInView.parentView = self
    end
    return self.signInView
  end
  
  function self.subViews.BattlePass(data)
    if not self.battlePassView then
      local viewdata = {
        configIndex = data and data.index or 1
      }
      self.battlePassView = self:AddSubView("RecallActivityBattlePassView", RecallActivityBattlePassView, nil, viewdata)
      self.battlePassView.parentView = self
    end
    return self.battlePassView
  end
  
  function self.subViews.WeeklyTask(data)
    if not self.weeklyTaskView then
      self.weeklyTaskView = self:AddSubView("RecallWeeklyTaskSubView", RecallWeeklyTaskSubView, nil, data)
      self.weeklyTaskView.parentView = self
    end
    return self.weeklyTaskView
  end
  
  function self.subViews.Fund(data)
    if not self.fundView then
      self.fundView = self:AddSubView("RecallFundSubView", RecallFundSubView, nil, data)
      self.fundView.parentView = self
    end
    return self.fundView
  end
  
  function self.subViews.Shop(data)
    if not self.shopView then
      self.shopView = self:AddSubView("RecallShopSubView", RecallShopSubView, nil, data)
      self.shopView.parentView = self
    end
    return self.shopView
  end
  
  function self.subViews.CatchUp(data)
    if not self.catchUpView then
      self.catchUpView = self:AddSubView("RecallCatchUpSubView", RecallCatchUpSubView, nil, data)
      self.catchUpView.parentView = self
    end
    return self.catchUpView
  end
  
  function self.subViews.MvpCard(data)
    if not self.mvpCardView then
      self.mvpCardView = self:AddSubView("RecallMvpCardComposeView", RecallMvpCardComposeView, nil, data)
      self.mvpCardView.parentView = self
    end
    return self.mvpCardView
  end
end

function RecallIntegrationView:InitShow()
  self.tabSelectListCtrl:ResetDatas({})
  self.tabLine.width = 42
end

function RecallIntegrationView:ScheduleRefreshTabList()
  if TimeTickManager and TimeTickManager.Me then
    TimeTickManager.Me():ClearTick(self, 991234)
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self:RefreshTabList()
    end, self, 991234)
  else
    self:RefreshTabList()
  end
end

function RecallIntegrationView:RefreshTabList()
  local tabList = {}
  if not Table_UserRecall then
    redlog("表格不存在 Table_UserRecall")
    return
  end
  local supportedTypes = {
    {
      type = "SignIn",
      name = ZhString.RecallIntegration_SignIn,
      hasServerData = function()
        return RecallSignProxy.Instance:HasServerData()
      end,
      getDisplayInfo = function()
        return RecallSignProxy.Instance:GetDisplayInfo()
      end,
      redTipId = 10778,
      subRedTipId = 1001
    },
    {
      type = "BattlePass",
      name = ZhString.RecallIntegration_BattlePass,
      hasServerData = function()
        return RecallActivityBattlePassProxy.Instance and RecallActivityBattlePassProxy.Instance.isEnd == false
      end,
      getDisplayInfo = function()
        local startTime = RecallActivityBattlePassProxy.Instance:GetStartTime() or 0
        local endTime = RecallActivityBattlePassProxy.Instance:GetEndTime() or 0
        return {startTime = startTime, endTime = endTime}
      end,
      redTipId = 10778,
      subRedTipId = 1004
    },
    {
      type = "WeeklyTask",
      name = ZhString.RecallIntegration_WeeklyTask,
      hasServerData = function()
        return RecallWeeklyTaskProxy.Instance:HasServerData()
      end,
      getDisplayInfo = function()
        return RecallWeeklyTaskProxy.Instance:GetDisplayInfo()
      end,
      redTipId = 10778,
      subRedTipId = 1002
    },
    {
      type = "Fund",
      name = ZhString.RecallIntegration_Fund,
      hasServerData = function()
        return RecallFundProxy.Instance and RecallFundProxy.Instance:HasServerData()
      end,
      getDisplayInfo = function()
        return RecallFundProxy.Instance and RecallFundProxy.Instance:GetDisplayInfo() or {startTime = "", endTime = ""}
      end,
      redTipId = 10778,
      subRedTipId = 1003
    },
    {
      type = "Shop",
      name = ZhString.RecallIntegration_Shop,
      hasServerData = function()
        return RecallShopProxy.Instance and RecallShopProxy.Instance:HasAvailableShopItems() and RecallShopProxy.Instance:IsActivityValid()
      end,
      getDisplayInfo = function()
        return RecallShopProxy.Instance and RecallShopProxy.Instance:GetDisplayInfo() or {startTime = "", endTime = ""}
      end
    },
    {
      type = "CatchUp",
      name = ZhString.RecallIntegration_CatchUp,
      hasServerData = function()
        return RecallCatchUpProxy.Instance and RecallCatchUpProxy.Instance:HasServerData() and not RecallCatchUpProxy.Instance:IsActivityEnded()
      end,
      getDisplayInfo = function()
        return RecallCatchUpProxy.Instance and RecallCatchUpProxy.Instance:GetDisplayInfo() or {startTime = 0, endTime = 0}
      end
    },
    {
      type = "MvpCard",
      name = ZhString.RecallIntegration_MvpCard,
      hasServerData = function()
        return RecallMvpCardProxy.Instance:IsActivityValid()
      end,
      getDisplayInfo = function()
        local startTime = RecallMvpCardProxy.Instance:GetStartTime() or 0
        local endTime = RecallMvpCardProxy.Instance:GetEndTime() or 0
        return {startTime = startTime, endTime = endTime}
      end
    }
  }
  if not self.typeConfigs then
    redlog("RecallIntegrationView:RefreshTabList typeConfigs未初始化")
    return
  end
  for _, typeConfig in ipairs(supportedTypes) do
    local activityType = typeConfig.type
    local typeName = typeConfig.name
    local hasServerData = typeConfig.hasServerData
    local getDisplayInfo = typeConfig.getDisplayInfo
    if hasServerData() then
      local configInfo = self.typeConfigs[activityType]
      if configInfo then
        local displayInfo = getDisplayInfo()
        local data = {
          id = configInfo.id,
          activityType = activityType,
          startTime = displayInfo.startTime or 0,
          endTime = displayInfo.endTime or 0,
          staticData = configInfo.config,
          name = typeName,
          Redtip = typeConfig.redTipId,
          subRedtip = typeConfig.subRedTipId
        }
        table.insert(tabList, data)
      else
        xdlog("未找到对应配置:", activityType)
      end
    end
  end
  table.sort(tabList, function(l, r)
    return l.id < r.id
  end)
  local signatureItems = {}
  for i = 1, #tabList do
    local d = tabList[i]
    signatureItems[i] = tostring(d.id) .. ":" .. tostring(d.activityType)
  end
  table.sort(signatureItems)
  local newSignature = table.concat(signatureItems, "|")
  if self._lastTabSignature ~= newSignature then
    self._lastTabSignature = newSignature
    self.tabSelectListCtrl:ResetDatas(tabList)
    self.tabLine.width = 42 + (#tabList - 1) * 148.2
  end
  local cells = self.tabSelectListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i].data.Redtip then
      self:RegisterRedTipCheck(cells[i].data.Redtip, cells[i].gameObject, 42, {-90, -30}, nil, cells[i].data.subRedtip)
    end
  end
  if 0 < #tabList then
    local targetCell
    if self.currentID then
      for i = 1, #cells do
        if cells[i].data and cells[i].data.id == self.currentID then
          targetCell = cells[i]
          break
        end
      end
    end
    targetCell = targetCell or cells[1]
    if targetCell then
      if not self.currentID or self.currentID ~= targetCell.data.id then
        self:handleClickTabCell(targetCell)
      end
      local panel = self.tagScrollView.panel
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, targetCell.gameObject.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      offset = Vector3(0, offset.y, 0)
      self.tagScrollView:MoveRelative(offset)
    end
  end
end

function RecallIntegrationView:OnRecvQueryRecallInfo(data)
  self:ScheduleRefreshTabList()
end

function RecallIntegrationView:OnRecvSignQueryInfo(data)
  self:ScheduleRefreshTabList()
end

function RecallIntegrationView:OnRecvWeeklyTaskQueryInfo(data)
  self:ScheduleRefreshTabList()
end

function RecallIntegrationView:OnRecvBattlePassQueryInfo(data)
  self:ScheduleRefreshTabList()
end

function RecallIntegrationView:OnRecvFundQueryInfo(data)
  self:ScheduleRefreshTabList()
end

function RecallIntegrationView:OnRecvShopQueryInfo(data)
  self:ScheduleRefreshTabList()
end

function RecallIntegrationView:OnRecvCatchUpQueryInfo(data)
  self:ScheduleRefreshTabList()
end

function RecallIntegrationView:OnRecvMvpCardQueryInfo(data)
  self:ScheduleRefreshTabList()
end

function RecallIntegrationView:handleClickTabCell(cellCtrl)
  local data = cellCtrl.data
  local id = data.id
  local activityType = data.activityType
  if not self.subViews[activityType] then
    redlog("未找到对应的子视图加载器", activityType)
    return
  end
  if self.currentType and self.currentType ~= activityType then
    local curSubView = self.currentType and self.subViews[self.currentType] and self.subViews[self.currentType](self.currentData)
    if curSubView then
      curSubView.gameObject:SetActive(false)
      curSubView:OnHide()
    end
  end
  self.currentType = activityType
  self.currentData = data
  if self.currentID and self.currentID == id then
    return
  end
  self.currentID = id
  local wasNewlyCreated = false
  local subView
  if activityType == "SignIn" and self.signInView then
    subView = self.signInView
  elseif activityType == "BattlePass" and self.battlePassView then
    subView = self.battlePassView
  elseif activityType == "WeeklyTask" and self.weeklyTaskView then
    subView = self.weeklyTaskView
  elseif activityType == "Fund" and self.fundView then
    subView = self.fundView
  elseif activityType == "Shop" and self.shopView then
    subView = self.shopView
  elseif activityType == "CatchUp" and self.catchUpView then
    subView = self.catchUpView
  elseif activityType == "MvpCard" and self.mvpCardView then
    subView = self.mvpCardView
  end
  if not subView then
    subView = self.subViews[activityType](data)
    wasNewlyCreated = true
  end
  if subView then
    if wasNewlyCreated then
      subView:OnEnter()
    end
    subView.gameObject:SetActive(true)
    subView:OnShow()
  end
  self:ChangeSubSelectorOnSelect(id)
  self:HandleSwitchBG()
end

function RecallIntegrationView:ChangeSubSelectorOnSelect(id)
  local ssCells = self.tabSelectListCtrl:GetCells()
  for i = 1, #ssCells do
    local cellId = ssCells[i].data.id
    ssCells[i]:SetSelect(cellId == id)
  end
end

function RecallIntegrationView:HandleClickHelpBtn(helpid)
  local helpConfig = Table_Help[helpid]
  if helpConfig then
    self:OpenHelpView(helpConfig)
  end
end

function RecallIntegrationView:SetBottomBg(textureName)
  self:UnloadBottomBg()
  picIns:SetUI(textureName, self.bottom_01)
  self.currentBottomTexName = textureName
end

function RecallIntegrationView:ResetBottomBg()
  self:SetBottomBg(DefaultDecorateTexName)
end

function RecallIntegrationView:UnloadBottomBg()
  if self.currentBottomTexName then
    picIns:UnLoadUI(self.currentBottomTexName, self.bottom_01)
  end
end

function RecallIntegrationView:HandleSwitchBG()
  local textureName = "mall_twistedegg_bg_bottom"
  if self.textureName and textureName == self.textureName then
    return
  end
  if self.textureName then
    PictureManager.Instance:UnLoadUI(self.textureName, self.u_bgTex)
  end
  self.textureName = textureName
  PictureManager.Instance:SetUI(self.textureName, self.u_bgTex)
end

function RecallIntegrationView:HandleItemUpdate()
end

function RecallIntegrationView:HandleMvpCardSetUpCardRecallCmd()
end

function RecallIntegrationView:HandleMvpCardRandCardRecallCmd()
end

function RecallIntegrationView:OnEnter(id)
  RecallIntegrationView.super.OnEnter(self)
  if not self.currentBottomTexName then
    self:ResetBottomBg()
  end
end

function RecallIntegrationView:OnExit()
  RecallIntegrationView.super.OnExit(self)
  self:UnloadBottomBg()
end
