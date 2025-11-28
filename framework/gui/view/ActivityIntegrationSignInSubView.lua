ActivityIntegrationSignInSubView = class("ActivityIntegrationSignInSubView", SubView)
autoImport("ActivityIntegrationSignInCell")
local Prefab_Path = ResourcePathHelper.UIView("ActivityIntegrationSignInSubView")
local picIns = PictureManager.Instance

function ActivityIntegrationSignInSubView:Init()
  if self.inited then
    return
  end
  self:LoadPrefab()
  self:FindObjs()
  self:AddViewEvts()
  self.inited = true
end

function ActivityIntegrationSignInSubView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityIntegrationSignInSubView"
  self.gameObject = obj
end

function ActivityIntegrationSignInSubView:FindObjs()
  self.titleLabel = self:FindGO("TitleLabel", self.gameObject):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel", self.gameObject):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self.signScrollView = self:FindGO("SignScrollView", self.gameObject):GetComponent(UIScrollView)
  self.signGrid = self:FindGO("SignGrid", self.gameObject):GetComponent(UIGrid)
  self.signListCtrl = UIGridListCtrl.new(self.signGrid, ActivityIntegrationSignInCell, "ActivityIntegrationSignInCell")
  self.signListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickSignInCell, self)
  self.confirmBtn = self:FindGO("ConfirmButton", self.gameObject)
  self.confirmBtnLock = self:FindGO("ConfirmButtonLock", self.gameObject)
  self.confirmBtnLock_Label = self:FindGO("Label", self.confirmBtnLock):GetComponent(UILabel)
  self.bgTexture = self:FindGO("BgTexture", self.gameObject):GetComponent(UITexture)
  self:AddClickEvent(self.confirmBtn, function()
    if ActivityIntegrationProxy.Instance:CheckSuperSignInCanSign(self.activityID) then
      ActivityIntegrationProxy.Instance:CallSignInUserCmd(self.activityID)
    end
  end)
  self:AddClickEvent(self.helpBtn, function()
    self.container:HandleClickHelpBtn(self.staticData.HelpID)
  end)
  self.conditionPart = self:FindGO("ConditionPart", self.gameObject)
  self.conditionIcon = self:FindGO("ConditionIcon", self.conditionPart)
  self.conditionLabel = self:FindGO("ConditionLabel", self.conditionIcon):GetComponent(UILabel)
  self.goToBtn = self:FindGO("GoToBtn", self.conditionPart)
  self:AddClickEvent(self.goToBtn, function()
    FuncShortCutFunc.Me():CallByID(2083)
  end)
end

function ActivityIntegrationSignInSubView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3SuperSignInUserCmd, self.RefreshPage)
end

