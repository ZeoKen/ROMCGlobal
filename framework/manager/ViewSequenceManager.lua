autoImport("ViewSequence")
ViewSequenceManager = class("ViewSequenceManager")
ViewSequenceManager.MaxViewSequenceCount = 10

function ViewSequenceManager.Me()
  if ViewSequenceManager.me == nil then
    ViewSequenceManager.me = ViewSequenceManager.new()
  end
  return ViewSequenceManager.me
end

function ViewSequenceManager:ctor()
  self.viewSequenceMap = {}
  EventManager.Me():AddEventListener(UIEvent.EnterView, self.OnEnterView, self)
  EventManager.Me():AddEventListener(UIEvent.ExitView, self.OnExitView, self)
end

function ViewSequenceManager:OnEnterView(note)
  local viewCtrl = note.data
  if not viewCtrl then
    return
  end
  self:_ForEachViewSequence(ViewSequence.OnEnterView, viewCtrl)
end

function ViewSequenceManager:OnExitView(note)
  local viewCtrl = note.data
  if not viewCtrl then
    return
  end
  self:_ForEachViewSequence(ViewSequence.OnExitView, viewCtrl)
end

function ViewSequenceManager:CreateViewSequence(owner)
  self.viewSequenceMap[owner] = self.viewSequenceMap[owner] or {}
  local id = 0
  for i = 1, ViewSequenceManager.MaxViewSequenceCount do
    if self.viewSequenceMap[owner][i] == nil then
      id = i
      break
    end
  end
  if id == 0 then
    LogUtility.Warning("ViewSequence已满")
    return
  end
  local viewSequence = self.viewSequenceMap[owner][id]
  if viewSequence then
    viewSequence:ResetData(owner, id)
  else
    viewSequence = ViewSequence.new(owner, id)
    self.viewSequenceMap[owner][id] = viewSequence
  end
  return viewSequence
end

function ViewSequenceManager:HasViewSequence(owner, id)
  local viewSequences = self.viewSequenceMap[owner]
  return viewSequences ~= nil and viewSequences[id] ~= nil
end

function ViewSequenceManager:ClearViewSequence(owner, id)
  if not self.viewSequenceMap[owner] then
    return
  end
  if id then
    self.viewSequenceMap[owner][id] = nil
    if not next(self.viewSequenceMap[owner]) then
      self.viewSequenceMap[owner] = nil
    end
  else
    self.viewSequenceMap[owner] = nil
  end
end

function ViewSequenceManager:ClearAll()
  TableUtility.TableClear(self.viewSequenceMap)
end

function ViewSequenceManager:GetWorkingViewSequenceCount()
  local count = 0
  self:_ForEachViewSequence(function(sequence)
    if sequence.isWorking then
      count = count + 1
    end
  end)
  return count
end

function ViewSequenceManager:_ForEachViewSequence(action, ...)
  for _, sequences in pairs(self.viewSequenceMap) do
    for _, sequence in pairs(sequences) do
      action(sequence, ...)
    end
  end
end
