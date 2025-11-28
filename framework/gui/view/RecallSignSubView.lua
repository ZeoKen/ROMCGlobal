RecallSignSubView = class("RecallSignSubView", SubMediatorView)
autoImport("RecallSignCell")
local viewPath = ResourcePathHelper.UIView("RecallSignSubView")

function RecallSignSubView:Init()
  if self.inited then
    return
  end
  self:LoadSubView()
  self:AddMapEvts()
  self.gameObject = self:FindGO("RecallSignSubView")
  self.signCells = {}
  self.inited = true
end

function RecallSignSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "RecallSignSubView"
end

function RecallSignSubView:FindObjs(signDays)
  self.welcomeBtn = self:FindGO("WelcomeBtn")
  if self.signRoot then
    self.signRoot:SetActive(false)
  end
  local componentName = signDays == 14 and "RecallSign_14" or "RecallSign_7"
  self.signRoot = self:FindGO(componentName, self.gameObject)
  if not self.signRoot then
    local rootGO = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPart(componentName))
    if rootGO then
      rootGO.name = componentName
      rootGO.transform:SetParent(self.gameObject.transform, false)
      rootGO:SetActive(true)
      self.signRoot = rootGO
      local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
      local panels = rootGO:GetComponentsInChildren(UIPanel)
      for i = 1, #panels do
        panels[i].depth = upPanel.depth + panels[i].depth
      end
    else
      redlog("无法加载组件:", componentName)
      return
    end
  else
    self.signRoot:SetActive(true)
  end
  self.timeLabel = self:FindGO("LeftTimeLabel", self.signRoot):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn", self.signRoot)
  self.batchLabel = self:FindGO("BatchLabel", self.signRoot):GetComponent(UILabel)
  local gainTipLabelGO = self:FindGO("GainTipLabel", self.signRoot):GetComponent(UIRichLabel)
  self.gainTipLabel = SpriteLabel.new(gainTipLabelGO, nil, 25, 25, false)
  self.signInBtn = self:FindGO("SignInBtn", self.signRoot)
  self:CreateSignCells(signDays)
end

function RecallSignSubView:CreateSignCells(signDays)
  if self.currentSignDays == signDays and self.signCells and next(self.signCells) then
    return
  end
  self:ClearSignCells()
  self.currentSignDays = signDays
  for day = 1, signDays do
    local dayGameObject = self:FindGO("RecallSignCell" .. day, self.signRoot)
    if dayGameObject then
      local cell = RecallSignCell.new(dayGameObject)
      cell.parentView = self
      cell:AddEventListener(MouseEvent.MouseClick, function()
        self:OnCellClick(day)
      end, self)
      self.signCells[day] = cell
    else
      xdlog("未找到SignDay游戏对象:", "SignDay_" .. day)
    end
  end
end

function RecallSignSubView:ClearSignCells()
  if self.signCells then
    for _, cell in pairs(self.signCells) do
      if cell and cell.OnDestroy then
        cell:OnDestroy()
      end
    end
    TableUtility.ArrayClear(self.signCells)
  end
end

function RecallSignSubView:AddViewEvts()
  if self.helpBtn then
    self:AddClickEvent(self.helpBtn, function()
      self:HandleClickHelpBtn()
    end)
  end
  if self.signInBtn then
    self:AddClickEvent(self.signInBtn, function()
      self:HandleSignInBtnClick()
    end)
  end
  if self.welcomeBtn then
    self:AddClickEvent(self.welcomeBtn, function()
      self:HandleWelcomeBtnClick()
    end)
  end
end

function RecallSignSubView:AddMapEvts()
  self:AddDispatcherEvt(ServiceEvent.RecallCCmdSignInRecallCmd, self.OnSignInSuccess)
  self:AddDispatcherEvt(ServiceEvent.RecallCCmdSignQueryInfoRecallCmd, self.OnSignDataUpdate)
end