function ActivityIntegrationSignInSubView:RefreshPage(id)
  xdlog("ActivityIntegrationSignInSubView RefreshPage")
  self.titleLabel.text = self.staticData.TitleName
  local helpID = self.staticData.HelpID
  self.helpBtn:SetActive(helpID ~= nil or false)
  local isTF = EnvChannel.IsTFBranch()
  local duration = isTF and self.staticData.TFDuration or self.staticData.Duration
  self.startTime = duration[1] and KFCARCameraProxy.Instance:GetSelfCustomDate(duration[1])
  self.endTime = duration[2] and KFCARCameraProxy.Instance:GetSelfCustomDate(duration[2])
  local _activityIntegrationProxy = ActivityIntegrationProxy.Instance
  local signInList = _activityIntegrationProxy:GetActivitySignInData(self.activityID)
  local signInInfo = _activityIntegrationProxy:GetSuperSignInInfo(self.activityID)
  local signInDay = signInInfo and signInInfo.day or 0
  local maxBatch = math.ceil(#signInList / 30)
  local curBatch = math.floor(signInDay / 30) + 1
  if maxBatch < curBatch then
    curBatch = maxBatch
  end
  local showList = {}
  for i = (curBatch - 1) * 30 + 1, curBatch * 30 do
    signInList[i].index = i
    table.insert(showList, signInList[i])
  end
  xdlog("首尾", (curBatch - 1) * 30 + 1, curBatch * 30, #showList)
  self.signListCtrl:ResetDatas(showList, true)
  local cells = self.signListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i].index and signInDay >= cells[i].index then
      cells[i]:SetStatus(3)
    else
      cells[i]:SetStatus(1)
    end
  end
  local canSign, status, curProcess, targetCount = _activityIntegrationProxy:CheckSuperSignInCanSign(self.activityID)
  xdlog(canSign, signInDay, status, targetCount)
  if canSign then
    self.conditionPart:SetActive(false)
    self.confirmBtn:SetActive(true)
    self.confirmBtnLock:SetActive(false)
    for i = 1, #cells do
      if cells[i].index == signInDay + 1 then
        cells[i]:SetStatus(2)
      end
    end
    self.timeLabel.gameObject:SetActive(false)
    TimeTickManager.Me():ClearTick(self, 1)
  elseif status == 3 then
    self.conditionPart:SetActive(true)
    if curProcess and targetCount then
      self.conditionLabel.text = string.format(ZhString.ActivityIntegration_ServantDailyCondition, curProcess, targetCount)
    end
    local printedX = self.conditionLabel.printedSize.x
    local offsetX = (printedX + 210) / 2 - 80
    self.conditionIcon.transform.localPosition = LuaGeometry.GetTempVector3(offsetX / 2 - printedX - 50, 11, 0)
    self.goToBtn.transform.localPosition = LuaGeometry.GetTempVector3(offsetX / 2 + 75, 9, 0)
    self.timeLabel.gameObject:SetActive(false)
    self.confirmBtn:SetActive(false)
    self.confirmBtnLock:SetActive(false)
  else
    self.conditionPart:SetActive(false)
    self.nextRefreshTime = ClientTimeUtil.GetNextDailyRefreshTime()
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(100, 1000, self.UpdateRefreshTime, self, 1)
    self.timeLabel.gameObject:SetActive(true)
    self.confirmBtn:SetActive(false)
    self.confirmBtnLock:SetActive(true)
  end
end

function ActivityIntegrationSignInSubView:UpdateRefreshTime()
  if not self.nextRefreshTime then
    TimeTickManager.Me():ClearTick(self, 1)
    return
  end
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.nextRefreshTime)
  self.timeLabel.text = string.format(ZhString.ActivityIntegration_SignInRefreshTime, leftHour, leftMin, leftSec)
  if leftHour <= 0 and leftMin <= 0 and leftSec <= 0 then
    xdlog("活动结束 尝试刷新界面")
    TimeTickManager.Me():ClearTick(self, 1)
    self:RefreshPage()
  end
end

function ActivityIntegrationSignInSubView:HandleClickSignInCell(cellCtrl)
  local status = cellCtrl.status or 0
  if status == 2 then
    xdlog("当日  签到")
    ActivityIntegrationProxy.Instance:CallSignInUserCmd(self.activityID)
  else
    self:ShowItemInfo(cellCtrl)
  end
end

function ActivityIntegrationSignInSubView:ShowItemInfo(cellCtrl)
  local itemid = cellCtrl and cellCtrl.staticData and cellCtrl.staticData.id
  if itemid == nil then
    return
  end
  local sdata = {
    itemdata = ItemData.new("Reward", itemid),
    funcConfig = {}
  }
  self:ShowItemTip(sdata, cellCtrl.icon, nil, {-280, 0})
end

function ActivityIntegrationSignInSubView:OnEnter(id)
  self.staticData = Table_ActivityIntegration[id]
  if not self.staticData then
    redlog("Table_ActivityIntegration缺少配置", id)
    return
  end
  ActivityIntegrationSignInSubView.super.OnEnter(self)
  self.activityID = self.staticData.Params and self.staticData.Params.ActivityId
  if not self.activityID then
    redlog("活动ID不存在")
    return
  end
  local params = self.staticData.Params
  self.textureName = params and params.Texture
  picIns:SetUI(self.textureName, self.bgTexture)
  self:RefreshPage(id)
end

function ActivityIntegrationSignInSubView:OnExit()
  ActivityIntegrationSignInSubView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  picIns:UnLoadUI(self.textureName, self.bgTexture)
  self.textureName = nil
end
