autoImport("NoviceBattlePassTaskCell")
NoviceBattlePassTaskView = class("NoviceBattlePassTaskView", ContainerView)
NoviceBattlePassTaskView.ViewType = UIViewType.PopUpLayer
local proxy = NoviceBattlePassProxy.Instance
local _Table_NoviceBattlePassTask = Table_NoviceBattlePassTask
local _Table_ReturnBattlePassTask = Table_ReturnBattlePassTask

function NoviceBattlePassTaskView:GetDatas()
  local datas
  if self.bPType == 2 then
    datas = proxy:GetReturnBPTaskList()
    table.sort(datas, function(a, b)
      local aData = proxy:GetReturnBPTaskData(a)
      local bData = proxy:GetReturnBPTaskData(b)
      local aSData = _Table_ReturnBattlePassTask[a]
      local bSData = _Table_ReturnBattlePassTask[b]
      if aData.state == bData.state then
        return aSData.Index < bSData.Index
      elseif aData.state == 0 then
        return bData.state == 2
      else
        return aData.state == 1
      end
    end)
  else
    datas = proxy:GetNoviceBPTaskList()
    table.sort(datas, function(a, b)
      local aData = proxy:GetNoviceBPTaskData(a)
      local bData = proxy:GetNoviceBPTaskData(b)
      local aSData = _Table_NoviceBattlePassTask[a]
      local bSData = _Table_NoviceBattlePassTask[b]
      if aData.state == bData.state then
        return aSData.Index < bSData.Index
      elseif aData.state == 0 then
        return bData.state == 2
      else
        return aData.state == 1
      end
    end)
  end
  return datas
end

function NoviceBattlePassTaskView:Init()
  self.bPType = self.viewdata.viewdata and self.viewdata.viewdata.bPType
  self:FindObjs()
  self:AddListenEvt(ServiceEvent.NoviceBattlePassNoviceBPTargetUpdateCmd, self.UpdateTaskList)
  self:AddListenEvt(ServiceEvent.NoviceBattlePassReturnBpTargetUpdateCmd, self.UpdateTaskList)
  self:AddListenEvt(NoviceBattlePassEvent.ReturnBPEnd, self.CloseSelf)
end

function NoviceBattlePassTaskView:FindObjs()
  local taskGrid = self:FindComponent("Grid", UIGrid)
  self.taskList = UIGridListCtrl.new(taskGrid, NoviceBattlePassTaskCell, "NoviceBattlePassTaskCell")
  self.taskList:AddEventListener(NoviceBattlePassEvent.OnGotoBtnClick, self.HandleGotoBtnClick, self)
end

function NoviceBattlePassTaskView:OnEnter()
  self:UpdateTaskList()
end

function NoviceBattlePassTaskView:HandleGotoBtnClick(cellCtrl)
  local staticData = self.bPType == 2 and Table_ReturnBattlePassTask[cellCtrl.id] or Table_NoviceBattlePassTask[cellCtrl.id]
  if staticData then
    local go = staticData.Goto
    if go and 0 < #go then
      if 1 < #go then
        local questIds = staticData.Param.quest_id
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.ShortCutOptionPopUp,
          viewdata = {
            data = questIds or go,
            gotomode = go,
            functiontype = questIds and 2 or 1,
            alignIndex = true
          }
        })
      else
        FuncShortCutFunc.Me():CallByID(go[1])
      end
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, {
        className = "NoviceBattlePassView"
      })
      self:CloseSelf()
      return
    end
    local msg = staticData.Message
    if msg and 0 < #msg then
      if 1 < #msg then
        local param = {}
        for i = 2, #msg do
          param[#param + 1] = msg[i]
        end
        MsgManager.ShowMsgByIDTable(msg[1], param)
      else
        MsgManager.ShowMsgByID(msg[1])
      end
    end
  end
end

function NoviceBattlePassTaskView:UpdateTaskList()
  self.taskList:ResetDatas(self:GetDatas())
  local cells = self.taskList:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:SetBPType(self.bPType)
    end
  end
end
