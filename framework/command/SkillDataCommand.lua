local SkillDataCommand = class("SkillDataCommand", pm.SimpleCommand)

function SkillDataCommand:execute(note)
  if note ~= nil then
    if note.name == ServiceEvent.SkillReqSkillData then
      self:ReqSkillData(note)
    elseif note.name == ServiceEvent.SkillSkillUpdate then
      self:Update(note)
    end
  end
end

function SkillDataCommand:ReqSkillData(note)
  FunctionSkillEnableCheck.Me():ResetConditionCache()
  SkillProxy.Instance:ServerReInit(note.body)
  InheritSkillProxy.Instance:ServerReInit(note.body)
  self.facade:sendNotification(SkillEvent.SkillUpdate)
  EventManager.Me():PassEvent(SkillEvent.SkillUpdate)
end

function SkillDataCommand:Update(note)
  local dirtyGUIDMap = SkillProxy.Instance:Update(note.body)
  self.facade:sendNotification(SkillEvent.SkillUpdate)
  EventManager.Me():PassEvent(SkillEvent.SkillUpdate, dirtyGUIDMap)
end

return SkillDataCommand
