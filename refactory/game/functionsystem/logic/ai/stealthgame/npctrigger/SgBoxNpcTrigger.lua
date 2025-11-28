autoImport("SgBaseNpcTrigger")
SgBoxNpcTrigger = class("SgBoxNpcTrigger", SgBaseNpcTrigger)

function SgBoxNpcTrigger:onExecute()
  SgAIManager.Me():Handle_PushBox(self.m_tid, self.m_uid)
  self:SetBoxVisible(false)
  if self.m_isCanDelete then
    SgAIManager.Me():removeNpcTrigger(self.m_uid)
  elseif not self.m_isRepeat then
    FunctionVisitNpc.Me():UnRegisterVisitShow(self.m_uid)
  end
  for _, v in pairs(self.m_usedItems) do
    SgAIManager.Me():playerUseItem(v, 1, true)
  end
end

function SgBoxNpcTrigger:SetBoxVisible(v)
  if self.m_creature then
    self.m_creature:SetVisible(v, LayerChangeReason.HidingSkill)
  end
end

function SgBoxNpcTrigger:Box_PlaceTo(p)
  if self.m_creature then
    self.m_creature:Client_PlaceTo(p, true)
  end
end
