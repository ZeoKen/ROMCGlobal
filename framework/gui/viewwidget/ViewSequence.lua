ViewSequence = class("ViewSequence")
local tableClear

function ViewSequence:ctor(owner, id)
  if not tableClear then
    tableClear = TableUtility.TableClear
  end
  self:ResetData(owner, id)
end

function ViewSequence:ResetData(owner, id)
  self.owner = owner
  self.id = id
  self.sequence = self.sequence or {}
  self.sequenceViewDatas = self.sequenceViewDatas or {}
  self:Clear()
end

function ViewSequence:Insert(i, viewName, viewData)
  if not i or i <= 0 or i > #self.sequence + 1 then
    LogUtility.Warning("You're trying to insert into ViewSequence with an invalid index!")
    return
  end
  if not viewName then
    return
  end
  table.insert(self.sequence, i, viewName)
  table.insert(self.sequenceViewDatas, i, viewData ~= nil and viewData or _EmptyTable)
  LogUtility.InfoFormat("ViewSequence {0}: Inserted View '{1}'", self.id, viewName)
end

function ViewSequence:Append(viewName, viewData)
  local blockData = GameConfig.ViewSequenceBlock and GameConfig.ViewSequenceBlock[viewName]
  if blockData then
    local mapId = Game.MapManager:GetMapID()
    local mapBlock = TableUtil.ArrayIndexOf(blockData.map or {}, mapId) > 0
    local menuIdBlock = not FunctionUnLockFunc.Me():CheckCanOpen(blockData.MenuID)
    if mapBlock and menuIdBlock then
      return
    end
  end
  self:Insert(#self.sequence + 1, viewName, viewData)
end

function ViewSequence:Prepend(viewName, viewData)
  self:Insert(1, viewName, viewData)
end

function ViewSequence:Remove(i)
  if not i or i <= 0 or i > #self.sequence then
    LogUtility.Warning("You're trying to remove from ViewSequence with an invalid index!")
    return
  end
  table.remove(self.sequence, i)
  table.remove(self.sequenceViewDatas, i)
end

function ViewSequence:RemoveView(viewName)
  if type(viewName) ~= "string" then
    return
  end
  for i = #self.sequence, 1, -1 do
    if self.sequence[i] == viewName then
      table.remove(self.sequence, i)
      table.remove(self.sequenceViewDatas, i)
    end
  end
end

function ViewSequence:Clear()
  tableClear(self.sequence)
  tableClear(self.sequenceViewDatas)
  self.isWorking = false
  self.curView = nil
end

function ViewSequence:Launch()
  self.isWorking = true
  self:Next()
end

function ViewSequence:Next()
  if not next(self.sequence) then
    self:Clear()
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig[self.sequence[1]],
    viewdata = self.sequenceViewDatas[1]
  })
end

function ViewSequence:OnEnterView(viewCtrl)
  if not self.isWorking then
    return
  end
  if viewCtrl and viewCtrl.__cname == self.sequence[1] then
    self.curView = viewCtrl
    self:Remove(1)
  end
end

function ViewSequence:OnExitView(viewCtrl)
  if not self.isWorking then
    return
  end
  if viewCtrl == self.curView then
    self:Next()
  end
end

function ViewSequence:Interrupt(closeCurrent)
  if closeCurrent == nil then
    closeCurrent = true
  end
  if closeCurrent and self.curView then
    self.curView:CloseSelf()
  end
  self:Clear()
end

function ViewSequence:IsHaveView(viewName)
  if type(viewName) ~= "string" then
    return false
  end
  for k, v in pairs(self.sequence) do
    if v == viewName then
      return true
    end
  end
  return false
end
