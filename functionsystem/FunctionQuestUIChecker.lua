FunctionQuestUIChecker = class("FunctionQuestUIChecker", EventDispatcher)

function FunctionQuestUIChecker.Me()
  if not FunctionQuestUIChecker.Instance then
    FunctionQuestUIChecker.Instance = FunctionQuestUIChecker.new()
  end
  return FunctionQuestUIChecker.Instance
end

function FunctionQuestUIChecker:ctor()
  EventManager.Me():AddEventListener(UIEvent.EnterView, self.OnEnterView, self)
  EventManager.Me():AddEventListener(UIEvent.ExitView, self.OnExitView, self)
  self.uiCheckMap = {}
end

function FunctionQuestUIChecker:AddCheck(viewName, questId, onEnterFunc, onExitFunc)
  local checker = self.uiCheckMap[viewName]
  if not checker then
    checker = {}
    checker.viewName = viewName
    checker.questId = questId
    checker.onEnter = onEnterFunc
    checker.onExit = onExitFunc
    self.uiCheckMap[viewName] = checker
  end
end

function FunctionQuestUIChecker:RemoveCheck(viewName)
  self.uiCheckMap[viewName] = nil
end

function FunctionQuestUIChecker:OnEnterView(note)
  local viewName = note.data.__cname
  local checker = self.uiCheckMap[viewName]
  if checker then
    local enterFunc = checker.onEnter
    if enterFunc then
      enterFunc(viewName, checker.questId)
    end
  end
end

function FunctionQuestUIChecker:OnExitView(note)
  local viewName = note.data.__cname
  local checker = self.uiCheckMap[viewName]
  if checker then
    local exitFunc = checker.onExit
    if exitFunc then
      exitFunc(viewName, checker.questId)
    end
  end
end
