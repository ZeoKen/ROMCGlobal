local baseCell = autoImport("BaseCell")
NoviceExpGuideCell = reusableClass("NoviceExpGuideCell", baseCell)
local tempVector3 = LuaVector3.Zero()

function NoviceExpGuideCell:Init()
  self:FindObjs()
end

function NoviceExpGuideCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.desc = self:FindGO("Desc"):GetComponent(UIRichLabel)
  self.desc = SpriteLabel.new(self.desc, nil, 20, 20, true)
  self.goToBtn = self:FindGO("GoToBtn")
  self.finishSymbol = self:FindGO("FinishSymbol")
  self:AddClickEvent(self.goToBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function NoviceExpGuideCell:SetData(data)
  self.data = data
  self.name.text = data.Text
  local descStr = data.Desc
  if descStr then
    self.desc:SetText(descStr)
    self.desc:SetText(descStr)
  end
  local iconName = data.Icon
  if iconName and not IconManager:SetItemIcon(iconName, self.icon) then
    IconManager:SetUIIcon(iconName, self.icon)
  end
  self:RefreshStatus()
end

function NoviceExpGuideCell:SetStatus(bool)
  xdlog("SetStatus", bool, self.name.text)
  self.finishSymbol:SetActive(bool)
  self.isFinish = bool
end

function NoviceExpGuideCell:RefreshStatus()
  local params = self.data and self.data.Params
  local completeType = self.data and self.data.complete_con
  if completeType == "BattleTime" then
    self:SetStatus(false)
  elseif completeType == "Quest" then
    local list = QuestProxy.Instance:getValidAcceptQuestList()
    if not list or #list == 0 then
      self:SetStatus(true)
    else
      self:SetStatus(false)
    end
  elseif completeType == "Wanted" then
    local finishCount = 0
    local questListData = QuestProxy.Instance:getWantedQuest()
    for i = 1, #questListData do
      local single = questListData[i]:getQuestListType()
      if single == SceneQuest_pb.EQUESTLIST_SUBMIT then
        finishCount = finishCount + 1
      end
    end
    local maxCount = QuestProxy.Instance:getMaxWanted()
    xdlog("委托进度", finishCount, maxCount)
    self:SetStatus(finishCount >= maxCount)
  elseif completeType == "WorldQuest" then
    local mapid = params and params.mapid or 149
    local worldQuestGroup = Game.MapManager:GetWorldQuestGroupByMapID(mapid)
    if not worldQuestGroup then
      redlog("当前地图不在冒险任务组内")
      return
    end
    local curProcess = QuestProxy.Instance:GetWorldCount(worldQuestGroup)
    xdlog("当前组的进度", worldQuestGroup, curProcess)
    self:SetStatus(4 <= curProcess)
  else
    self:SetStatus(false)
  end
end
