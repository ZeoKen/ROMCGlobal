autoImport("SgBaseTrigger")
SgResetBirthTrigger = class("SgResetBirthTrigger", SgBaseTrigger)

function SgResetBirthTrigger:initData(tc, uid, historyData)
  SgResetBirthTrigger.super.initData(self, tc, uid, historyData)
  self.m_npcIds = {}
  local tmp = tc.NpcIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_npcIds, tmp[i])
    end
  end
end

function SgResetBirthTrigger:onExecute()
  if SgAIManager.Me():triggerIsVisited(self:getUid()) then
    return
  end
  local allNpcs = SgAIManager.Me():getAllNpcs()
  for _, v in pairs(allNpcs) do
    for _, uid in ipairs(self.m_npcIds) do
      if v:getUid() == uid and not v:isDead() then
        v.m_npc:ChangedBirth()
      end
    end
  end
  SgAIManager.Me():visitedTrigger(self:getUid())
end
