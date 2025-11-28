MainViewRaidInfoPage = class("MainViewRaidInfoPage", MainViewDungeonInfoSubPage)
autoImport("RaidTaskCell")

function MainViewRaidInfoPage:Init()
  self:ReLoadPerferb("view/MainViewRaidInfoPage")
  self:InitUI()
  self:AddViewEvents()
end

function MainViewRaidInfoPage:InitUI()
  self.raidScrollView = self:FindGO("raidScrollView"):GetComponent(UIScrollView)
  self.raidTaskBord = self:FindGO("raidTaskBord"):GetComponent(UITable)
  self.raidTaskBg = self:FindGO("raidTaskBg")
  self.raidTaskBg:SetActive(false)
  self.questList = UIGridListCtrl.new(self.raidTaskBord, RaidTaskCell, "TaskQuestCell")
  self.questList:AddEventListener(MouseEvent.MouseClick, self.raidTaskCellClick, self)
  local objLua = self.gameObject:GetComponent(GameObjectForLua)
  
  function objLua.onEnable()
    self.raidTaskBord:Reposition()
    self.raidScrollView:ResetPosition()
  end
end

function MainViewRaidInfoPage:AddViewEvents()
  self:AddListenEvt(ServiceEvent.FuBenCmdFubenStepSyncCmd, self.UpdateRaidTask)
  self:AddListenEvt(ServiceEvent.FuBenCmdFuBenProgressSyncCmd, self.UpdateRaidTask)
  self:AddListenEvt(ServiceEvent.FuBenCmdFuBenClearInfoCmd, self.UpdateRaidTask)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.UpdateRaidTask)
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.UpdateRaidTask)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.UpdateRaidTask)
end

function MainViewRaidInfoPage:UpdateRaidTask()
  local questList = QuestProxy.Instance:getCurRaidQuest()
  local result = {}
  for i = 1, #questList do
    local single = questList[i]
    if single.staticData and single.staticData.TraceInfo ~= "" then
      table.insert(result, single)
    end
  end
  self.raidTaskBg:SetActive(0 < #result)
  self.questList:ResetDatas(result)
  if #result == 1 then
    local cells = self.questList:GetCells()
    if cells and cells[1] then
      local height = cells[1].bgSprite.height
      if height < 224 then
        cells[1].bgSprite.height = 224
      end
    end
  end
  self.raidTaskBord:Reposition()
  self.raidScrollView:ResetPosition()
  self:HandleProcessShutDown()
end

function MainViewRaidInfoPage:raidTaskCellClick(cellCtrl)
  if not cellCtrl or not cellCtrl.data then
    return
  end
  local cells = self.questList:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:SetChoose(false)
    end
  end
  cellCtrl:SetChoose(true)
  if cellCtrl.data.questDataStepType == QuestDataStepType.QuestDataStepType_KILLALL or cellCtrl.data.questDataStepType == "npchp" then
    self.needClearCmd = true
  else
    self.needClearCmd = false
  end
  FunctionQuest.Me():executeQuest(cellCtrl.data, true)
  if cellCtrl.data.params.invisible and cellCtrl.data.params.invisible == 1 then
  else
    FunctionQuest.Me():addQuestMiniShow(cellCtrl.data)
  end
end

function MainViewRaidInfoPage:HandleProcessShutDown()
  if self.needClearCmd then
    FunctionSystem.InterruptMyselfAI()
  end
end