function RecallSignSubView:InitDatas()
  if not self.activityIndex then
    redlog("RecallSignSubView: activityIndex not set")
    return
  end
  self.serverSignData = RecallSignProxy.Instance:GetSignData(self.activityIndex)
  if not self.serverSignData or not self.serverSignData.index then
    redlog("未找到服务器签到数据:", self.activityIndex)
    return
  end
  local configIndex = RecallInfoProxy.Instance:GetIndex(self.serverSignData.index + 1)
  if not configIndex then
    redlog("未能获取配置索引:", self.serverSignData.index)
    return
  end
  self.staticSignData = RecallSignProxy.Instance:GetStaticSignDataByIndex(configIndex)
  if not self.staticSignData then
    redlog("未找到签到静态数据, configIndex:", configIndex, "serverIndex:", self.serverSignData.index)
    return
  end
  self.signDays = 0
  for day, _ in pairs(self.staticSignData) do
    self.signDays = math.max(self.signDays, day)
  end
  xdlog("签到天数:", self.signDays, "活动期数:", self.activityIndex, "服务器index:", self.serverSignData.index, "配置index:", configIndex)
  self:FindObjs(self.signDays)
  self:AddViewEvts()
end

function RecallSignSubView:RefreshPage()
  if not self.staticSignData or not self.signCells then
    return
  end
  for day = 1, self.signDays do
    local cell = self.signCells[day]
    if cell then
      local staticData = Table_UserRecall_Sign[self.staticSignData[day]]
      if staticData then
        cell:SetData(staticData)
        local status = self:GetDaySignStatus(day)
        cell:SetStatus(status)
      end
    end
  end
  if self.batchLabel and self.serverSignData then
    local currentBatch = self.serverSignData.index + 1 or 1
    local totalBatch = RecallInfoProxy.Instance:GetTotalBatchCount() or 1
    self.batchLabel.text = string.format(ZhString.RecallIntegration_BatchNumber, currentBatch, totalBatch)
  end
  if self.gainTipLabel and self.activityIndex then
    local actualIndex = RecallInfoProxy.Instance:GetIndex(self.activityIndex + 1)
    if actualIndex == 1 then
      self.gainTipLabel:SetText(ZhString.RecallIntegration_SignIn_RewardTip1)
    elseif actualIndex == 2 then
      self.gainTipLabel:SetText(ZhString.RecallIntegration_SignIn_RewardTip2)
    end
  end
  self:UpdateTimeDisplay()
  self:UpdateSignInButtonState()
end

function RecallSignSubView:GetDaySignStatus(day)
  if not self.serverSignData then
    return 1
  end
  local currentDay = self.serverSignData.cur_day or 0
  local canSignIn = RecallSignProxy.Instance:CanSignIn(self.activityIndex)
  if day <= currentDay then
    return 3
  elseif day == currentDay + 1 and canSignIn then
    return 2
  else
    return 1
  end
end

function RecallSignSubView:UpdateTimeDisplay()
  if not self.timeLabel or not self.serverSignData then
    return
  end
  local endTime = self.serverSignData.end_time
  if endTime then
    local currentTime = ServerTime.CurServerTime() / 1000
    local leftTime = endTime - currentTime
    if 0 < leftTime then
      local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
      local timeText
      if 0 < day then
        timeText = string.format(ZhString.PlayerTip_ExpireTime, day)
        self.timeLabel.text = timeText .. ZhString.PlayerTip_Day
      else
        timeText = string.format("%02d:%02d:%02d", hour, min, sec)
        self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
      end
    else
      self:StopUpdateTimer()
      self.timeLabel.text = ZhString.Activity_End
    end
  else
    self.timeLabel.text = ""
  end
end

function RecallSignSubView:UpdateSignInButtonState()
  if not self.signInBtn then
    return
  end
  local hasSignableDay = self:HasSignableDay()
  if hasSignableDay then
    self:SetTextureWhite(self.signInBtn, LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1))
  else
    self:SetTextureGrey(self.signInBtn)
  end
end

function RecallSignSubView:HasSignableDay()
  if not self.serverSignData or not self.activityIndex then
    return false
  end
  local canSignIn = RecallSignProxy.Instance:CanSignIn(self.activityIndex)
  if not canSignIn then
    return false
  end
  local currentDay = self.serverSignData.cur_day or 0
  local nextDay = currentDay + 1
  if nextDay > self.signDays then
    return false
  end
  local nextDayStatus = self:GetDaySignStatus(nextDay)
  return nextDayStatus == 2
