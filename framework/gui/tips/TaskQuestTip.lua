TaskQuestTip = class("TaskQuestTip", BaseTip)
autoImport("QuestTableCell")
autoImport("QuestTableRewardCell")

function TaskQuestTip:Init()
  TaskQuestTip.super.Init(self)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.grid = self:FindComponent("QuestTable", UITable)
  self.questList = UIGridListCtrl.new(self.grid, QuestTableCell, "QuestTableCell")
  self.questList:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  self.questList:AddEventListener("RefreshListShow", self.HandeRefreshShow, self)
  self.questList:AddEventListener("QuestTableCell_ClickRepair", self.HandleShowRepairPopUp, self)
  local Title = self:FindComponent("Title", UILabel)
  Title.text = ZhString.TaskQuestTip_Accepted
  local emptyLabel = self:FindComponent("emptyLabel", UILabel)
  emptyLabel.text = ZhString.TaskQuestTip_Empty
  self.repairQuestPopUp = self:FindGO("RepairPopUp")
  self.repairPopUp_TweenAlpha = self.repairQuestPopUp:GetComponent(TweenAlpha)
  self.repairQuestPopUp:SetActive(false)
  self.repairPopUp_TweenAlpha:ResetToBeginning()
  self.tipLabel = self:FindGO("TipLabel"):GetComponent(UILabel)
  self.repairBtn = self:FindGO("RepairBtn")
  self.askServiceBtn = self:FindGO("AskServiceBtn")
  self.empty = self:FindGO("empty")
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.repairBtn, function()
    xdlog("点击修理", self.questIdReadyToRepair)
    ServiceQuestProxy.Instance:CallQuestAction(7, self.questIdReadyToRepair)
    MyselfProxy.Instance:SetQuestRepairMode(false)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.askServiceBtn, function()
    self:ApplyService()
    xdlog("请求客服")
    self:CloseSelf()
  end)
end

function TaskQuestTip:HandeRefreshShow(cell)
  self.grid:Reposition()
end

function TaskQuestTip:ClickItem(cell)
  local cells = self.questList:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if single == cell then
      single:setIsSelected(true)
    else
      single:setIsSelected(false)
    end
  end
end

function TaskQuestTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

function TaskQuestTip:SetData()
  self:RefreshMapLimitQuest()
  local list = QuestProxy.Instance:getValidAcceptQuestList(nil, self.mapLimitGroup)
  if list and 0 < #list then
    self:Hide(self.empty)
    self:Show(self.grid.gameObject)
  else
    self:Show(self.empty)
    self:Hide(self.grid)
  end
  list = self:sortQuestList(list)
  self.questList:ResetDatas(list)
end

function TaskQuestTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function TaskQuestTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
  self.closecomp = nil
end

function TaskQuestTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end

function TaskQuestTip:CheckWorldQuestMap()
  local curMapId = Game.MapManager:GetMapID()
  if GameConfig and GameConfig.Quest and GameConfig.Quest and GameConfig.Quest.worldquestmap and type(GameConfig.Quest.worldquestmap[1].map) == "table" then
    local mapGroup = GameConfig.Quest.worldquestmap
    for k, v in pairs(mapGroup) do
      for i = 1, #v.map do
        if curMapId == v.map[i] then
          return k, true
        end
      end
    end
    return nil, false
  end
end

function TaskQuestTip:sortQuestList(list)
  local tempResult = ReusableTable.CreateTable()
  local Result = ReusableTable.CreateTable()
  local worldGroup, isWorldMap = self:CheckWorldQuestMap()
  if 0 < #list then
    for i = 1, #list do
      local single = list[i]
      local questid = single and single.id
      local singleItem = tempResult[questid]
      if Table_FinishTraceInfo and Table_FinishTraceInfo[questid] then
        local traceGroupID = Table_FinishTraceInfo[questid].QuestKey
        if not tempResult[traceGroupID] then
          tempResult[traceGroupID] = {}
          tempResult[traceGroupID].isCombined = true
          tempResult[traceGroupID].curTraceQuest = self.onGoingQuestId
          tempResult[traceGroupID].groupid = traceGroupID
          if not tempResult[traceGroupID].type then
            tempResult[traceGroupID].type = single.type
          end
          if not tempResult[traceGroupID].orderId then
            tempResult[traceGroupID].orderId = questid
          end
          tempResult[traceGroupID].questList = {}
          single.isFinish = false
          table.insert(tempResult[traceGroupID].questList, single)
        else
          single.isFinish = false
          table.insert(tempResult[traceGroupID].questList, single)
        end
      elseif isWorldMap then
        if single.type == "world" or single.type == "worldboss" or single.type == "acc_world" or single.type == "acc_daily_world" then
          for i = 1, #GameConfig.Quest.worldquestmap[worldGroup].map do
            if GameConfig.Quest.worldquestmap[worldGroup].map[i] == single.map then
              tempResult[questid] = single
              tempResult[questid].isCombined = false
              break
            end
          end
        else
          tempResult[questid] = single
          tempResult[questid].isCombined = false
        end
      elseif single.type == "world" or single.type == "worldboss" or single.type == "acc_world" or single.type == "acc_daily_world" then
      else
        tempResult[questid] = single
        tempResult[questid].isCombined = false
      end
    end
  end
  for _, temp in pairs(tempResult) do
    table.insert(Result, temp)
  end
  return Result
end

function TaskQuestTip:RefreshMapLimitQuest()
  local curMap = Game.MapManager:GetMapID()
  local config = GameConfig.Quest.QuestHideMapGroup
  if not config then
    return
  end
  for k, v in pairs(config) do
    if v.map and #v.map > 0 then
      for i = 1, #v.map do
        if v.map[i] == curMap then
          local menuid = v.MenuID or 0
          if not FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
            self.mapLimitGroup = k
            return
          end
        end
      end
    end
  end
  self.mapLimitGroup = nil
end

function TaskQuestTip:HandleShowRepairPopUp(cellCtrl)
  if cellCtrl and cellCtrl.data then
    local data = cellCtrl.data
    local questName = data.staticData.Name or ""
    self.tipLabel.text = string.format(ZhString.QuestRepair_HelpTip, questName)
    self.repairQuestPopUp:SetActive(true)
    self.repairPopUp_TweenAlpha:ResetToBeginning()
    self.repairPopUp_TweenAlpha:PlayForward()
    self.questIdReadyToRepair = data.id
  end
end

function TaskQuestTip:ApplyService()
  if BranchMgr.IsChina() then
    local url = "https://www.xd.com/service/form/ro/"
    Application.OpenURL(url)
  elseif BranchMgr.IsTW() then
    local url = "https://www.gnjoy.com.tw/Cs"
    Application.OpenURL(url)
  else
    local server = FunctionLogin.Me():getCurServerData()
    local serverID = server ~= nil and server.sid or 1
    local resVersion = VersionUpdateManager.CurrentVersion
    if resVersion == nil then
      resVersion = "Unknown"
    end
    local currentVersion = CompatibilityVersion.version
    local bundleVersion = GetAppBundleVersion.BundleVersion
    local version = string.format("%s,%s,%s", resVersion, currentVersion, bundleVersion)
    FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
  end
end
