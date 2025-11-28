local AskUseSkillCommand = class("AskUseSkillCommand", pm.SimpleCommand)

function AskUseSkillCommand:execute(note)
  local skillID = note.body
  local target, auto, quickuse
  if type(skillID) == "table" then
    target = skillID.target
    auto = skillID.auto
    quickuse = skillID.quickuse
    skillID = skillID.skill
  end
  helplog("AskUseSkillCommand ", skillID, target)
  FunctionSkill.Me():TryUseSkill(skillID, target, nil, auto, quickuse, true)
end

return AskUseSkillCommand
