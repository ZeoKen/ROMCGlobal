ActivityIntegrationQuestSubView = class("ActivityIntegrationQuestSubView", SubView)
autoImport("ActivityIntegrationQuestCell")
local Prefab_Path = ResourcePathHelper.UIView("ActivityIntegrationSignInSubView")
local picIns = PictureManager.Instance

function ActivityIntegrationQuestSubView:Init()
  if self.inited then
    return
  end
  self:LoadPrefab()
  self:FindObjs()
  self:AddViewEvts()
  self.inited = true
end

function ActivityIntegrationQuestSubView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityIntegrationQuestSubView"
  self.gameObject = obj
end

function ActivityIntegrationQuestSubView:FindObjs()
  self.titleLabel = self:FindGO("TitleLabel", self.gameObject):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel", self.gameObject):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self.signScrollView = self:FindGO("SignScrollView", self.gameObject):GetComponent(UIScrollView)
  self.signGrid = self:FindGO("SignGrid", self.gameObject):GetComponent(UIGrid)
  self.signListCtrl = UIGridListCtrl.new(self.signGrid, ActivityIntegrationQuestCell, "ActivityIntegrationSignInCell")
  self.signListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickSignInCell, self)
  self.confirmBtn = self:FindGO("ConfirmButton", self.gameObject)
  self.confirmBtn_Label = self:FindGO("Label", self.confirmBtn):GetComponent(UILabel)
  self.confirmBtnLock = self:FindGO("ConfirmButtonLock", self.gameObject)
  self.confirmBtnLock_Label = self:FindGO("Label", self.confirmBtnLock):GetComponent(UILabel)
  self.confirmBtn_Label.text = ZhString.ActivityData_GoLabelText
  self.confirmBtnLock_Label.text = ZhString.CollectGroupScoreTip_ReceivedBtn
  self.bgTexture = self:FindGO("BgTexture", self.gameObject):GetComponent(UITexture)
  self:AddClickEvent(self.confirmBtn, function()
    xdlog("执行寻路")
    self:TryGoTo()
  end)
  self:AddClickEvent(self.helpBtn, function()
    self.container:HandleClickHelpBtn(self.staticData.HelpID)
  end)
  self.titleLabel.gradientTop = LuaGeometry.GetTempVector4(1, 0.7411764705882353, 0.24313725490196078, 1)
  self.titleLabel.gradientBottom = LuaGeometry.GetTempVector4(0.7803921568627451, 0.4117647058823529, 0.1411764705882353, 1)
end

function ActivityIntegrationQuestSubView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3QueryQuestSignInfoUserCmd, self.handleQueryQuestSignInfo, self)
end

function ActivityIntegrationQuestSubView:RefreshPage(id)
  xdlog("ActivityIntegrationQuestSubView RefreshPage")
  if not Table_ActivityQuestSign or not self.groupid then
    return
  end
  self.titleLabel.text = self.staticData.TitleName
  local helpID = self.staticData.HelpID
  self.helpBtn:SetActive(helpID ~= nil or false)
  self.timeLabel.gameObject:SetActive(false)
  local questSignInfo = ActivityIntegrationProxy.Instance:GetQuestSignInfo(self.groupid)
  if not questSignInfo then
    return
  end
  local list = {}
  for k, v in pairs(Table_ActivityQuestSign) do
    if v.GroupID == self.groupid then
      local status = questSignInfo[v.QuestID] or 0
      local tempData = {
        id = k,
        status = status,
        questid = v.QuestID,
        shortcutpower = v.ShortCutPower
      }
      table.insert(list, tempData)
    end
  end
  table.sort(list, function(l, r)
    if l.id ~= r.id then
      return l.id < r.id
    end
  end)
  local isAllFinish = true
  for i = 1, #list do
    if list[i].status ~= 2 then
      isAllFinish = false
    end
    local questid = list[i].questid
    local questData = questid and QuestProxy.Instance:getQuestDataByQuestID(questid)
    if questData then
      list[i].status = 3
      if not self.inProcessQuestID then
        self.inProcessQuestID = questid
      end
      xdlog("进行中任务", self.inProcessQuestID)
      self.shortCutPowerID = list[i].shortcutpower
    end
  end
  self.signListCtrl:ResetDatas(list)
  if isAllFinish then
    self.confirmBtn:SetActive(false)
    self.confirmBtnLock:SetActive(false)
  elseif self.inProcessQuestID then
    xdlog("有进行中任务  刷新按钮")
    self.confirmBtn:SetActive(true)
    self.confirmBtnLock:SetActive(false)
  else
    self.confirmBtn:SetActive(false)
    self.confirmBtnLock:SetActive(true)
  end
end

function ActivityIntegrationQuestSubView:TryGoTo()
  if self.inProcessQuestID then
    local questData = QuestProxy.Instance:getQuestDataByQuestID(self.inProcessQuestID)
    if questData then
      GameFacade.Instance:sendNotification(QuestEvent.QuestTraceSwitch, questData)
      FunctionQuest.Me():executeQuest(questData)
      if self.container then
        self.container:CloseSelf()
      end
    else
      redlog("没有找到任务")
      if self.shortCutPowerID then
        FuncShortCutFunc.Me():CallByID(self.shortCutPowerID)
      end
    end
  end
end

function ActivityIntegrationQuestSubView:handleQueryQuestSignInfo()
  self:RefreshPage()
end

function ActivityIntegrationQuestSubView:HandleClickSignInCell(cellCtrl)
  local status = cellCtrl.status or 0
  if status == 3 then
    self:TryGoTo()
  else
    self:ShowItemInfo(cellCtrl)
  end
end

function ActivityIntegrationQuestSubView:ShowItemInfo(cellCtrl)
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

function ActivityIntegrationQuestSubView:OnEnter(id)
  self.staticData = Table_ActivityIntegration[id]
  if not self.staticData then
    redlog("Table_ActivityIntegration缺少配置", id)
    return
  end
  ActivityIntegrationQuestSubView.super.OnEnter(self)
  self.groupid = self.staticData.Params and self.staticData.Params.Group
  if not self.groupid then
    redlog("任务组不存在")
    return
  end
  local params = self.staticData.Params
  self.textureName = params and params.Texture
  picIns:SetUI(self.textureName, self.bgTexture)
  ServiceSceneUser3Proxy.Instance:CallQueryQuestSignInfoUserCmd(self.groupid)
  self:RefreshPage(id)
end

function ActivityIntegrationQuestSubView:OnExit()
  ActivityIntegrationQuestSubView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  picIns:UnLoadUI(self.textureName, self.bgTexture)
  self.textureName = nil
  self.inProcessQuestID = nil
  self.shortCutPowerID = nil
end
