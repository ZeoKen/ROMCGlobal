local SkillCMD = {}
setmetatable(SkillCMD, {
  __index = AI_CMD_Myself_Skill_Run
})

function SkillCMD:Start(time, deltaTime, creature)
  return AI_CMD_Myself_Skill_Run.Start(self, time, deltaTime, creature, nil, nil, self.args[7], self.args[9], self.args[10], self.args[11], self.args[16])
end

function SkillCMD.ToString()
  return "AI_CMD_Myself_Skill_TargetNone", SkillCMD
end

return SkillCMD