end

function RecallSignSubView:HandleClickHelpBtn()
  xdlog("点击帮助按钮")
  if Table_Help[500003] then
    local helpConfig = Table_Help[500003]
    self:OpenHelpView(helpConfig)
  end
end

function RecallSignSubView:HandleSignInBtnClick()
  if RecallSignProxy.Instance:CanSignIn(self.activityIndex) then
    ServiceRecallCCmdProxy.Instance:CallSignInRecallCmd()
  else
    xdlog("当前无法签到")
  end
end

function RecallSignSubView:HandleWelcomeBtnClick()
  xdlog("点击回归欢迎按钮")
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "RecallWelcomePopup"
  })
end

function RecallSignSubView:OnSignInDay(day)
  xdlog("签到第", day, "天")
  local status = self:GetDaySignStatus(day)
  if status == 2 then
    ServiceRecallCCmdProxy.Instance:CallSignInRecallCmd()
  else
    xdlog("第", day, "天无法签到, 状态:", status)
  end
end

function RecallSignSubView:OnSignInSuccess(data)
  xdlog("签到成功", data)
  if self.activityIndex then
    local queryData = {
      index = self.activityIndex,
      start_time = self.serverSignData and self.serverSignData.start_time or 0,
      end_time = self.serverSignData and self.serverSignData.end_time or 0,
      cur_day = (self.serverSignData and self.serverSignData.cur_day or 0) + 1,
      next_time = 0
    }
    ServiceRecallCCmdProxy.Instance:CallSignQueryInfoRecallCmd(queryData)
  end
end

function RecallSignSubView:OnSignDataUpdate(data)
  xdlog("签到数据更新", data)
  if RecallSignProxy.Instance and RecallSignProxy.Instance:HasServerData() then
    local serverData = RecallSignProxy.Instance:GetSignDataFirst()
    if serverData then
      self.activityIndex = serverData.index
      xdlog("OnSignDataUpdate 重新获取activityIndex:", self.activityIndex)
    end
  end
  self:InitDatas()
  self:RefreshPage()
end

function RecallSignSubView:StartUpdateTimer()
  self:StopUpdateTimer()
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self:UpdateTimeDisplay()
  end, self, "TimeUpdate")
end

function RecallSignSubView:StopUpdateTimer()
  TimeTickManager.Me():ClearTick(self, "TimeUpdate")
end

function RecallSignSubView:OnEnter()
  if RecallSignProxy.Instance and RecallSignProxy.Instance:HasServerData() then
    local serverData = RecallSignProxy.Instance:GetSignDataFirst()
    if serverData then
      self.activityIndex = serverData.index
      xdlog("RecallSignSubView:OnEnter 从服务器数据获取index:", self.activityIndex)
    else
      redlog("RecallSignSubView:OnEnter 服务器数据为空")
      return
    end
  else
    redlog("RecallSignSubView:OnEnter 没有服务器数据")
    return
  end
  self:InitDatas()
  RecallSignSubView.super.OnEnter(self)
  self:RefreshPage()
  self:StartUpdateTimer()
end

function RecallSignSubView:OnShow()
  self:RefreshPage()
  self:StartUpdateTimer()
end

function RecallSignSubView:OnHide()
  self:StopUpdateTimer()
end

function RecallSignSubView:OnExit()
  self:StopUpdateTimer()
  self:ClearSignCells()
  self.currentSignDays = nil
  RecallSignSubView.super.OnExit(self)
end

function RecallSignSubView:OnCellClick(day)
  local cell = self.signCells[day]
  if not cell then
    return
  end
  if cell.status == 2 then
    self:OnSignInDay(day)
  elseif cell.data and cell.data.Reward then
    local reward = cell.data.Reward
    if reward and #reward == 2 then
      local funcData = {}
      funcData.itemdata = ItemData.new("ItemData", reward[1])
      funcData.itemdata:SetItemNum(reward[2] or 1)
      self:ShowItemTip(funcData, cell.icon, NGUIUtil.AnchorSide.Right, {200, 0})
    end
  end
end
