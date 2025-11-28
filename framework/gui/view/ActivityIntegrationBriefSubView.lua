ActivityIntegrationBriefSubView = class("ActivityIntegrationBriefSubView", SubView)
autoImport("ActivityIntegrationSignInCell")
local Prefab_Path = ResourcePathHelper.UIView("ActivityIntegrationBriefSubView")
local picIns = PictureManager.Instance
autoImport("ActivityIntegrationBriefCell")

function ActivityIntegrationBriefSubView:Init()
  if self.inited then
    return
  end
  self:LoadPrefab()
  self:FindObjs()
  self:AddViewEvts()
  self.inited = true
end

function ActivityIntegrationBriefSubView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityIntegrationBriefSubView"
  self.gameObject = obj
end

function ActivityIntegrationBriefSubView:FindObjs()
  self.bgTexture = self:FindGO("BgTexture", self.gameObject):GetComponent(UITexture)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self:AddClickEvent(self.helpBtn, function()
    self.container:HandleClickHelpBtn(self.staticData.HelpID)
  end)
  self.shortCutRoot = self:FindGO("ShortCutRoot", self.gameObject)
  self.roots = {}
  for i = 1, 4 do
    local go = self:FindGO("Root" .. i, self.shortCutRoot)
    local dayLabel = self:FindGO("DayLabel", go):GetComponent(UILabel)
    local grid = self:FindGO("Grid", go):GetComponent(UIGrid)
    local listCtrl = UIGridListCtrl.new(grid, ActivityIntegrationBriefCell, "ActivityIntegrationBriefCell")
    listCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickGoTo, self)
    self.roots[i] = {dayLabel = dayLabel, listCtrl = listCtrl}
  end
end

function ActivityIntegrationBriefSubView:AddViewEvts()
end

function ActivityIntegrationBriefSubView:RefreshPage()
  xdlog("Brief  RefreshPage")
  local helpID = self.staticData.HelpID
  self.helpBtn:SetActive(helpID ~= nil or false)
  local briefList = self.staticData and self.staticData.Params and self.staticData.Params.Brief
  if briefList then
    local tempList = {}
    local i = 1
    for k, v in pairs(briefList) do
      local tempData = {day = k, brief = v}
      table.insert(tempList, tempData)
    end
    table.sort(tempList, function(l, r)
      local l_day = l.day or 0
      local r_day = r.day or 0
      if l_day ~= r_day then
        return l_day < r_day
      end
    end)
    local createDay = ActivityIntegrationProxy.Instance.createDay or 1
    for i = 1, #tempList do
      local root = self.roots[i]
      local isUnlock = createDay < tempList[i].day
      root.dayLabel.text = isUnlock and os.date(ZhString.ActivityIntegration_UnlockTip, ActivityIntegrationProxy.Instance:GetUnlockTime(tempList[i].day)) or tempList[i].brief.Title
      root.listCtrl:ResetDatas(tempList[i].brief.Reward)
      local cells = root.listCtrl:GetCells()
      for j = 1, #cells do
        cells[j]:SetLockStatus(createDay < tempList[i].day)
      end
    end
  end
end

function ActivityIntegrationBriefSubView:handleClickGoTo(cellCtrl)
  local shortCutID = cellCtrl and cellCtrl.shortCutPowerID
  if shortCutID then
    local config = Table_ShortcutPower[shortCutID]
    local viewdata = config and config.Event and config.Event.viewdata
    if viewdata then
      local groupid = viewdata.group
      local groupValid = groupid and ActivityIntegrationProxy.Instance:CheckGroupValid(groupid) or false
      if groupValid then
        local subTabID = viewdata.tab
        local subTabValid = subTabID and ActivityIntegrationProxy.Instance:CheckSubTabValid(subTabID) or false
        if not subTabValid then
          MsgManager.ShowMsgByID(40973)
          return
        end
      else
        MsgManager.ShowMsgByID(40973)
        return
      end
    end
    FuncShortCutFunc.Me():CallByID(shortCutID)
    if self.container then
      self.container:CloseSelf()
    end
  end
end

function ActivityIntegrationBriefSubView:OnEnter(id)
  self.staticData = Table_ActivityIntegration[id]
  if not self.staticData then
    redlog("Table_ActivityIntegration缺少配置", id)
    return
  end
  ActivityIntegrationBriefSubView.super.OnEnter(self)
  local params = self.staticData.Params
  self.textureName = params and params.Texture
  picIns:SetUI(self.textureName, self.bgTexture)
  self:RefreshPage(id)
end

function ActivityIntegrationBriefSubView:OnExit()
  ActivityIntegrationBriefSubView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  picIns:UnLoadUI(self.textureName, self.bgTexture)
  self.textureName = nil
end
